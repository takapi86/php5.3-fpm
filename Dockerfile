FROM centos:7

RUN yum -y update \
    && yum install -y autoconf \
                   curl-devel \
                   gcc \
                   libcurl \
                   libidn-devel \
                   libmemcached-devel \
                   libxml2 \
                   libxml2-devel \
                   libxslt-devel \
                   make \
                   memcached \
                   mysql-devel \
                   tar \
                   wget \
    && rm -rf /var/cache/yum \
    && yum clean all

RUN cd /usr/local/src \
    && wget "https://www.php.net/distributions/php-5.3.29.tar.gz" \
    && tar zxvf ./php-5.3.29.tar.gz

RUN cd /usr/local/src/php-5.3.29 \
    && ./configure \
      --enable-fpm \
      --enable-soap \
      --with-libmemcached-dir=/usr \
      --with-mysql=mysqlnd \
      --with-mysqli=mysqlnd \
      --enable-mbstring \
      --with-curl \
      --with-openssl \
    && make \
    && make install

RUN pecl install PDO_MYSQL \
                 memcached-2.2.0

RUN cp /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.conf
RUN cp /usr/local/src/php-5.3.29/php.ini-development /usr/local/lib/php.ini
RUN rm -rf /usr/local/src/php-5.3.29 /usr/local/src/php-5.3.29.tar.gz

RUN adduser www-data

WORKDIR /var/www/html

EXPOSE 9000

CMD php-fpm
