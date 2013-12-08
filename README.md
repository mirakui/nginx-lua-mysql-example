nginx-lua-mysql-example
=======================

```sh
$ git clone https://github.com/mirakui/nginx-lua-mysql-example.git
$ cd nginx-lua-mysql-example
$ sudo docker build -t ngx .
$ sudo docker run -d ngx
b32680fbc44ee55d309e8377963f9015fcb3e6733f55dc580276c9eff1952ba5
$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS               NAMES
b32680fbc44e        ngx:latest          /bin/sh -c /usr/loca   4 seconds ago       Up 2 seconds        3306/tcp, 80/tcp    angry_heisenberg
$ sudo docker inspect b32680fbc44e | jq '.[0].NetworkSettings.IPAddress'
"172.17.0.17"
$ curl 172.17.0.17/counter
counter: 1
$ curl 172.17.0.17/counter
counter: 2
$ curl 172.17.0.17/counter
counter: 3
$ curl 172.17.0.17/counter
counter: 4
```
