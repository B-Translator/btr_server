#!/bin/bash
### This script works by renaming files and doing find/replace in them.

### Output the usage of the script and stop it.
usage() {
    cat <<EOF
Usage: $0 <from_project>:<to_project> <from_prefix>:<to_prefix>

Example: $0 btr_server:myproject btr:proj

EOF
    exit 1
}

### rename_files $from $to
### The first argument is replaced with the second argument
### in all file and directory names in the current directory.
rename_all_files() {
    local from=$1
    local to=$2

    local files=$(find . -name "*$from*")
    while test -n "$files"; do
	for file in $files; do
	    file1=${file/$from/$to}
            mv $file $file1 2> /dev/null
	done
	files=$(find . -name "*$from*")
    done
}

### replace_in_all_files $from $to
### Replace the first argument with the second argument
### in all the files of the currect directory.
replace_in_all_files() {
    local from=$1
    local to=$2

    for file in $(find . -type f); do
        sed -i $file -e "s/$from/$to/g"
    done
}

### Get the parameters.
[[ $# -ne 2 ]] && usage
from_project=${1/:*}
[[ -z $from_project ]] && usage
to_project=${1#*:}
[[ -z $to_project ]] && usage
from_prefix=${2/:*}
[[ -z $from_prefix ]] && usage
to_prefix=${2#*:}
[[ -z $to_prefix ]] && usage

### Rename and replace all files in the script directory.
cd $(dirname $0)
rm -rf .git
rename_all_files $from_project $to_project
rename_all_files $from_prefix $to_prefix
replace_in_all_files $from_project $to_project
replace_in_all_files ${from_project^} ${to_project^}
replace_in_all_files $from_prefix $to_prefix

