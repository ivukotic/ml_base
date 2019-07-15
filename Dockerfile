
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>

###################
#### CUDA stuff
###################
RUN echo "/usr/local/cuda-10.0/lib64/" >/etc/ld.so.conf.d/cuda.conf

# For CUDA profiling, TensorFlow requires CUPTI.
RUN echo "/usr/local/cuda/extras/CUPTI/lib64/" >>/etc/ld.so.conf.d/cuda.conf

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs && \
    echo "/host-libs/" >/etc/ld.so.conf.d/000-host-libs.conf


#################
#### curl/wget
#################
RUN apt-get update && apt-get install curl wget -y


###################
#### ROOT
###################
RUN cd /opt && \
    wget -nv https://root.cern/download/root_v6.18.00.Linux-ubuntu16-x86_64-gcc5.4.tar.gz && \
    tar xzf root_v6.18.00.Linux-ubuntu16-x86_64-gcc5.4.tar.gz && \
    rm -f root_v6.18.00.Linux-ubuntu16-x86_64-gcc5.4.tar.gz && \
    cd /opt/root/ && \
    /bin/bash bin/thisroot.sh

####################
#### Ubuntu packages
####################
# bazel is required for some TensorFlow projects
RUN apt-get install openjdk-8-jdk -y &&  \
    echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add -


####################
# xvfb, python-opengl, python3-tk, swig, ffmpeg - this is needed for visualizations in OpenAI 

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt-get install -y --allow-unauthenticated \
    build-essential \
    curl \
    git \
    libfreetype6-dev \
    libpng12-dev \
    libxpm-dev \
    libzmq3-dev \
    module-init-tools \
    pkg-config \
    python \
    python-dev \
    python3 \
    rsync \
    software-properties-common \
    unzip \
    zip \
    zlib1g-dev \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    vim \
    wget \
    bazel \
    python-pip \
    python3-pip \
    xvfb \
    python-opengl \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

###################################
## cmake swig python3-tk ffmpeg \
## xvfb python-opengl \
###################################

RUN pip install --upgrade pip setuptools wheel && \
    pip3 install --upgrade pip setuptools wheel
