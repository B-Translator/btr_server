#!/bin/bash -x

source /host/settings.sh
DOMAIN=${DOMAIN:-$IMAGE.example.org}

### create a configuration file
cat <<EOF > /etc/apache2/sites-available/btr.conf
<VirtualHost *:80>
        ServerName $DOMAIN
        RedirectPermanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost _default_:443>
        ServerName $DOMAIN

        DocumentRoot /var/www/btr
        <Directory /var/www/btr/>
            AllowOverride All
            Header set Access-Control-Allow-Origin "*"
        </Directory>

        SSLEngine on
        SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
        SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

        <FilesMatch "\.(cgi|shtml|phtml|php)$">
                        SSLOptions +StdEnvVars
        </FilesMatch>
</VirtualHost>
EOF
### we need to refer to this apache2 config by the name "$DOMAIN.conf" as well
ln /etc/apache2/sites-available/{btr,$DOMAIN}.conf

cat <<EOF > /etc/apache2/conf-available/api-examples-php.conf
Alias /api-examples-php /var/www/api-examples-php
<Directory /var/www/api-examples-php>
    Options Indexes FollowSymLinks
</Directory>
EOF

### link to php api examples and fix the config
ln -s /var/www/btr_dev/profiles/btr_server/modules/custom/btrServices/examples/php /var/www/api-examples-php
sed -i /var/www/api-examples-php/config.php \
    -e "/^\$base_url/ c \$base_url = 'https://dev.$DOMAIN';"

cat <<EOF > /etc/apache2/conf-available/downloads.conf
Alias /downloads /var/www/downloads
<Directory /var/www/downloads>
    Options Indexes FollowSymLinks
</Directory>
EOF

### enable ssl etc.
a2enmod ssl
a2dissite 000-default
a2ensite btr
a2enmod headers rewrite
a2enconf api-examples-php downloads

### create a script to check for apache2, and start it if not running
cat <<'EOF' > /usr/local/sbin/apachemonitor.sh
#!/bin/bash
# restart apache if it is down

if ! /usr/bin/pgrep apache2
then
    date >> /usr/local/apachemonitor.log
    rm /var/run/apache2/apache2.pid
    /etc/init.d/apache2 restart
fi
EOF
chmod +x /usr/local/sbin/apachemonitor.sh

### setup a cron job to monitor apache2
mkdir -p /etc/cron.d/
cat <<'EOF' > /etc/cron.d/apachemonitor
* * * * * root /usr/local/sbin/apachemonitor.sh >/dev/null 2>&1
EOF
chmod +x /etc/cron.d/apachemonitor

### limit the memory size of apache2 when developing
if [[ -n $DEV ]]; then
    sed -i /etc/php/7.1/apache2/php.ini \
        -e '/^\[PHP\]/ a apc.rfc1867 = 1' \
        -e '/^display_errors/ c display_errors = On'

    sed -i /etc/apache2/mods-available/mpm_prefork.conf \
        -e '/^<IfModule/,+5 s/StartServers.*/StartServers 2/' \
        -e '/^<IfModule/,+5 s/MinSpareServers.*/MinSpareServers 2/' \
        -e '/^<IfModule/,+5 s/MaxSpareServers.*/MaxSpareServers 4/' \
        -e '/^<IfModule/,+5 s/MaxRequestWorkers.*/MaxRequestWorkers 50/'
fi

### modify the configuration of php
cat <<EOF > /etc/php/7.1/mods-available/apcu.ini
extension=apcu.so
apcu.mmap_file_mask=/tmp/apcu.XXXXXX
apcu.shm_size=96M
EOF

sed -i /etc/php/7.1/apache2/php.ini \
    -e '/^;\?memory_limit/ c memory_limit = 200M' \
    -e '/^;\?max_execution_time/ c max_execution_time = 90' \
    -e '/^;\?display_errors/ c display_errors = On' \
    -e '/^;\?post_max_size/ c post_max_size = 16M' \
    -e '/^;\?cgi\.fix_pathinfo/ c cgi.fix_pathinfo = 1' \
    -e '/^;\?upload_max_filesize/ c upload_max_filesize = 16M' \
    -e '/^;\?default_socket_timeout/ c default_socket_timeout = 90'

service apache2 restart
