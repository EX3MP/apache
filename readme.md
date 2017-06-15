# ex3mp/apache
## REQUIRES
jwilder/nginx-proxy and a network

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
```

3. create a new folder and copy the content from exampel in there.

4. edit the docker-compose.yml (APACHE_SERVERALIAS, VIRTUAL_HOST) and ad the server alias to your dns/hosts (mac: `sudo vi /etc/hosts` and `127.0.0.1 docker.local`)

5. run docker-compose up -d

