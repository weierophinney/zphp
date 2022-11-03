# Build Swoole
FROM cr.zend.com/zendphp/7.3:ubuntu-20.04-cli as swoole

## Prepare image
ARG ZENDPHP_REPO_USERNAME
ARG ZENDPHP_REPO_PASSWORD
ARG SWOOLE_VERSION=4.11.1
ARG TIMEZONE=UTC
ENV TZ=$TIMEZONE
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -e; \
    zendphpctl repo-credentials --account "${ZENDPHP_REPO_USERNAME}" --password "${ZENDPHP_REPO_PASSWORD}"; \
    apt-get update; \
    apt-get install -y php7.3-zend-dev libcurl4-openssl-dev; \
    mkdir /workdir; \
    cd /workdir; \
    curl -L -o openswoole-${SWOOLE_VERSION}.tgz https://pecl.php.net/get/openswoole-${SWOOLE_VERSION}.tgz; \
    tar xzf openswoole-${SWOOLE_VERSION}.tgz; \
    cd openswoole-${SWOOLE_VERSION}; \
    phpize7.3-zend; \
    ./configure \
        --with-php-config=/usr/bin/php-config7.3-zend \
        --enable-http2 \
        --enable-openssl \
        --enable-sockets \
        --enable-openswoole \
        --enable-swoole-curl \
        --enable-swoole-json; \
    make; \
    make install

# OS=one of ubuntu, centos, or debian
ARG OS=ubuntu

# OS_VERSION=OS version to use; e.g., 20.04, 8, and 10
ARG OS_VERSION=20.04

# PHP version to use; can be 5.6, 7.1, 7.2, 7.3, 7.4, or 8.0.
# Ability to build a version is dependent on having ZendPHP credentials that
# authorize use of that version.
ARG ZENDPHP_VERSION=7.3

# BASE_IMAGE=cli or fpm
ARG BASE_IMAGE=cli

FROM cr.zend.com/zendphp/7.3:ubuntu-20.04-cli

# Github user and token, to allow bypassing API limits
ARG GITHUB_USERNAME
ARG GITHUB_TOKEN

# CUSTOMIZATIONS
#
# TIMEZONE=timezone the OS should use; UTC by default
ARG TIMEZONE=UTC

# Credentials.
# These are REQUIRED when using LTS builds, and SHOULD be used if you have
# purchased licenses from Zend.
#
# The first is the username/Account ID/Order ID you were provided on purchase of ZendPHP
ARG ZENDPHP_REPO_USERNAME
ARG ZENDPHP_REPO_PASSWORD

# INSTALL_COMPOSER=true or false/empty (whether or not Composer will be installed in
# the image)
ARG INSTALL_COMPOSER=true

# SYSTEM_PACKAGES=space- or comma-separated list of additional OS-specific
# packages to install (e.g., cron, dev libraries for building extensions, etc.)
ARG SYSTEM_PACKAGES="curl sed git"

# ZEND_EXTENSIONS_LIST=space- or comma-separated list of packaged ZendPHP
# extensions to install and enable. These should omit the prefix
# php{VERSION}-zend (DEB) or php{VERSION}zend (RPM); e.g., mysqli, pdo-pgsql, etc.
ARG ZEND_EXTENSIONS_LIST="bcmath bz2 ctype curl dom ffi fileinfo gd iconv igbinary imagick intl json mbstring opcache phar readline shmop simplexml soap sockets sqlite3 tidy xdebug xml xmlreader xmlwriter xsl zip"

# PECL_EXTENSIONS_LIST=space- or comma-separated list of PECL extensions to
# compile, install, and enable. You will need to install the dev/devel package
# for the ZendPHP version you are using, and any additional devel libraries
# that may be required.
ARG PECL_EXTENSIONS_LIST

# POST_BUILD_BASH=full path to a bash script or name of a bash script under
# /usr/local/sbin to execute following build tasks. You will need to ADD or COPY
# these to the image before calling ZendPHPCustomizeWithBuildArgs.sh, and ensure
# they are executable. Such scripts can be used to further customize your image.
ARG POST_BUILD_BASH

# Prepare tzdata
ENV TZ=$TIMEZONE \
    YUM_y='-y'
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ADD or COPY any files or directories needed in your image here.
COPY docker/scripts/inject_github_token.sh /usr/local/bin/inject_github_token.sh

# Customize PHP runtime according to the given building arguments.
# Generally, this should be the last statement of your custom image.
RUN set -e; \
    ZendPHPCustomizeWithBuildArgs.sh; \
    inject_github_token.sh "${GITHUB_USERNAME}" "${GITHUB_TOKEN}"; \
    rm /usr/local/bin/inject_github_token.sh

## Install Swoole
COPY --from=swoole /usr/lib/php/7.3-zend/openswoole.so /usr/lib/php/7.3-zend/openswoole.so
COPY --from=swoole /usr/include/php/7.3-zend/ext/openswoole /usr/include/php/7.3-zend/ext/openswoole
RUN set -e; \
    echo "extension=openswoole.so" > /etc/zendphp/cli/conf.d/60-swoole.ini
