#!/bin/bash

# Function to check if rust is installed
check_rust_installed() {
    if command -v rustc >/dev/null 2>&1; then
        echo "Rust is already installed."
        return 0
    else
        return 1
    fi
}

# Function to check if C compiler is installed
check_c_compiler_installed() {
    if command -v gcc >/dev/null 2>&1 || command -v clang >/dev/null 2>&1; then
        echo "C compiler is already installed."
        return 0
    else
        return 1
    fi
}

# Function to install rust based on the platform
install_rust() {
    echo "Rust is not installed. Installing Rust..."

    # Detect the platform
    case "$(uname -s)" in
        Linux*)
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            ;;
        Darwin*)
            if ! xcode-select -p >/dev/null 2>&1; then
                echo "Xcode command line tools are not installed. Installing..."
                xcode-select --install
            fi
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "Please install Rust manually for Windows: https://www.rust-lang.org/tools/install"
            ;;
        *)
            echo "Unsupported platform. Please install Rust manually: https://www.rust-lang.org/tools/install"
            exit 1
            ;;
    esac

    # Add cargo to the PATH
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    fi
}

# Function to install a Rust library from Git
install_rust_library() {
    echo "Installing Rust library from Git..."
    if ! command -v cargo >/dev/null 2>&1; then
        echo "Cargo is not available. Please ensure Rust is properly installed."
        exit 1
    fi
    cargo install --git https://github.com/ClementNerma/tapo-rest
}


# Function to build and push a cross-platform Docker image
build_crossplatform_docker() {
    echo "Building and pushing cross-platform Docker image..."
    latest_release_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
    docker buildx create --use || echo "Docker buildx already set up."
    docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t registry.rlt.sk/tapo-rest-crossplatform:latest -t registry.rlt.sk/tapo-rest-crossplatform:$latest_release_tag --push .
#    # Tag the latest release
#    latest_release_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
#    docker tag registry.rlt.sk/tapo-rest-crossplatform:latest registry.rlt.sk/tapo-rest-crossplatform:$latest_release_tag
#    docker push registry.rlt.sk/tapo-rest-crossplatform:$latest_release_tag
}

# Main script
if check_rust_installed; then
    echo "Skipping Rust installation."
else
    install_rust
fi

if check_c_compiler_installed; then
    echo "Skipping C compiler installation."
else
    echo "C compiler is not installed. Please install GCC or Clang manually."
fi

install_rust_library
build_crossplatform_docker

echo "Setup complete."
