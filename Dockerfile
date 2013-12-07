FROM base
MAINTENER Issei Naruta <mimitako@gmail.com>

RUN apt-get update
RUN apt-get -y install wget

RUN mkdir /.src
WORKDIR /.src
RUN wget http://openresty.org/download/ngx_openresty-1.4.3.3.tar.gz
RUN tar xvf ngx_openresty-1.4.3.3.tar.gz

WORKDIR /.src/ngx_openresty-1.4.3.3
RUN apt-get -y install gcc make libpcre3-dev libssl-dev perl5
RUN ./configure --with-luajit && make && make install

WORKDIR /.src
RUN wget --no-check-certificate https://fzrxefe.googlecode.com/files/openresty.init.d.script
RUN mv openresty.init.d.script /etc/init.d/nginx
#RUN chkconfig nginx on

EXPOSE 80
CMD ["/usr/local/openresty/nginx/sbin/nginx"]
