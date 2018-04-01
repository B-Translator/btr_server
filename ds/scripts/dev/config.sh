#!/bin/bash -x

alias=${1:-@local_btr}
tag=$2

if [[ $alias == '@btr_dev' ]]; then
    ### comment out the configuration of the database 'btr_data' so that
    ### the internal test database can be used instead for translations
    sed -i /var/www/btr_dev/sites/default/settings.php \
        -e '/$databases..btr_data/,+8 s#^/*#//#'

    ### register a test oauth2 client on btr_server
    drush @btr_dev oauth2-client-add test1 12345 \
        'https://btranslator.net/oauth2-client-php/authorized.php'
fi

drush --yes $alias php-script $CODE_DIR/ds/scripts/dev/config.php $tag
