set -e
DOCKER_REPOSITORY=yudonguk/docker-test
DOCKER_TAGS=`wget -qO - https://registry.hub.docker.com/v1/repositories/$DOCKER_REPOSITORY/tags | grep -Eo '(?:"name"\s*:\s*)"[^"]+"' | grep -Eo '"[^"]+"$' | grep -Eo '[^"]+'`
for tag in $DOCKER_TAGS; do
  echo; echo;
  echo -e "\x1B[34m-- Compiler: $tag\x1B[0m";
  buildDir=build/$tag;
  mkdir -p "$buildDir";
  docker run --rm -v "$PWD":"/root/`basename $PWD`" -w "/root/`basename $PWD`/$buildDir" $DOCKER_REPOSITORY:$tag cmake ../.. && cmake --build .;
done