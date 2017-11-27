#!/bin/bash

echo "===== GETTING WordPress ====="
cd $(dirname $0)
. ./inc.sh
change_dir WordPress

svn_checkout http://svn.automattic.com/wordpress-i18n/sq/tags/4.4.1/ wp-sq
svn_checkout http://svn.automattic.com/wordpress-i18n/fr_FR/tags/3.6/ wp-fr
#svn_checkout http://svn.automattic.com/wordpress-i18n/it_IT/tags/4.9/ wp-it
