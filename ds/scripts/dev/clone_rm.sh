#!/bin/bash -x
### Erase a local clone created by clone.sh

if [ $# -ne 1 ]
then
    echo " * Usage: $0 target

   Deletes the application with root /var/www/<target>
   and with DB named <target>.
"
    exit 1
fi
target=$1

### remove the root directory
rm -rf /var/www/$target

### delete the drush alias
sed -i /etc/drush/local_btr.aliases.drushrc.php \
    -e "/^\\\$aliases\['$target'\] = /,+5 d"

### drop the database
mysql --defaults-file=/etc/mysql/debian.cnf \
      -e "DROP DATABASE IF EXISTS $target;"

### remove the configuration of apache2
cd /etc/apache2/
find -L -samefile sites-available/$target.conf | xargs rm -f

### restart services
/etc/init.d/mysql restart
/etc/init.d/apache2 restart
