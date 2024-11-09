# Elemental BFGMINER Dockerfile
# Requirements:
#   Install the CUDA or OpenCL drivers
# Build:
#   docker build .
# Docker Hub:
#   https://hub.docker.com/repository/docker/ 
FROM nvidia/opencl:devel-ubuntu18.04

LABEL maintainer="x"
LABEL version="0.0.1"
LABEL description="Docker image of BFGMINER"
ARG DEBIAN_FRONTEND=nointeractive
RUN apt update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
ENV PACKAGES="\
  git \
  build-essential \
  software-properties-common \
  libcurl4-openssl-dev \
  ocl-icd-* \
  opencl-headers \
  openssh-server \
  ocl-icd-opencl-dev\
  ubuntu-drivers-common \
  pkg-config \
  libtool \
  clinfo \
  autoconf \
  automake \
  libjansson-dev \
  libevent-dev \
  uthash-dev \
  nodejs \
  vim \
  python3 \
  libdb++-dev \
  wget \
  libboost-chrono-dev \
  libboost-filesystem-dev \
  libboost-test-dev \
  libboost-thread-dev \
  libevent-dev \
  libminiupnpc-dev \
  libssl-dev \
  libzmq3-dev \ 
  help2man \
"
RUN apt update && apt install --no-install-recommends -y $PACKAGES  && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
# Clone repo
RUN git clone https://github.com/theowiz/bfgminer.git /root/bfgminer
WORKDIR /root/bfgminer
# Update Github paths
RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN ./autogen.sh
# Ensure built with opencl compiled:  
RUN ./configure --enable-opencl
RUN make
WORKDIR /root
# Shell access
CMD ["bash"]
# Directory:
#
# root@host:~$ ls
# bfgminer
#
# root@host:~$ 
#
# 1 x GPUs
# /root/bfgminer/bfgminer -S opencl:auto -o http://<elemental-node-host>:8332 -u username -p password --set-device OCL:kernel=poclbm --generate-to <address> 

# 2 x GPUs
# /root/bfgminer/bfgminer -S opencl:auto -o http://<elemental-node-host>:8332 -u username -p password --set-device OCL0:kernel=poclbm --set-device OCL1:kernel=poclbm --generate-to <address>

