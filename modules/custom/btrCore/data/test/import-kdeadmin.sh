#!/bin/bash

site=${1:-@btr}

### set some variables
origin=test
project=kdeadmin
path=/var/www/data/test/po_files

### create the project
drush $site btrp-add $origin $project $path/kdeadmin-fr/

### import the PO files of each language
for lng in fr sq
do
    drush $site btrp-import $origin $project $lng $path/kdeadmin-$lng/
done
