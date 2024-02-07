#!/bin/bash

sudo mkdir -p /mnt/ssd/gitlab
export GITLAB_HOME=/mnt/ssd/gitlab

##################################################################
# Before docker compose up Command, create a docker-compose.yaml #
##################################################################

docker compose up -d