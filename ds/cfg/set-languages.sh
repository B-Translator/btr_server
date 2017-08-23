#!/bin/bash -x

source /host/settings.sh
languages=${1:-$LANGUAGES}

### set the list of languages for import
sed -i /var/www/data/config.sh \
    -e "/^languages=/c languages=\"$languages\""

### update drupal configuration
drush @local_btr --yes vset btr_languages "$languages"
drush @local_btr --yes php-eval "module_load_include('inc', 'btrCore', 'admin/core'); btrCore_config_set_languages();"

### add these languages to drupal and import their translations
for lng in $languages; do
    drush @local_btr --yes language-add $lng
    drush @local_bcl --yes language-add $lng
done
if [[ -n $DEV ]]; then
    drush @local_btr --yes l10n-update-refresh
    drush @local_btr --yes l10n-update
    drush @local_bcl --yes l10n-update-refresh
    drush @local_bcl --yes l10n-update
fi
