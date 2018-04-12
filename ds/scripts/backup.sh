#!/bin/bash -x

#source /host/settings.sh

backup_vocabularies() {
    mkdir -p vocabularies
    local line lng name file
    drush @btr btr-vocabulary-list | \
        while read line; do
            line=$(echo $line | tr -d '\r\n')
            lng=$(echo $line | cut -d' ' -f1)
            name=$(echo $line | cut -d' ' -f2)
            drush @btr btr-vocabulary-get $name $lng --format=txt1 \
                  > $(pwd)/vocabularies/$name-$lng.txt
        done
}

backup_data() {
    ### set mysqldump options
    sql_connect=$(drush @btr sql-connect --database=btr_data | sed -e 's/^mysql //' -e 's/--database=/--databases /')
    mysqldump="mysqldump $sql_connect --skip-add-drop-table --replace"

    ### backup translations
    $mysqldump --tables btr_translations --where="umail != ''" \
        > $(pwd)/btr_data.sql

    ### backup other tables of btr_data
    table_list="
        btr_votes
        btr_translations_trash
        btr_votes_trash
        btr_users
        btr_user_project_roles
        btr_languages
    "
    $mysqldump --tables $table_list \
               >> $(pwd)/btr_data.sql

    ### fix 'CREATE TABLE' on the sql file
    sed -i btr_data.sql \
        -e 's/CREATE TABLE/CREATE TABLE IF NOT EXISTS/g'

    ### backup btr tables
    mysqldump=$(drush @btr sql-connect | sed -e 's/^mysql/mysqldump/' -e 's/--database=/--databases /')
    table_list="
        translation_projects
        btr_languages
        users
        users_roles
        field_data_field_auxiliary_languages
        field_data_field_projects
        field_data_field_translation_lng
        field_revision_field_auxiliary_languages
        field_revision_field_projects
        field_revision_field_translation_lng
        hybridauth_identity
        hybridauth_session
    "
    $mysqldump --tables $table_list > $(pwd)/btr.sql
}

backup_config() {
    # enabled features
    drush @btr features-list --pipe --status=enabled \
          > $(pwd)/btr_features.txt
    drush @btr_dev features-list --pipe --status=enabled \
          > $(pwd)/btr_dev_features.txt

    # drupal variables
    local dir
    dir=/var/www/btr/profiles/btr_server/modules/features
    $dir/save-private-vars.sh @btr
    mv restore-private-vars.php restore-private-vars-btr.php

    dir=/var/www/btr_dev/profiles/btr_server/modules/features
    $dir/save-private-vars.sh @btr_dev
    mv restore-private-vars.php restore-private-vars-btr-dev.php
}


# go to the backup dir
backup=$1
cd /host/$backup

# make the backup
backup_vocabularies
backup_data
backup_config
