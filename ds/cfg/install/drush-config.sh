#!/bin/bash -x

source /host/settings.sh

mkdir -p /etc/drush

cat <<EOF > /etc/drush/local_btr.aliases.drushrc.php
<?php
/*
  For more info see:
    drush help site-alias
    drush topic docs-aliases

  See also:
    drush help rsync
    drush help sql-sync
 */

\$aliases['btr'] = array (
  'root' => '/var/www/btr',
  'uri' => 'http://$DOMAIN',
  'path-aliases' => array (
    '%profile' => 'profiles/btr_server',
    '%data' => '/var/www/data',
    '%po_files' => '/var/www/PO_files',
    '%exports' => '/var/www/exports',
    '%downloads' => '/var/www/downloads',
  ),
);

// \$aliases['btr_dev'] = array (
//   'parent' => '@btr',
//   'root' => '/var/www/btr_dev',
//   'uri' => 'http://dev.$DOMAIN',
// );
EOF

cat <<EOF > /etc/drush/remote.aliases.drushrc.php
<?php

/* uncomment and modify properly

\$aliases['live'] = array (
  'root' => '/var/www/btr',
  'uri' => 'http://$DOMAIN',

  'remote-host' => '$DOMAIN',
  'remote-user' => 'root',
  'ssh-options' => '-p 2201 -i /root/.ssh/id_rsa',

  'path-aliases' => array (
    '%profile' => 'profiles/btr_server',
    '%data' => '/var/www/data',
    '%pofiles' => '/var/www/PO_files',
    '%exports' => '/var/www/exports',
    '%downloads' => '/var/www/downloads',
  ),

  'command-specific' => array (
    'sql-sync' => array (
      'simulate' => '1',
    ),
    'rsync' => array (
      'simulate' => '1',
    ),
  ),
);

\$aliases['test'] = array (
  'parent' => '@live',
  'root' => '/var/www/btr_test',
  'uri' => 'http://test.$DOMAIN',

  'command-specific' => array (
    'sql-sync' => array (
      'simulate' => '0',
    ),
    'rsync' => array (
      'simulate' => '0',
    ),
  ),
);

*/
EOF
