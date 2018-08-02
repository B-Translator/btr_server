include(dbox)

### install other needed tools
RUN apt-get install --yes \
        zip mercurial subversion translate-toolkit dtrx rsstail

### get pology (used for making embedded diffs)
RUN rm -rf /usr/local/lib/pology && \
    svn checkout -r 1387659 \
        svn://anonsvn.kde.org/home/kde/trunk/l10n-support/pology \
        /usr/local/lib/pology
