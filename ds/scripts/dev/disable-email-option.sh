#!/bin/bash -x
alias=${1:-@local_btr}
drush --yes $alias php-script $CODE_DIR/ds/scripts/dev/disable-email-option.php $tag
