
FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

ENV DEBIAN_FRONTEND=nonintercative

###################
#### CUDA stuff
###################
RUN echo "/usr/local/cuda-11.4/lib64/" >/etc/ld.so.conf.d/cuda.conf

# For CUDA profiling, TensorFlow requires CUPTI.
RUN echo "/usr/local/cuda-11.4/extras/CUPTI/lib64/" >>/etc/ld.so.conf.d/cuda.conf

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs && \
    echo "/host-libs/" >/etc/ld.so.conf.d/000-host-libs.conf


#################
#### curl/wget/software-properties-common
#################
RUN apt-get update && apt-get install curl wget software-properties-common -y
# for newer python
RUN add-apt-repository ppa:deadsnakes/ppa

###################
#### ROOT
###################
RUN cd /opt && \
    wget -nv https://root.cern/download/root_v6.22.00.Linux-ubuntu18-x86_64-gcc7.5.tar.gz && \
    tar xzf root_v6.22.00.Linux-ubuntu18-x86_64-gcc7.5.tar.gz && \
    rm -f root_v6.22.00.Linux-ubuntu18-x86_64-gcc7.5.tar.gz && \
    cd /opt/root/ && \
    /bin/bash bin/thisroot.sh

####################
#### Ubuntu packages
####################
# bazel is required for rebuild of Tensorflow
#RUN apt-get install openjdk-8-jdk -y &&  \
#    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
#    curl https://bazel.build/bazel-release.pub.gpg | apt-key add -


####################
# xvfb, python-opengl, python3-tk, swig, ffmpeg - this is needed for visualizations in OpenAI 

RUN apt-get update && apt-get install -y --allow-unauthenticated \
    build-essential \
    git \
    libfreetype6-dev \
    libpng-dev \
    libxpm-dev \
    libzmq3-dev \
    module-init-tools \
    pkg-config \
    # python3.8 - comes with ubuntu 20.04\
    python3-venv \
    python-pip \
    python3-pip \
    python3-dev \
    rsync \
    software-properties-common \
    unzip \
    zip \
    zlib1g-dev \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    vim \
    # bazel \
    xvfb \
    python-opengl \
    libhdf5-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN apt-get install -y --allow-unauthenticated \
#     libssl-dev libbz2-dev libreadline-dev libsqlite3-dev llvm \
#     libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev \
#     liblzma-dev python-openssl

###################################
## cmake swig python3-tk ffmpeg \
## xvfb python-opengl \
###################################

RUN python -m pip install --upgrade pip setuptools wheel
RUN python3 -m pip install --upgrade pip setuptools wheel
RUN python3.8 -m pip install --upgrade pip setuptools wheel


