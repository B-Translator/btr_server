cmd_clone_help() {
    cat <<_EOF
    clone <tag>
        Make a clone from 'btr' to 'btr_<tag>'.
        <tag> can be something like 'dev', 'test', '01', etc.

_EOF
}

cmd_clone() {
    local tag=$1
    [[ -n $tag ]] || fail "Usage:\n $(cmd_clone_help)"

    # delete it first if it exists
    ds clone-del $tag

    # clone the db
    local dbname="${DBNAME}_${tag}"
    ds @$DBHOST clone $DBNAME $dbname
    ds @$DBHOST exec mysql -e "GRANT ALL ON $dbname.* TO $DBUSER@'$CONTAINER.$NETWORK'"

    # clone the site
    ds inject dev/clone.sh $tag

    # add the new domain to wsproxy
    ds @wsproxy domains-add $CONTAINER $tag.$DOMAIN

    # add a new line on /etc/hosts @wsproxy
    local ip=$(ds exec hostname --ip-address)
    ds @wsproxy exec sh -c "echo '$ip $tag.$DOMAIN' >> /etc/hosts"
}
