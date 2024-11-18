FROM rust:latest AS builder

# Install necessary tools
RUN apt-get update && apt-get install -y gcc clang build-essential

# Set the working directory
WORKDIR /usr/src/tapo-rest

# Clone the repository with full history
RUN git clone https://github.com/ClementNerma/tapo-rest.git . && git fetch --all && git checkout cb85e85

# Build the Rust application
RUN cargo build --release

# Create a minimal runtime image
FROM debian:bookworm-slim

# Set working directory
WORKDIR /usr/local/bin

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/tapo-rest/target/release/tapo-rest ./

# Copy the run script
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# Specify entrypoint
ENTRYPOINT ["/usr/local/bin/run.sh"]
