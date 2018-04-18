rename_function cmd_remove orig_cmd_remove

cmd_remove() {
    # remove the container, image etc.
    orig_cmd_remove

    # remove the databases
    local dbdata="${DBNAME}_data"
    ds @$DBHOST exec mysql -e "
        drop database if exists $DBNAME;
        drop database if exists ${DBNAME}_data;
    "
}
