cmd_restore_help() {
    cat <<_EOF
    restore <backup-file.tgz> [<app>]
        Restore application from the given backup file.
        <app> can be 'btr', 'btr_dev', etc.

_EOF
}

cmd_restore() {
    set -x
    # get the backup file
    local file=$1
    test -f "$file" || fail "Usage: $COMMAND <backup-file.tgz>"
    local dir=${file%%.tgz}
    [[ $file != $dir ]] || fail "Usage: $COMMAND <backup-file.tgz>"

    # extract the backup archive
    tar --extract --gunzip --preserve-permissions --file=$file
    dir=$(basename $dir)

    # restore the database
    local app=${2:-btr}
    ds exec drush @$app sql-drop --yes
    ds exec drush @$app sql-query --file=/host/$dir/database.sql

    # restore application files
    ds stop
    rm -rf var-www/$app
    cp -a $dir/$app var-www/
    ds start

    # clean up
    rm -rf $dir
}
