#!/bin/bash -x

source /host/settings.sh
new_domain=${1:-$DOMAIN}

### get the current domain
domain=$(cat /etc/hostname)
domain=${domain:-example.org}

### update /etc/hostname
echo $new_domain > /etc/hostname

### update apache2 config files
for file in $(ls /etc/apache2/sites-available/btr*); do
    sed -i $file \
        -e "/ServerName/ s/$domain/$new_domain/" \
        -e "/RedirectPermanent/ s/$domain/$new_domain/"
done

### update drupal  settings
for file in $(ls /var/www/btr*/sites/default/settings.php); do
    sed -i $file -e "/^\\\$base_url/ s/$domain/$new_domain/"
done

### update uri on drush aliases
sed -i /etc/drush/local_btr.aliases.drushrc.php \
    -e "/'uri'/ s/$domain/$new_domain/"
