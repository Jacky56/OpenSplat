ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

ARG UBUNTU_VERSION
ARG TORCH_VERSION=2.2.1
ARG CUDA_VERSION=12.1.1
ARG CMAKE_CUDA_ARCHITECTURES=70;75;80
ARG CMAKE_BUILD_TYPE=Release

SHELL ["/bin/bash", "-c"]

# Env variables
ENV DEBIAN_FRONTEND noninteractive

# Prepare directories
WORKDIR /code

# Copy everything
COPY . ./

# Upgrade cmake if Ubuntu version is 20.04
RUN if [[ "$UBUNTU_VERSION" = "20.04" ]]; then \
        apt-get update && \
        apt-get install -y ca-certificates gpg wget && \
        wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
        echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
        apt-get update && \
        apt-get install kitware-archive-keyring && \
        echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal-rc main' | tee -a /etc/apt/sources.list.d/kitware.list >/dev/null; \
    fi

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    ninja-build \
    libopencv-dev \
    unzip \
    wget \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev \
    sudo && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Install CUDA
RUN bash .github/workflows/cuda/Linux.sh "ubuntu-${UBUNTU_VERSION}" ${CUDA_VERSION}

# Install libtorch
RUN wget --no-check-certificate -nv https://download.pytorch.org/libtorch/cu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2)/libtorch-cxx11-abi-shared-with-deps-${TORCH_VERSION}%2Bcu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2).zip -O libtorch.zip && \
    unzip -q libtorch.zip -d . && \
    rm ./libtorch.zip

# Configure and build \
RUN source .github/workflows/cuda/Linux-env.sh cu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2) && \
    mkdir -p build && \
    cd build && \
    cmake .. \
    -GNinja \
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} \
    -DCMAKE_PREFIX_PATH=/code/libtorch \
    -DCMAKE_INSTALL_PREFIX=/code/install \
    -DCMAKE_CUDA_ARCHITECTURES="${CMAKE_CUDA_ARCHITECTURES}" \
    -DCUDA_TOOLKIT_ROOT_DIR=${CUDA_HOME} && \
    ninja && ninja install 

RUN source .github/workflows/cuda/Linux-env.sh cu"${CUDA_VERSION%%.*}"$(echo $CUDA_VERSION | cut -d'.' -f2) && \
    git clone https://github.com/colmap/colmap.git && \
    cd colmap && \
    git checkout 3.9.1 && \
    mkdir build && \
    cd build && \
    cmake .. \
    -GNinja \
    -DCMAKE_CUDA_ARCHITECTURES="${CMAKE_CUDA_ARCHITECTURES}" \
    -DCUDA_TOOLKIT_ROOT_DIR=${CUDA_HOME} \
    -DCUDA_ENABLED=ON && \
    ninja && ninja install

ENV PATH=/code/build:$PATH
ENV OPENSPLAT_VERSION=1.1.3
# docker run --gpus all -v /home/jacky/source/op_compiled/data:/data  c /code/build/opensplat /data/input/toy -n 2000 -o /data/output/toy.ply
