#!/bin/bash -x

source /host/settings.sh

### change the prompt to display the chroot name, the git branch etc
echo $CONTAINER > /etc/debian_chroot
sed -i /root/.bashrc \
    -e '/^#force_color_prompt=/c force_color_prompt=yes' \
    -e '/^# get the git branch/,+5 d'
cat <<'EOF' >> /root/.bashrc
# get the git branch (used in the prompt below)
parse_git_branch() {
    local git_branch=$(git branch 2>/dev/null | cut -d' ' -f2)
    [[ -n $git_branch ]] && echo " ($git_branch)"
}
EOF
PS1='\\n\\[\\033[01;32m\\]${debian_chroot:+($debian_chroot)}\\[\\033[00m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\e[32m\\]$(parse_git_branch)\\n==> \\$ \\[\\033[00m\\]'
sed -i /root/.bashrc \
    -e "/^if \[ \"\$color_prompt\" = yes \]/,+2 s/PS1=.*/PS1='$PS1'/"
