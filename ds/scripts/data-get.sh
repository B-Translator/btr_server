#!/bin/bash -x

nohup_out=/host/logs/nohup-get.out
rm -f $nohup_out
nohup nice /var/www/data/get/all.sh > $nohup_out &
sleep 1
tail -f $nohup_out
