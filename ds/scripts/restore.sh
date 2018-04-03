#!/bin/bash -x

#source /host/settings.sh

restore_vocabularies() {
    local file name lng
    for file in $(ls vocabularies/); do
        name=$(echo ${file%%.txt} | cut -d- -f1)
        lng=$(echo ${file%%.txt} | cut -d- -f2)
        drush @btr btr-vocabulary-add $name $lng
        drush @btr btr-vocabulary-import $name $lng \
              $(pwd)/vocabularies/$name-$lng.txt
    done
}

restore_data() {
    drush @btr sql-query --file=$(pwd)/btr.sql
    $(drush @btr sql-connect --database=btr_data) < $(pwd)/btr_data.sql
}

restore_config() {
    # enable features
    while read feature; do
        drush --yes @btr pm-enable $feature
        drush --yes @btr features-revert $feature
    done < btr_features.txt

    while read feature; do
        drush --yes @btr_dev pm-enable $feature
        drush --yes @btr_dev features-revert $feature
    done < btr_dev_features.txt

    # restore private variables
    drush @btr php-script $(pwd)/restore-private-vars-btr.php
    drush @btr_dev php-script $(pwd)/restore-private-vars-btr-dev.php
}


# disable the site for maintenance
drush --yes @local_btr vset maintenance_mode 1
drush --yes @local_btr cache-clear all

# extract the backup archive
file=$1
cd /host/
tar --extract --gunzip --preserve-permissions --file=$file
backup=${file%%.tgz}
backup=$(basename $backup)
cd $backup/

# restore
restore_vocabularies
restore_data
restore_config

# clean up
cd /host/
rm -rf $backup

# enable the site
drush --yes @local_btr cache-clear all
drush --yes @local_btr vset maintenance_mode 0