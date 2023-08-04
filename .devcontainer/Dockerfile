# pytorch image base
# FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel as base
# FROM us-docker.pkg.dev/vertex-ai/training/pytorch-gpu.1-9:latest as base

FROM dreamquark/brain-base-python:3.6-cuda9-cudnn7 as base
# FROM dreamquark/brain-base-python:3.7-cuda9-cudnn7 as base
# # FROM pytorch/pytorch:nightly-devel-cuda9.2-cudnn7 as base

ENV NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES},display \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# environment variables
ARG USERNAME=waybaba
ENV UDATADIR=/data \
    UPRJDIR=/code \
    UOUTDIR=/output \
    UDEVICEID=docker

### apt
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    wget \
    ffmpeg \
    libsm6 \
    libxext6 \
    htop \
    vim \
    libosmesa6-dev \
    libgl1-mesa-dev
    # && rm -rf /var/lib/apt/lists/*

# RUN conda install -y --name base -c conda-forge \
#     python=3.6
    # && rm -rf /var/lib/apt/lists/*

### pip
RUN pip3 install --upgrade pip
RUN pip install dotmap==1.2.20 \
    future==0.16.0 \
    gpflow==1.5.1 \
    gym==0.9.4 \
    mujoco-py==0.5.7 \
    numpy==1.14.0 \
    scipy==0.19.0 \
    tensorflow-gpu==1.7 \
    tqdm==4.19.4 \
    protobuf==3.6.1 \
    grpcio==1.23.0 \
    termcolor \
    pandas==1.0.2


# Non-root user creation and enter
ARG USER_UID=1666
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir -p /home/$USERNAME/.vscode-server /home/$USERNAME/.vscode-server-insiders \
    && chown ${USER_UID}:${USER_GID} /home/$USERNAME/.vscode-server* \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && echo $USERNAME ALL=\(ALL\) NOPASSWD:ALL >> /etc/sudoers \
    && usermod -a -G audio,video $USERNAME \
    && chmod 0440 /etc/sudoers.d/

USER $USERNAME
ENV HOME /home/$USERNAME
WORKDIR $HOME


# install mujoco
RUN mkdir ~/.mujoco
RUN wget https://github.com/deepmind/mujoco/releases/download/2.1.0/mujoco210-linux-x86_64.tar.gz
RUN tar -zxvf mujoco210-linux-x86_64.tar.gz
RUN mv mujoco210 ~/.mujoco/
RUN rm mujoco210-linux-x86_64.tar.gz
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.mujoco/mujoco210/bin

USER root

# # install d4rl
# RUN pip install git+https://github.com/Farama-Foundation/d4rl@master#egg=d4rl
# RUN pip install dm_control mujoco-py==2.1.2.14

# # install diffuser
# RUN pip install einops typed-argument-parser scikit-video==1.1.11 scikit-image==0.17.2

# end
# USER $USERNAME
USER root
CMD	sleep infinity