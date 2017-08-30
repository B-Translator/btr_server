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

### install lamp
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install apache2 mysql-client mysql-server \
        php-mysql php-gd php-db php-dev php-pear php-curl php-apcu

### install other tools
RUN apt-get -y install vim git wget curl unzip make gawk diffutils ruby

### install nodejs and less
RUN apt-get -y install npm && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    npm install -g less

### install hub: http://hub.github.com/
RUN curl http://hub.github.com/standalone -sLo /bin/hub && \
    chmod +x /bin/hub

### install twitter cli client
### see: http://xmodulo.com/2013/12/access-twitter-command-line-linux.html
RUN apt-get -y install ruby-dev && \
    gem install t && \
    useradd --system --create-home twitter

### install uploadprogress bar (requested by Drupal 7)
#RUN pecl install uploadprogress
RUN git clone https://git.php.net/repository/pecl/php/uploadprogress && \
    cd uploadprogress/ && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    echo "extension = uploadprogress.so" > /etc/php/7.0/mods-available/uploadprogress.ini && \
    ln -s /etc/php/7.0/mods-available/uploadprogress.ini /etc/php/7.0/apache2/conf.d/ && \
    rm -rf uploadprogress/

### install drush
RUN wget http://files.drush.org/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    drush --yes init

### install other needed tools
RUN apt-get -y install \
        zip mercurial subversion translate-toolkit dtrx rsstail

### get pology (used for making embedded diffs)
RUN rm -rf /usr/local/lib/pology && \
    svn checkout -r 1387659 \
        svn://anonsvn.kde.org/home/kde/trunk/l10n-support/pology \
        /usr/local/lib/pology
