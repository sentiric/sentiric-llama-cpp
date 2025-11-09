# sentiric-llama-cpp/Dockerfile
FROM ghcr.io/sentiric/sentiric-vcpkg-base:latest

# Build arguments
ARG LLAMA_CPP_VERSION=master
ARG CMAKE_BUILD_TYPE=Release

# Environment variables
ENV LLAMA_CPP_VERSION=${LLAMA_CPP_VERSION}
ENV CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

# Install system dependencies for OpenCL
RUN apt-get update && apt-get install -y \
    ocl-icd-opencl-dev \
    clinfo \
    && rm -rf /var/lib/apt/lists/*

# Clone and build llama.cpp
WORKDIR /tmp

RUN git clone https://github.com/ggerganov/llama.cpp.git \
    && cd llama.cpp \
    && git checkout ${LLAMA_CPP_VERSION}

# Build as shared library for external linking
RUN mkdir -p /tmp/llama.cpp/build \
    && cd /tmp/llama.cpp/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
        -DLLAMA_BUILD_SERVER=OFF \
        -DGGML_CUDA=OFF \
        -DLLAMA_CLBLAST=ON \
        -DLLAMA_METAL=OFF \
        -DBUILD_SHARED_LIBS=ON \
    && cmake --build . --config ${CMAKE_BUILD_TYPE} -j$(nproc)

# Install to system paths
RUN cd /tmp/llama.cpp/build \
    && cmake --install .

# Verify installation
RUN ldconfig && \
    find /usr/local -name "*llama*" -o -name "*ggml*" | head -10

# Cleanup build files
RUN rm -rf /tmp/llama.cpp

# Create working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]