FROM ubuntu:12.04
MAINTAINER Issei Naruta <mimitako@gmail.com>

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y install gcc make libpcre3-dev libssl-dev perl5 wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y mysql-server libmysqlclient-dev

RUN mkdir /.src
WORKDIR /.src
RUN wget http://openresty.org/download/ngx_openresty-1.4.3.3.tar.gz
RUN tar xvf ngx_openresty-1.4.3.3.tar.gz

WORKDIR /.src/ngx_openresty-1.4.3.3
RUN ./configure --with-luajit && make && make install

#WORKDIR /usr/local/openresty/nginx/conf
#RUN wget --no-check-certificate https://raw.github.com/agentzh/lua-resty-mysql/v0.13/lib/resty/mysql.lua
ADD nginx/nginx.conf /usr/local/openresty/nginx/conf/
ADD nginx/counter.lua /usr/local/openresty/nginx/conf/

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD init.sql /tmp/
RUN (/usr/bin/mysqld_safe &); sleep 3; mysql -u root < /tmp/init.sql

EXPOSE 80
EXPOSE 3306
CMD /usr/local/openresty/nginx/sbin/nginx & /usr/bin/mysqld_safe
#CMD ["/usr/bin/mysqld_safe"]
