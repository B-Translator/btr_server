#!/bin/bash -x
### Create a local clone of the main drupal
### application (/var/www/btr).

if [ $# -ne 2 ]
then
    echo " * Usage: $0 src dst

      Makes a clone from /var/www/<src> to /var/www/<dst>
      The database <src> will also be cloned to <dst>.
      <dst> can be something like 'btr_dev', 'btr_test', 'btr_01', etc.

      Note: Using something like 'btr-dev' is not suitable
      for the name of the database.

      Caution: The root directory and the DB of the destination
      will be erased, if they exist.
"
    exit 1
fi
src=$1
dst=$2
src_dir=/var/www/$src
dst_dir=/var/www/$dst

### copy the root directory
rm -rf $dst_dir
cp -a $src_dir $dst_dir

### modify settings.php
domain=$(cat /etc/hostname)
sub=${dst#*_}
hostname=$sub.$domain
sed -i $dst_dir/sites/default/settings.php \
    -e "/^\\\$databases = array/,+10  s/'database' => .*/'database' => '$dst',/" \
    -e "/^\\\$base_url/c \$base_url = \"https://$hostname\";"

### create a drush alias
sed -i /etc/drush/local_btr.aliases.drushrc.php \
    -e "/^\\\$aliases\['$dst'\] = /,+5 d"
cat <<EOF >> /etc/drush/local_btr.aliases.drushrc.php
\$aliases['$dst'] = array (
  'parent' => '@btr',
  'root' => '$dst_dir',
  'uri' => 'http://$hostname',
);

EOF

### create a new database
mysql --defaults-file=/etc/mysql/debian.cnf -e "
    DROP DATABASE IF EXISTS $dst;
    CREATE DATABASE $dst;
    GRANT ALL ON $dst.* TO btr@localhost;
"

### copy the database
drush --yes sql-sync @$src @$dst

### clear the cache
drush @$dst cc all

### copy and modify the configuration of apache2
rm -f /etc/apache2/sites-{available,enabled}/$dst.conf
cp /etc/apache2/sites-available/{$src,$dst}.conf
sed -i /etc/apache2/sites-available/$dst.conf \
    -e "s#ServerName .*#ServerName $hostname#" \
    -e "s#RedirectPermanent .*#RedirectPermanent / https://$hostname/#" \
    -e "s#$src_dir#$dst_dir#g"
a2ensite $dst

### fix permissions
chown www-data: -R $dst_dir/sites/default/files/*
chown root: $dst_dir/sites/default/files/.htaccess

### restart services
service mysql restart
service apache2 restart
