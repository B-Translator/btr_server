#!/bin/bash -x

source /host/settings.sh

### settings for the database and the drupal site
db_name=btr
db_user=btr
db_pass=btr
site_name="B-Translator"
site_mail="$GMAIL_ADDRESS"
account_name=admin
account_pass="$ADMIN_PASS"
account_mail="$GMAIL_ADDRESS"

### create the database and user
mysql='mysql --defaults-file=/etc/mysql/debian.cnf'
$mysql -e "
    DROP DATABASE IF EXISTS $db_name;
    CREATE DATABASE $db_name;
    GRANT ALL ON $db_name.* TO $db_user@localhost IDENTIFIED BY '$db_pass';
"

### start site installation
sed -e '/memory_limit/ c memory_limit = -1' -i /etc/php/7.1/cli/php.ini
cd $DRUPAL_DIR
drush site-install --verbose --yes btr_server \
      --db-url="mysql://$db_user:$db_pass@localhost/$db_name" \
      --site-name="$site_name" --site-mail="$site_mail" \
      --account-name="$account_name" --account-pass="$account_pass" --account-mail="$account_mail"

### set the common options for drush
drush="drush --root=$DRUPAL_DIR --yes"

### set the list of supported languages
sed -i $DRUPAL_DIR/profiles/btr_server/modules/custom/btrCore/data/config.sh \
    -e "/^languages=/c languages=\"$LANGUAGES\""
$drush vset btr_languages "$LANGUAGES"

### add these languages to drupal
drush dl drush_language
for lng in $LANGUAGES; do
    $drush language-add $lng
done

### set the directory for uploads
$drush vset --exact file_private_path '/var/www/uploads/'

### install features
$drush pm-enable btr_btrServices
$drush features-revert btr_btrServices

$drush pm-enable btr_btr
$drush features-revert btr_btr

$drush pm-enable btr_misc
$drush features-revert btr_misc

$drush pm-enable btr_layout
$drush features-revert btr_layout

$drush pm-enable btr_hybridauth
$drush features-revert btr_hybridauth

#$drush pm-enable btr_captcha
#$drush features-revert btr_captcha

$drush pm-enable btr_permissions
$drush features-revert btr_permissions

### fix tha DB schema and install some test data
$DRUPAL_DIR/profiles/btr_server/modules/custom/btrCore/data/install.sh

### import the vocabulary projects
/var/www/data/import/vocabulary.sh --root=$DRUPAL_DIR

### update to the latest version of core and modules
#$drush pm-refresh
#$drush pm-update
