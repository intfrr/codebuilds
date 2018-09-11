#!/bin/bash

# dock.sh
#
# Run the given script in the given container, passing in our
# environment variables.  THE BASH SCRIPT MUST BE A RELATIVE
# PATH.
#
# usage: dock.sh <docker_hub_image> <bash_script_to_run_in_container>

echo "Checking if $1 exists locally"
if [[ "$(docker images -q $1 2> /dev/null)" != "" ]]; then
  echo "$1 does not exist locally, retrieving from hub"
  docker pull "$1";
fi

docker images; 

echo "Current directory is [$(pwd)]"

echo "Binding workspace and executing script";
docker run -it --security-opt apparmor:unconfined --cap-add SYS_ADMIN -e GITHUB_TOKEN=$3 -v $(pwd)/cobbler:/cobbler $1 /bin/bash -c "cd /kitchen && ${2}";
