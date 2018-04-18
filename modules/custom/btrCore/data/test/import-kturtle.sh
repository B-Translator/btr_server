#!/bin/bash -x

site=${1:-@btr}

### set some variables
origin=test
project=kturtle
path=/var/www/data/test/po_files

### create the project
drush $site btrp-add $origin $project $path/kturtle-fr.po

### import the PO files of each language
for lng in fr sq
do
    drush $site btrp-import $origin $project $lng $path/kturtle-$lng.po
done
