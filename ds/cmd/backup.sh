cmd_backup_help() {
    cat <<_EOF
    backup [<app>]
        Make a backup of files, database, etc.
        <app> can be 'btr', 'btr_dev', etc.

_EOF
}

cmd_backup() {
    set -x
    local app=${1:-btr}

    # create the backup dir
    backup="backup-$app-$(date +%Y%m%d)"
    rm -rf $backup
    rm -f $backup.tgz
    mkdir $backup

    # copy to the backup dir the database dump
    ds exec drush @$app cache-clear all
    ds exec drush @$app sql-dump --ordered-dump \
           --result-file=/host/$backup/database.sql

    # copy app files to the backup dir
    cp -a var-www/$app $backup

    # make the backup archive
    tar --create --gzip --preserve-permissions --file=$backup.tgz $backup/
    rm -rf $backup/
}
