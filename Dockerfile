# Final image
FROM ubuntu:22.04

ENV USER miniflask
ARG USERID

RUN useradd -u ${USERID} -m -d /home/${USER} ${USER}

## Silence error messages
ENV TERM linux

## Bash instead of shell
SHELL ["/bin/bash", "-c"]

## Install utils
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    unzip \
    wget \
    zip \
    supervisor \
    ffmpeg \
    libsm6 \
    libxext6 \
    build-essential \
    python3-dev \
    python3-venv \
    redis-server \
    nginx

WORKDIR /home/${USER}

## Copy requirements and install them
# (Before copying the rest so that this part is not rerun unless requirements change)
COPY --chown=${USER} ./requirements.txt ./requirements.txt
RUN python3 -m venv venv
RUN source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt

# Install components
COPY --chown=${USER} ./ ./Minimal-Flask/
COPY /docker-confs/nginx.conf /etc/nginx/conf.d/minimalflask.conf

EXPOSE 8002

RUN mkdir -p var/dramatiq/

## Run command at each container launch
CMD export LC_ALL=C.UTF-8 && export LANG=C.UTF-8 && \
    source venv/bin/activate && \
    supervisord -c api/docker-confs/supervisord.conf