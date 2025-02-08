# genius-builder


## Android Multi-Platform Builder

This repository provides a Docker image to build Android libraries for multiple platforms (ABIs) using the Android NDK and CMake.


### Features

- Builds Android libraries for multiple ABIs (e.g., `arm64-v8a`, `armeabi-v7a`, `x86`, `x86_64`).
- Builds Linux applications and libraries for multiple ABIs (e.g., `x86`, `x86_64`).
- Uses the latest Android NDK and CMake.
- Easily customizable for your project.


## Prerequisites

- Docker installed on your system.
- Basic knowledge of Docker and Android NDK.


## Usage

1. Clone the Repository
    ```bash
    git clone https://github.com/kopsha/genius-builder.git
    cd genius-builder
    ```
1. Build the Docker image with the provided `Dockerfile`:
    ```bash
    docker build -t android-builder .
    ```
1. Run the Docker Container
    ```bash
    docker run --rm -v $(pwd):/workspace android-builder
    ```
1. Capture Outputs, the built libraries will be available in the `out/` directory, organized by ABI:
    ```
    output/
    ├── arm64-v8a/
    │   └── libyourlibrary.so
    ├── armeabi-v7a/
    │   └── libyourlibrary.so
    ├── x86/
    │   └── libyourlibrary.so
    └── x86_64/
        └── libyourlibrary.so
    ```

## Customization
- Modify the `Dockerfile` to include additional dependencies or tools.
- Update the `build` script to customize the build process for your project.


## Supported ABIs
- `arm64-v8a`
- `armeabi-v7a`
- `x86`
- `x86_64`


## License
This project is licensed under the **GPL-3 License**. See the [LICENSE](LICENSE) file for details.

---

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements.

