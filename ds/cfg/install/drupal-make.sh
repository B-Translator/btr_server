#!/bin/bash -x

source /host/settings.sh

### make sure that we have the right git branch on the make file
makefile="$CODE_DIR/build-btr_server.make"
git_branch=$(git -C $CODE_DIR branch | cut -d' ' -f2)
sed -i $makefile \
    -e "/btr_server..download..branch/ c projects[btr_server][download][branch] = $git_branch"

### retrieve all the projects/modules and build the application directory
rm -rf $DRUPAL_DIR
drush make --prepare-install --force-complete \
           --contrib-destination=profiles/btr_server \
           $makefile $DRUPAL_DIR

### Replace the profile btr_server with a version
### that is a git clone, so that any updates
### can be retrieved easily (without having to
### reinstall the whole application).
cd $DRUPAL_DIR/profiles/
mv btr_server btr_server-bak
cp -a $CODE_DIR .
### copy contrib libraries and modules
cp -a btr_server-bak/libraries/ btr_server/
cp -a btr_server-bak/modules/contrib/ btr_server/modules/
cp -a btr_server-bak/themes/contrib/ btr_server/themes/
### cleanup
rm -rf btr_server-bak/

### copy the bootstrap library to the custom theme, etc.
cd $DRUPAL_DIR/profiles/btr_server/
cp -a libraries/bootstrap themes/contrib/bootstrap/
cp -a libraries/bootstrap themes/btr_server/
cp libraries/bootstrap/less/variables.less themes/btr_server/less/

### copy hybridauth provider GitHub.php to the right place
cd $DRUPAL_DIR/profiles/btr_server/libraries/hybridauth/
cp additional-providers/hybridauth-github/Providers/GitHub.php \
   hybridauth/Hybrid/Providers/

### set propper directory permissions
mkdir -p $DRUPAL_DIR/sites/all/translations
chown -R www-data: $DRUPAL_DIR/sites/all/translations
mkdir -p sites/default/files/
chown -R www-data: sites/default/files/
mkdir -p cache/
chown -R www-data: cache/

### create the directory of PO files
mkdir -p /var/www/PO_files
chown www-data: /var/www/PO_files

### put a link to the data directory on /var/www/data
rm -f /var/www/data
ln -s $DRUPAL_DIR/profiles/btr_server/modules/custom/btrCore/data /var/www/data

### create the downloads and exports dirs
mkdir -p /var/www/downloads/
chown www-data: /var/www/downloads/
mkdir -p /var/www/exports/
chown www-data: /var/www/exports/
mkdir -p /var/www/uploads/
chown www-data: /var/www/uploads/
