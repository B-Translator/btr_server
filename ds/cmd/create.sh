cmd_create_help() {
    cat <<_EOF
    create
        Create the container '$CONTAINER'.

_EOF
}

rename_function cmd_create orig_cmd_create
cmd_create() {
    local code_dir=$(dirname $(realpath $APP_DIR))
    orig_cmd_create \
        --volume $code_dir:/usr/local/src/btr_server \
        --volume $(pwd)/var-www:/var/www \
        --workdir /var/www \
        --env CODE_DIR=/usr/local/src/btr_server \
        --env DRUPAL_DIR=/var/www/btr

    rm -f btr_server
    ln -s var-www/btr/profiles/btr_server .
}
