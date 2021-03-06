# ex3mp/apache

## INFOS

- vhosts points at /var/www/public (./app/public)
- default MySQL DB is website and you can connect via 
  - host db
  - user docker
  - pass docker

## REQUIRES

jwilder/nginx-proxy and a network

## TESTED SUPPORTS

- Processwire
- CraftCMS

## ENVS

- APACHE_SERVERNAME
- APACHE_SERVERALIAS

## INSTALL

1. create a network `create network with: docker network create nginx-proxy`

2. startup your "master" nginx-proxy (example down here)

```
version: '2'
services:
  nginx-proxy:
    restart: unless-stopped
    image: jwilder/nginx-proxy
    container_name: nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
networks:
  default:
    external:
      name: nginx-proxy
```

3. create a new folder and copy the content from exampel in there.

4. edit the docker-compose.yml (APACHE_SERVERALIAS, VIRTUAL_HOST) and ad the server alias to your dns/hosts (mac: `sudo vi /etc/hosts` and `127.0.0.1 docker.local`)

5. run docker-compose up -d

