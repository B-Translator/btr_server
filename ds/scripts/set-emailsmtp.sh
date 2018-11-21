#!/bin/bash -x
### modify drupal variables that are used for sending email

source /host/settings.sh

alias=${1:-@local_btr}
if [[ -n $SMTP_SERVER ]]; then
    drush --yes $alias \
          php-script $CODE_DIR/ds/scripts/set-emailsmtp.php  \
          'smtp_server' "$SMTP_SERVER" "$SMTP_DOMAIN"
elif [[ -n $GMAIL_ADDRESS ]]; then
    drush --yes $alias \
          php-script $CODE_DIR/ds/scripts/set-emailsmtp.php  \
          'gmail_account' "$GMAIL_ADDRESS" "$GMAIL_PASSWD"
fi
