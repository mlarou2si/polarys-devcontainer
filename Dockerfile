FROM python:3.11-slim

ARG USER=polarys
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV USER=${USER}

# Create the user
RUN groupadd --gid $USER_GID $USER \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER


# install lib dependencies
RUN apt-get update \ 
    && apt-get install -y build-essential --no-install-recommends \
        git \
        curl \
        rpm \
        llvm \
        libxml2-dev \
        libxmlsec1-dev

# Python and poetry installation
ARG HOME="/home/$USER"
#ARG PYTHON_VERSION=3.11

#ENV PYENV_ROOT="${HOME}/.pyenv"
#ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${HOME}/.local/bin:$PATH"

RUN echo "Installing poetry" \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && export PATH="${HOME}/.local/bin:$PATH" \
    # Install dbt core (make a version env!)
    && pip install dbt-core=="1.8.0" dbt-snowflake=="1.8.1" \
    # Install snowsql and configure the connection to snowflake
    && curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowflake-snowsql-1.3.0-1.x86_64.rpm \
    && rpm -ivh snowflake-snowsql-*.rpm \
    && rm -r snowflake-snowsql-*.rpm


USER $USER
WORKDIR /workspace
CMD ["/bin/bash"]