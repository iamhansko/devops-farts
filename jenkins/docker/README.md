# Jenkins

## Installation

[Docker](https://www.jenkins.io/doc/book/installing/docker/)

```bash
#!/bin/bash
docker run --name jenkins-docker --rm --detach --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume /mnt/ssd/jenkins-docker-certs:/certs/client --volume /mnt/ssd/jenkins-data:/var/jenkins_home --publish 2376:2376 docker:dind --storage-driver overlay2

####################################################
# Before docker build Command, create a Dockerfile #
####################################################

docker build -t jenkins-blueocean:2.426.3-1 .

docker run --name jenkins-blueocean --restart=on-failure --detach --network jenkins --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro jenkins-blueocean:2.426.3-1

# Check Initial Password
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```