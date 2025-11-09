# Dockerfile
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

# Create build directory and build (CPU + OpenCL only - no CUDA in GitHub Actions)
RUN mkdir -p /tmp/llama.cpp/build \
    && cd /tmp/llama.cpp/build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
        -DLLAMA_BUILD_SERVER=ON \
        -DLLAMA_SERVER_VERBOSE=ON \
        -DGGML_CUDA=OFF \
        -DLLAMA_CLBLAST=ON \
        -DLLAMA_METAL=OFF \
        -DBUILD_SHARED_LIBS=ON \
    && cmake --build . --config ${CMAKE_BUILD_TYPE} -j$(nproc)

# Install to system path
RUN cd /tmp/llama.cpp/build \
    && cmake --install . \
    && mkdir -p /usr/local/include/llama \
    && cp ../*.h /usr/local/include/llama/

# Create symbolic links for easy access
RUN ln -sf /usr/local/bin/server /usr/local/bin/llama-server \
    && ln -sf /usr/local/bin/main /usr/local/bin/llama-cli

# Cleanup
RUN rm -rf /tmp/llama.cpp

# Create app directory
WORKDIR /app

# Test the installation
RUN llama-server --help || echo "Server help displayed"

CMD ["/bin/bash"]
