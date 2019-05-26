#!/usr/bin/env bash
set -euo pipefail

DOCKER_COMPOSE_VER=1.23.1
PHP_VER=7.2

setup_docker() {
    echo 'Installing Docker...'
    apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    apt update
    apt install -y docker-ce
    
    echo 'Installing Docker Compose...'
    curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    docker -v
    docker-compose -v
    echo 'Done successfully!'
}

setup_php() {
    echo 'Setting up PHP...'
    echo 'Installing PHP...'
    apt install -y \
        php$PHP_VER \
        php$PHP_VER-common \
        php$PHP_VER-cli \
        php$PHP_VER-fpm \
        php$PHP_VER-mysql \
        php$PHP_VER-dev \
        php$PHP_VER-mbstring \
        php$PHP_VER-zip

    echo 'Installing Xdebug...'
    apt install -y php-xdebug
    sed -i -e 's/zend_extension=xdebug.so/; zend_extension=xdebug.so/' /etc/php/7.2/mods-available/xdebug.ini
    echo '@zend_extension = "/usr/lib/php/20170718/xdebug.so"@xdebug.remote_enable=on@xdebug.remote_autostart=on' |
        tr '@' '\n' >> /etc/php/$PHP_VER/cli/php.ini

    echo 'Installing Composer...'
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
    php -v
    composer -v
    echo 'Done successfully!'
}

all() {
    apt update
    apt upgrade -y

    setup_docker

    setup_php
}

eval "$1"
