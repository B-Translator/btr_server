#!/bin/bash -x

source /host/settings.sh
new_domain=${1:-$DOMAIN}

### get the current domain
domain=$(cat /etc/hostname)
domain=${domain:-example.org}

### update /etc/hostname
echo $new_domain > /etc/hostname

### update apache2 config files
cd /etc/apache2/sites-available/
for file in $(ls btr*.conf); do
    sed -i $file \
        -e "/ServerName/ s/$domain/$new_domain/" \
        -e "/RedirectPermanent/ s/$domain/$new_domain/"
done
for file in $(ls *$domain.conf); do
    file1=${file//$domain/$new_domain}
    mv $file $file1
done
cd -

### update drupal  settings
for file in $(ls /var/www/btr*/sites/default/settings.php); do
    sed -i $file -e "/^\\\$base_url/ s/$domain/$new_domain/"
done

### update uri on drush aliases
sed -i /etc/drush/local_btr.aliases.drushrc.php \
    -e "/'uri'/ s/$domain/$new_domain/"
