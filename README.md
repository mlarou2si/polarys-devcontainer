# polarys-devcontainer


echo "$REGISTRY_PASSWORD" | docker login -u "$REGISTRY_USER" --password-stdin "$REGISTRY_REPO"


docker build . -t mlarou2si/polarys:test
docker push mlarou2si/polarys:test