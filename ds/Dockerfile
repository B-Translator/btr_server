FROM ubuntu:18.04

### install systemd
RUN apt update && \
    apt -y upgrade && \
    apt -y install systemd && \
    systemctl set-default multi-user.target

CMD ["/sbin/init"]
WORKDIR /host

### install some other packages
RUN apt -y install rsyslog logrotate ssmtp logwatch cron
RUN apt -y install vim git wget curl unzip gawk make diffutils

### add apt repository ppa:ondrej/php
RUN apt install -y software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt update && apt -y upgrade

### install lamp
RUN DEBIAN_FRONTEND=noninteractive \
    apt -y install apache2 mysql-client php7.1 php7.1-mysql \
        php7.1-gd php7.1-db php7.1-dev php-pear php7.1-curl \
        php7.1-apcu php7.1-xml php7.1-mbstring php7.1-uploadprogress
RUN update-alternatives --set php /usr/bin/php7.1 && \
    a2dismod php7.2 && a2enmod php7.1

### install drush
RUN wget https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    drush --yes init

### install nodejs and less
RUN apt -y install npm && \
    npm install -g less

### install hub: http://hub.github.com/
RUN curl http://hub.github.com/standalone -sLo /bin/hub && \
    chmod +x /bin/hub

### install twitter cli client
### see: http://xmodulo.com/2013/12/access-twitter-command-line-linux.html
RUN apt -y install ruby ruby-dev && \
    gem install t && \
    useradd --system --create-home twitter

### install other needed tools
RUN apt-get -y install \
        zip mercurial subversion translate-toolkit dtrx rsstail

### get pology (used for making embedded diffs)
RUN rm -rf /usr/local/lib/pology && \
    svn checkout -r 1387659 \
        svn://anonsvn.kde.org/home/kde/trunk/l10n-support/pology \
        /usr/local/lib/pology
