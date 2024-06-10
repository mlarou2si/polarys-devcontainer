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
        openssh-client \
        sqlfluff \
        rpm \
        llvm \
        libxml2-dev \
        libxmlsec1-dev


# Python and poetry installation
ARG HOME="/home/$USER"
ARG DBT_CORE_VERSION=1.8.0
ARG DBT_SNOWFLAKE_VERSION=1.8.1

RUN echo "Installing poetry" \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && export PATH="${HOME}/.local/bin:$PATH"
    

RUN echo "Install dbt core (make a version env!)" \ 
    && pip install dbt-core=="${DBT_CORE_VERSION}" dbt-snowflake=="${DBT_SNOWFLAKE_VERSION}"
COPY --chmod=a-w .dbt ${HOME}/.dbt
    
#RUN echo "Install snowsql and configure the connection to snowflake" \
#    && curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.3/linux_x86_64/snowflake-snowsql-1.3.0-1.x86_64.rpm \
#    && rpm -ivh snowflake-snowsql-*.rpm \
#    && rm -r snowflake-snowsql-*.rpm
#COPY --chmod=a-w config.toml ${HOME}/.config/snowflake/


# SSH config
RUN eval "$(ssh-agent -s)"
COPY .bash_profile ${HOME}/



ENV SHELL /bin/bash

USER $USER
WORKDIR /workspace
EXPOSE 443 80

CMD ["/bin/bash"]