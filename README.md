# Sentiric Llama.cpp Base Image

Docker base image with pre-built llama.cpp as shared library for C++ projects.

[![Build and Push Llama.cpp Docker Image](https://github.com/sentiric/sentiric-llama-cpp/actions/workflows/build.yml/badge.svg)](https://github.com/sentiric/sentiric-llama-cpp/actions/workflows/build.yml)

## Features

- Built on stable sentiric-vcpkg-base
- Llama.cpp as shared library (`libllama.so`)
- System-wide installation (headers and libraries)
- OpenCL support enabled
- Optimized for external linking

## Usage

```dockerfile
FROM ghcr.io/sentiric/sentiric-llama-cpp:latest

# Your C++ project can now link against llama.cpp
# CMakeLists.txt:
# find_package(llama REQUIRED)
# target_link_libraries(your_target PRIVATE llama)
```

## Development

The image provides:

- Headers: /usr/local/include/llama.h
- Library: /usr/local/lib/libllama.so
- CMake config: /usr/local/lib/cmake/llama/

## Tags

- latest - Stable CPU version with OpenCL
- {commit-hash} - Specific llama.cpp versions
