#!/bin/bash

site=${1:-@btr}

### set some variables
origin=test
project=LibO-desktop
path=/var/www/data/test/po_files

### create the project
drush $site btrp-add $origin $project $path/LibO-desktop-fr/

### import the PO files of each language
for lng in fr sq
do
    drush $site btrp-import $origin $project $lng $path/LibO-desktop-$lng/
done
