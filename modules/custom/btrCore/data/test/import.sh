#!/bin/bash

### go to the script directory
cd $(dirname $0)

site=${1:-@btr}

### import test PO files
./import-pingus.sh $site
./import-kturtle.sh $site
#./import-kdeadmin.sh $site
#./import-office-desktop.sh $site
