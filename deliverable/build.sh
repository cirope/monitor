#!/bin/bash
set -x

last_commit=$(git rev-parse --short HEAD)
file="deliverable/monitor-$last_commit.run"
rm -f $file

append() {
  echo $1 >> $file
}

new_line() {
  echo -e "\n" >> $file
}

grep_in_docker_compose() {
  grep -oP "$*" docker-compose.yml | sort | uniq | tr '\n' ' '
}

# Pull all the service images
docker-compose pull --ignore-pull-failures

# Build "smallest" image
docker build --squash -t monitor:latest .

# Get services images
images=$(grep_in_docker_compose "image: \K\w+:.*")

# Get env files without monitor.env (specific installation settings)
env_files=$(grep_in_docker_compose "\- \K\w+\.env" | sed 's/monitor.env//g')

append "#!/bin/bash"
new_line

append "# Variables:"

echo "Injecting docker-compose.yml"
append "docker_compose='$(base64 docker-compose.yml)'"

echo "Injecting env_files: $env_files"
for env_file in ${env_files[@]}; do
  env_file_var=$(basename $env_file .env)
  append "$env_file_var='$(base64 $env_file)'"
done
new_line

echo "Injecting images: $images"
append "docker_images='"
docker save $images | xz -T0 | base64 >> $file # real-time inject
append "'"
new_line

append '# Update docker-compose.yml'
append 'echo $docker_compose | base64 -di > docker-compose.yml'
new_line

append '# Update env files'
for env_file in ${env_files[@]}; do
  env_file_var=$(basename $env_file .env)
  append "echo \$$env_file_var | base64 -di > $env_file"
done
new_line

append '# Load docker images'
append 'echo $docker_images | base64 -di | docker load'
new_line

append '# Refresh containers'
append 'docker-compose stop'
append 'docker-compose up -d --force-recreate'

chmod 777 $file

echo "Enjoy =D"
