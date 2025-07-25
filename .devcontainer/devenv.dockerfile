FROM ubuntu:noble

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# install prerequisists
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt install -y \
      build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
      zip unzip vim wget lsb-release less postgresql-client

# install python things
ARG PYTHON_VERSION=3.13
ARG POETRY_VERSION=2.1.3

ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${HOME}/.local/bin:$PATH"
RUN curl https://pyenv.run | bash \
    && pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION} \
    && pip install pre-commit \
    && pip install poetry==${POETRY_VERSION}

# install ruby things \
ENV RUBY_VERSION=1:3.2~ubuntu1
ENV TRMNLP_VERSION=0.5.6

RUN apt install -y ruby-full=${RUBY_VERSION} \
    && gem update \
    && gem install trmnl_preview -v ${TRMNLP_VERSION}

# create and set user
ARG USER=ubuntu
ARG HOME="/home/${USER}"
USER ${USER}