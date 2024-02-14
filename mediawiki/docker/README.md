# MediaWiki + Docker

## Installation

[Docker](https://hub.docker.com/_/mediawiki)

[Docker Compose](https://github.com/docker-library/docs/tree/master/mediawiki#-via-docker-compose-or-docker-stack-deploy)

1. Set `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` (docker-compose.yaml) 

2. `docker compose up -d`

3. Go to "http://localhost:8080"

4. Set up the wiki

    - Database Type : MariaDB, MySQL, ...
    - Database Host : mediawiki_db
    - Database Name : your `MYSQL_DATABASE` value
    - Database Table Prefix : 
    - Database User Name : your `MYSQL_USER` value
    - Database Password : your `MYSQL_PASSWORD` value

5. Download LocalSettings.php

6. `docker compose down`

7. Move LocalSettings.php to ./

    ```
    mediawiki/docker/
    ┣ db/
    ┣ examples/
    ┣ images/
    ┣ skins/
    ┣ docker-compose.yaml
    ┣ LocalSettings.php
    ┗ README.md
    ```

8. Uncomment `- ./LocalSettings.php:/var/www/html/LocalSettings.php` (docker-compose.yaml)

9. `docker compose up -d`

10. Go to "http://localhost:8080"


## Configuration

[Nginx](https://www.nginx.com/resources/wiki/start/topics/recipes/mediawiki/)

```shell
# /etc/nginx/sites-enabled/default

server {
    server_name wiki.scg.skku.ac.kr;
    root /var/www/mediawiki;
    index  index.php;

    client_max_body_size 5m;
    client_body_timeout 60;

    location / {
        try_files $uri $uri/ @rewrite;
    }
    location @rewrite {
        rewrite ^/(.*)$ /index.php?title=$1&$args;
    }
    location ^~ /maintenance/ {
        return 403;
    }
     location /rest.php {
        try_files $uri $uri/ /rest.php?$args;
    }
    location ~ \.php$ {
        include fastcgi_params;
        # fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $request_filename;
    }
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        try_files $uri /index.php;
        expires max;
        log_not_found off;
    }
    location = /_.gif {
        expires max;
        empty_gif;
    }
    location ^~ /cache/ {
        deny all;
    }
    location /dumps {
        root /var/www/mediawiki/local;
        autoindex on;
    }
}
```


[Liberty Skin](https://github.com/librewiki/liberty-skin)

[Liberty Skin Navbar](https://librewiki.net/wiki/%EB%AF%B8%EB%94%94%EC%96%B4%EC%9C%84%ED%82%A4:Liberty-Navbar)