cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    ds inject ubuntu-fixes.sh
    ds inject ssmtp.sh

    ds inject install/drupal-make.sh
    ds inject install/drupal-install.sh
    ds inject install/drupal-config.sh
    ds inject install/drush-config.sh
    ds inject install/fix-db-schema.sh
    ds inject install/apache2.sh
    ds inject install/set-prompt.sh
    ds inject install/cache-on-ram.sh
    ds inject install/misc-config.sh

    # import some test data
    [[ "$DEV" == 'true' ]] && ds exec /var/www/data/test/import.sh @btr

    # make a clone: btr_dev
    ds clone dev
    ds inject dev/config.sh @btr_dev dev
    ds exec /var/www/data/test/import.sh @btr_dev

    ds inject set-emailsmtp.sh
    #ds inject set-domain.sh $DOMAIN
    #ds inject set-adminpass.sh "$ADMIN_PASS"

    ds inject set-languages.sh

    # drush may create some files with wrong permissions, fix them
    ds inject fix-file-permissions.sh

    # import the translation data
    echo "
In order to import or update the translation data:

    ds inject data-get.sh

    ds inject data-import.sh

Downloading and importing all the projects can take
a lot of time (many hours, maybe days).

"

}
