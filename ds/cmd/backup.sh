cmd_backup_help() {
    cat <<_EOF
    backup [full | data | <app>]
        'full' make a full backup of everything
        'data' make a backup of the important data only
        <app> can be 'btr', 'btr_dev', etc.

_EOF
}

cmd_backup() {
    set -x
    local arg=${1:-full}
    case $arg in
        full)
            _make_full_backup
            ;;
        data)
            _make_data_backup
            ;;
        *)
            _make_app_backup $arg
            ;;
    esac
}

_make_app_backup() {
    local app=${1:-btr}

    # create the backup dir
    local backup="backup-$app-$(date +%Y%m%d)"
    rm -rf $backup
    rm -f $backup.tgz
    mkdir $backup

    # disable the site for maintenance
    ds exec drush @$app vset maintenance_mode 1

    # clear the cache
    ds exec drush @$app cache-clear all

    # dump the content of the databases
    ds exec drush @$app sql-dump \
           --result-file=/host/$backup/$app.sql

    # copy app files to the backup dir
    cp -a var-www/$app $backup

    # make the backup archive
    tar --create --gzip --preserve-permissions --file=$backup.tgz $backup/
    rm -rf $backup/

    # enable the site
    ds exec drush @$app vset maintenance_mode 0
}

_make_full_backup() {
    # create the backup dir
    local backup="backup-full-$(date +%Y%m%d)"
    rm -rf $backup
    rm -f $backup.tgz
    mkdir $backup

    # disable the site for maintenance
    ds exec drush --yes @local_btr vset maintenance_mode 1

    # clear the cache
    ds exec drush --yes @local_btr cache-clear all

    # make a full backup of the databases
    ds mariadb backup $backup/btr-databases.tgz btr btr_dev btr_data

    # copy app files to the backup dir
    cp -a var-www/{btr,btr_dev,downloads} $backup/

    # make the backup archive
    tar --create --gzip --preserve-permissions --file=$backup.tgz $backup/
    rm -rf $backup/

    # enable the site
    ds exec drush --yes @local_btr vset maintenance_mode 0
}

_make_data_backup() {
    # disable the site for maintenance
    ds exec drush --yes @local_btr vset maintenance_mode 1

    # clear the cache
    ds exec drush --yes @local_btr cache-clear all

    # create the backup dir
    local backup="backup-data-$(date +%Y%m%d)"
    rm -rf $backup
    rm -f $backup.tgz
    mkdir $backup

    # copy the data to the backup dir
    ds inject backup.sh $backup

    # make the backup archive
    tar --create --gzip --preserve-permissions --file=$backup.tgz $backup/
    rm -rf $backup/

    # enable the site
    ds exec drush --yes @local_btr vset maintenance_mode 0
}
