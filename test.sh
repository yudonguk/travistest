
DOCKER_REPOSITORY=yudonguk/bicomc-docker
DOCKER_TAGS=`wget -qO - https://registry.hub.docker.com/v1/repositories/$DOCKER_REPOSITORY/tags | grep -Eo '(?:"name"\s*:\s*)"[^"]+"' | grep -Eo '"[^"]+"$' | grep -Eo '[^"]+'`

#mkdir -p docker
#docker pull -a $DOCKER_REPOSITORY || exit 1;

for tag in $DOCKER_TAGS; do
  echo; echo;
  echo -e "\x1B[34m-- Compiler: $tag\x1B[0m";
  
  if [[ -f docker/$tag.tar ]]; then
    docker load -i docker/$tag.tar;
  fi

  sourceDir="/root/`basename $PWD`";
  buildDir="build/$tag";

  mkdir -p "$buildDir";

  buildCmd="cmake ../.. && cmake --build .";
  docker run --rm -v "$PWD":"$sourceDir" -w "$sourceDir/$buildDir" $DOCKER_REPOSITORY:$tag bash -c "$buildCmd";
  if [ $? -ne 0 ]; then
    exit 1;
  fi

  docker save -o docker/$tag.tar $DOCKER_REPOSITORY:$tag;
done
