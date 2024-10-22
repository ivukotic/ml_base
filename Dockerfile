FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu24.04

LABEL maintainer="Ilija Vukotic <ivukotic@cern.ch>"

ENV DEBIAN_FRONTEND=nonintercative

#################
#### curl/wget/software-properties-common
#################
RUN apt-get update && apt-get install \
    curl \
    wget \
    unzip \
    zip \
    vim \
    jq \
    rsync \
    software-properties-common -y

###################
#### CUDA stuff
###################

RUN echo "/usr/local/cuda-12.6/lib64/" >/etc/ld.so.conf.d/cuda.conf

# install cudnn
ARG OS=ubuntu2404
# ARG cudnn_version=8.2.4.15
ARG cudnn_version=8.6.0
ARG cuda_version=cuda12.6

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs && \
    echo "/host-libs/" >/etc/ld.so.conf.d/000-host-libs.conf

###################
#### ROOT
###################
RUN cd /opt && \
    wget -nv https://root.cern/download/root_v6.32.04.Linux-ubuntu24.04-x86_64-gcc13.2.tar.gz && \
    tar xzf root_v6.32.04.Linux-ubuntu24.04-x86_64-gcc13.2.tar.gz && \
    rm -f root_v6.32.04.Linux-ubuntu24.04-x86_64-gcc13.2.tar.gz && \
    cd /opt/root/ && \
    /bin/bash bin/thisroot.sh


RUN apt-get update && apt-get install -y --allow-unauthenticated \
    build-essential \
    git \
    libfreetype6-dev \
    libpng-dev \
    libxpm-dev \
    libzmq3-dev \
    kmod \
    pkg-config \
    python3-venv \
    python3-pip \
    python3-dev \
    software-properties-common \
    zlib1g-dev \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    xvfb \
    # python-opengl \
    libhdf5-dev \
    fonts-texgyre \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
