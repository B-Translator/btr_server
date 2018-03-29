cmd_remake_help() {
    cat <<_EOF
    remake
        Reconstruct again the container, preserving the existing data.

_EOF
}

cmd_remake() {
    # backup
    ds backup

    # reinstall
    ds remove
    ds make
    ds restart
    ds wsproxy ssl-cert

    # restore
    local backup_file="backup-full-$(date +%Y%m%d).tgz"
    ds restore $backup_file
}
