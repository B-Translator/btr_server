#!/bin/bash -x
### Fix the databases.

### Fix the schema for the btr tables.
drush @btr sql-query \
      --database=default \
      --file=/var/www/data/db/btr_schema.sql

drush @btr sql-query \
      --database=btr_data \
      --file=/var/www/data/db/btr_schema.sql
