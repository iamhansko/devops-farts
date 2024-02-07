# Nginx Proxy Manager

## Initial Acount
Email Address : admin@example.com
Password : changeme

## Connect Docker Network 

Nginx Proxy Manager Container <-> Target Container

`docker network connect nginx-proxy-manager_default YOUR_TARGET_CONTAINER_NAME`

Then, go to Nginx Proxy Manager Dashboard

Set Proxy Hosts ( DESTINATION : http://YOUR_TARGET_CONTAINER_NAME:TARGET_PORT ) 