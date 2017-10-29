#!/bin/bash -x

### put the cache on RAM (to improve efficiency)
sed -i /etc/fstab \
    -e '/appended by installation scripts/,$ d'
cat <<EOF >> /etc/fstab
##### appended by installation scripts
tmpfs		/dev/shm	tmpfs	defaults,noexec,nosuid	0	0
# tmpfs		/var/www/btr/cache	tmpfs	defaults,size=5M,mode=0777,noexec,nosuid	0	0
devpts		/dev/pts	devpts	rw,noexec,nosuid,gid=5,mode=620		0	0
# # mount /tmp on RAM for better performance
# tmpfs /tmp              tmpfs  defaults,noatime,mode=1777,nosuid  0 0
# tmpfs /var/log/apache2  tmpfs  defaults,noatime                   0 0
EOF
