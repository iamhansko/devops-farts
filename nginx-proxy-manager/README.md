# Nginx Proxy Manager

## Initial Acount
Email Address : admin@example.com
Password : changeme

## Connect Docker Network 

Network Mode : Bridge

<img src="docs\assets\docker-bridge-network.png">

Nginx Proxy Manager Container <-> Target Container

<img src="docs\assets\npm-bridge-network.png">

Connect Docker Network

`docker network connect nginx-proxy-manager_default YOUR_TARGET_CONTAINER_NAME`

Then, go to Nginx Proxy Manager Dashboard

Set Proxy Hosts ( DESTINATION : http://YOUR_TARGET_CONTAINER_NAME:TARGET_PORT ) 