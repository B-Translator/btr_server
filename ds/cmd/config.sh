cmd_config_help() {
    cat <<_EOF
    config
        Run configuration scripts inside the container.

_EOF
}

cmd_config() {
    ds runcfg ssmtp
    ds runcfg mysql
    ds runcfg install/drupal-make
    ds runcfg install/drupal-install
    ds runcfg install/separate-translation-data
    ds runcfg install/drupal-config
    ds runcfg install/drush-config
    ds runcfg install/apache2
    ds runcfg install/set-prompt
    ds runcfg install/misc-config

    ds runcfg dev/make-dev-clone
    ds runcfg dev/config @btr_dev

    if [[ -n $DEV ]]; then
        ds runcfg phpmyadmin
    fi

    ds runcfg set-emailsmtp
    #ds runcfg set-domain $DOMAIN
    #ds runcfg set-adminpass "$ADMIN_PASS"

    ds runcfg set-languages

    # drush may create some files with wrong permissions, fix them
    ds runcfg fix-file-permissions
}
