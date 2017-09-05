FROM ubuntu:16.04
ENV container docker
# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target
CMD ["/sbin/init"]

### update and upgrade and install some other packages
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install cron rsyslog logrotate ssmtp logwatch

### add apt repository ppa:ondrej/php
RUN apt-get install -y software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update && apt-get -y upgrade

### install other tools
RUN apt-get -y install vim git wget curl unzip gawk make diffutils

### install lamp
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install apache2 mysql-client mysql-server php-mysql \
        php-gd php-db php-dev php-pear php-curl php-apcu php-xml \
        php-mbstring php-uploadprogress

### install drush
RUN wget http://files.drush.org/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    drush --yes init

### install nodejs and less
RUN apt-get -y install npm && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install -g less

### install hub: http://hub.github.com/
RUN curl http://hub.github.com/standalone -sLo /bin/hub && \
    chmod +x /bin/hub

### install twitter cli client
### see: http://xmodulo.com/2013/12/access-twitter-command-line-linux.html
RUN apt-get -y install ruby ruby-dev && \
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

