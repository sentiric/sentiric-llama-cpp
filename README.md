# Sentiric Llama.cpp Base Image

Docker base image with pre-built llama.cpp including GPU support for GGUF models.

## Features

- ✅ CPU acceleration
- ✅ NVIDIA CUDA support
- ✅ OpenCL support  
- ✅ GGUF model format
- ✅ Built-in HTTP server
- ✅ Quantized model support (q4, q8, etc.)

## Usage

```bash
# Pull the image
docker pull ghcr.io/sentiric/sentiric-llama-cpp:latest

# Use as base image
FROM ghcr.io/sentiric/sentiric-llama-cpp:latest
```
