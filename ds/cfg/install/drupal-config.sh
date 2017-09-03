#!/bin/bash -x

source /host/settings.sh

### prevent robots from crawling
cat <<EOF > $DRUPAL_DIR/robots.txt
User-agent: *
Disallow: /
EOF

# protect drupal settings
drupal_settings=$DRUPAL_DIR/sites/default/settings.php
chown root:www-data $drupal_settings
chmod 640 $drupal_settings

# set base_url
cat << EOF >> $drupal_settings
\$base_url = "https://$DOMAIN";

EOF

# disable poor man's cron
cat << EOF >> $drupal_settings
/**
 * Disable Poor Man's Cron:
 *
 * Drupal 7 enables the built-in Poor Man's Cron by default.
 * Poor Man's Cron relies on site activity to trigger Drupal's cron,
 * and is not well suited for low activity websites.
 *
 * We will use the Linux system cron and override Poor Man's Cron
 * by setting the cron_safe_threshold to 0.
 *
 * To re-enable Poor Man's Cron:
 *    Comment out (add a leading hash sign) the line below,
 *    and the system cron in /etc/cron.d/drupal7.
 */
\$conf['cron_safe_threshold'] = 0;

EOF

# setup system cron
cat <<EOF > /etc/cron.d/drupal7
# Use the Linux system cron instead of Drupal's "Poor Man's Cron".
# Note: drush cron should be run as the apache user to prevent file permissions problems

0 * * * *    www-data    [ -x /usr/local/bin/drush ] && /usr/local/bin/drush @btr cron > /dev/null 2>&1
EOF
