# Base image with vcpkg and build tools
FROM ghcr.io/sentiric/sentiric-vcpkg-base:latest

ARG LLAMA_CPP_VERSION="b2787"
ARG LLAMA_CPP_REPOSITORY="https://github.com/ggerganov/llama.cpp.git"

# Clone and build llama.cpp as a shared, INSTALLABLE library
RUN git clone ${LLAMA_CPP_REPOSITORY} /opt/llama.cpp && \
    cd /opt/llama.cpp && \
    git checkout ${LLAMA_CPP_VERSION} && \
    cmake -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DLLAMA_INSTALL=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build build --target install -j $(nproc)

# Final image is clean
WORKDIR /
