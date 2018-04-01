#!/bin/bash -x
### Create another database for the translation data
### and copy to it the relevant tables (of module btrCore).

source /host/settings.sh

### database and user settings
dbdata=${DBNAME}_data

### create the database and user
mysql="mysql -B --host=$DBHOST --port=$DBPORT --user=$DBUSER --password=$DBPASS"

### copy the data tables to the new database
tables=$($mysql -D $DBNAME -e "SHOW TABLES" | grep '^btr_' )
for table in $tables; do
    echo "Copy: $table"
    $mysql -e "
        DROP TABLE IF EXISTS $dbdata.$table;
        CREATE TABLE $dbdata.$table LIKE $DBNAME.$table;
        INSERT INTO $dbdata.$table SELECT * FROM $DBNAME.$table;
    "
done

### modify Drupal settings
drupal_settings=$DRUPAL_DIR/sites/default/settings.php
sed -e '/===== APPENDED BY INSTALLATION SCRIPTS =====/,$ d' -i $drupal_settings
cat << EOF >> $drupal_settings
//===== APPENDED BY INSTALLATION SCRIPTS =====

/**
 * Use a separate database for the translation data.
 * This provides more flexibility. For example the
 * drupal site and the translation data can be backuped
 * and restored separately. Or a test drupal site
 * (testing new drupal features) can connect to the
 * same translation database.
 */
\$databases['btr_data']['default'] = array (
    'database' => '$dbdata',
    'username' => '$DBUSER',
    'password' => '$DBPASS',
    'host' => '$DBHOST',
    'port' => '$DBPORT',
    'driver' => 'mysql',
    'prefix' => '',
);

EOF
