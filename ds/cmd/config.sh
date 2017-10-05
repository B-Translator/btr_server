cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    ds inject ssmtp.sh
    ds inject install/drupal-make.sh
    ds inject install/drupal-install.sh
    ds inject install/separate-translation-data.sh
    ds inject install/drupal-config.sh
    ds inject install/drush-config.sh
    ds inject install/apache2.sh
    ds inject install/set-prompt.sh
    ds inject install/misc-config.sh

    ds clone dev
    ds inject dev/config.sh @btr_dev dev

    ds inject set-emailsmtp.sh
    #ds inject set-domain.sh $DOMAIN
    #ds inject set-adminpass.sh "$ADMIN_PASS"

    ds inject set-languages.sh

    # drush may create some files with wrong permissions, fix them
    ds inject fix-file-permissions.sh
}
