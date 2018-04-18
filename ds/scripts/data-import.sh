#!/bin/bash -x

nohup_out=/host/logs/nohup-import.out
rm -f $nohup_out
nohup nice /var/www/data/import/all.sh > $nohup_out &
sleep 1
tail -f $nohup_out
