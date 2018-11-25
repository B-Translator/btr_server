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
 
    # twitter config
    if [[ -f trc ]]; then
        cp trc /home/twitter/.trc
        chown twitter: /home/twitter/.trc
    fi
}

restore_custom_scripts() {
    if [[ ! -f /host/backup.sh ]] && [[ -f backup.sh ]]; then
        cp backup.sh /host/
    fi
    if [[ ! -f /host/restore.sh ]] && [[ -f restore.sh ]]; then
        cp restore.sh /host/
    fi
    if [[ ! -d /host/cmd ]] && [[ -d cmd ]]; then
        cp -a cmd /host/
    fi
    if [[ ! -d /host/scripts ]] && [[ -d scripts ]]; then
        cp -a scripts /host/
    fi
}

# go to the backup directory
backup=$1
cd /host/$backup

# restore
restore_vocabularies
restore_data
restore_config

# restore any custom scripts
restore_custom_scripts

# custom restore script
[[ -f /host/restore.sh ]] && source /host/restore.sh
