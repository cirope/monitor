#!/bin/bash
set -x

last_commit=$(git rev-parse --short HEAD)
file="deliverable/monitor-$last_commit.run"
rm -f $file

append() {
  echo "$*" >> $file
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
append "set -eu"
new_line

cat >> $file <<- SETUP
if [ ! -f docker-compose.yml ]; then
  echo "RUNNING SETUP..."

  echo "Enter the absolute monitor app path [/var/www/greditsoft.com/current]:"
  read monitor_old_path
  if [ "\$monitor_old_path" == "" ]; then
    monitor_old_path="/var/www/greditsoft.com/current"
  fi

  echo "Creating app structure..."
  mkdir -p volumes/monitor_storage/  \\
           volumes/monitor_data/     \\
           volumes/postgres/         \\
           volumes/postgres_restore/ \\
           volumes/redis/            \\
           log/monitor/              \\
           log/postgres/

  chmod -R 777 volumes/ log/

  echo "Creating PostgreSQL backup..."
  echo "The password of the postgres user will be prompted..."
  sudo su postgres pg_dumpall > volumes/postgres_restore/full_restore.sql
  chmod 444 volumes/postgres_restore/full_restore.sql

  echo "Creating Redis backup..."
  redis-cli save
  cp \$(redis-cli config get dir | tail -n 1)/dump.rdb volumes/redis/dump.rdb
  chmod 666 volumes/redis/dump.rdb

  echo "Converting environment file..."
  sed 's/production://g; s/^ *//g; s/: /=/g' \$monitor_old_path/config/application.yml > monitor.env

  echo "Stopping & Disabling Redis..."
  (sudo systemctl stop redis >> /dev/null 2>&1) || sudo systemctl stop redis-server
  sudo systemctl disable redis && sudo systemctl disable redis-server

  echo "Stopping & Disabling PostgreSQL..."
  sudo systemctl stop postgresql
  sudo systemctl disable postgresql

  echo "Stopping & Disabling Unicorn..."
  sudo systemctl stop unicorn
  sudo systemctl disable unicorn

  echo "Stopping & Disabling Sidekiq..."
  sudo systemctl stop sidekiq
  sudo systemctl disable sidekiq

  echo "Changing nginx app upstream..."
  echo "Enter the absolute nginx path [/etc/nginx]:"
  read nginx_path
  if [ "\$nginx_path" == "" ]; then
    nginx_path="/etc/nginx"
  fi

  sudo sed -i 's/server unix:\/run\/unicorn\/unicorn\.sock/server 127.0.0.7:3000/g' \$nginx_path/sites-enabled/monitor.cirope.com
fi
SETUP

new_line

append "# Variables:"

append 'echo "Injecting files..."'
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

append 'echo "Updating files..."'
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

append 'echo "Loading docker images"'
new_line

append '# Load docker images'
append 'echo $docker_images | base64 -di | docker load'
new_line

append 'echo "Recreating docker containers"'
new_line

append '# Refresh containers'
append 'docker-compose up -d --force-recreate'

chmod 777 $file

echo "Enjoy =D"
