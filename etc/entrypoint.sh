#!/bin/sh

if [ ! -z "${DBT_PROJECT_NAME}" ];then
    cd && mkdir .dbt
    echo "$DBT_PROJECT_NAME:" > .dbt/profiles.yml
    cat /tmp/dbt/dbt_profiles.yml >> .dbt/profiles.yml
    chmod a-w ${HOME}/.dbt/profiles.yml
  else
    echo "Missing DBT_PROJECT_NAME environment variable !" 1>&2
    exit 1
fi

# "Updating the certificates"
sudo update-ca-certificates 

# "SSH keys"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

exec "$@"
