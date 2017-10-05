#!/bin/bash -x

source /host/settings.sh

[[ -z $GMAIL_ADDRESS ]] && exit 0

### modify ssmtp config files
cat <<-_EOF > /etc/ssmtp/ssmtp.conf
root=$GMAIL_ADDRESS
mailhub=smtp.gmail.com:587
AuthUser=$GMAIL_ADDRESS
AuthPass=$GMAIL_PASSWD
UseTLS=YES
UseSTARTTLS=YES
rewriteDomain=gmail.com
hostname=localhost
FromLineOverride=YES
_EOF

cat <<-_EOF > /etc/ssmtp/revaliases
root:$GMAIL_ADDRESS:smtp.gmail.com:587
admin:$GMAIL_ADDRESS:smtp.gmail.com:587
_EOF

### modify drupal variables that are used for sending email
alias=${1:-@local_btr}
drush --yes $alias php-script $CODE_DIR/ds/scripts/set-emailsmtp.php  \
    "$GMAIL_ADDRESS" "$GMAIL_PASSWD"
