ARG PYTHON_VERSION=3.11

FROM python:${PYTHON_VERSION}-slim-buster AS root

ARG DEBIAN_FRONTEND=noninteractive
ARG USER=polarys

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \ 
    && apt-get install -y build-essential --no-install-recommends make \
        ca-certificates \
        git \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev

# manage the certifications
#COPY ./certs/* /usr/local/share/ca-certificates/
#RUN update-ca-certificates

# Python and poetry installation
USER $USER_NAME
ARG HOME="/home/$USER_NAME"

#ENV PYENV_ROOT="${HOME}/.pyenv"
#ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${HOME}/.local/bin:$PATH"

RUN echo "done 0" \
    && curl -sSL https://install.python-poetry.org | python3 -

        
USER $USER_NAME
WORKDIR /workspace
