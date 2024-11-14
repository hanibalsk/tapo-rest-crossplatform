
# Tapo REST Docker Setup

Original Repository: [Tapo REST](https://github.com/ClementNerma/tapo-rest)

## Prerequisites

- Docker installed (including Docker Compose)
- Rust installed if you need to build locally

## Building the Docker Image

To build the Docker image, use the following command:

```sh
docker build -t registry.rlt.sk/tapo-rest-crossplatform:latest .
```

This command will build the Docker image using the provided Dockerfile.

## Running the Docker Container

You can run the Docker container with the following command:

```sh
docker run -d \
  -e DEVICES_CONFIG_PATH=config.json \
  -e PORT=4666 \
  -e AUTH_PASSWORD=somepass \
  -p 4666:4666 \
  registry.rlt.sk/tapo-rest-crossplatform:latest
```

This command runs the container in detached mode with the required environment variables set and exposes port 4666.

## Docker Compose

A Docker Compose configuration is also provided. To use Docker Compose, run:

```sh
docker-compose up -d
```

This will start the `tapo-rest` service with the configuration provided in `docker-compose.yml`.

## Environment Variables

- `DEVICES_CONFIG_PATH`: Path to the devices configuration file (default: `config.json`).
- `PORT`: The port on which the application will run (default: `4666`).
- `AUTH_PASSWORD`: Password for authentication.

## Example Configuration

Below is an example configuration file (`config.json`) that can be used with the application:

```json
{
    "account": {
        "username": "your_email@example.com",
        "password": "your_password"
    },
    "devices": [
        {
            "name": "living-room-bulb",
            "device_type": "L530",
            "ip_addr": "192.168.1.100"
        }
    ]
}
```

Replace `your_email@example.com` and `your_password` with your actual Tapo account credentials. Update the `devices` section with your device details.

## Updating the Docker Image Tag

The Docker image can be tagged with the latest release tag by using:

```sh
git tag v0.0.1
# Push the tag to the remote repository
git push origin v0.0.1
```

After tagging, rebuild and push the Docker image:

```sh
docker build -t registry.rlt.sk/tapo-rest-crossplatform:v0.0.1 .
docker push registry.rlt.sk/tapo-rest-crossplatform:v0.0.1
```

## License

This project is licensed under the MIT License.
