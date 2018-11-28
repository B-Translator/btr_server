
# B-Translator

Drupal installation profile for B-Translator.

The codename *B-Translator* can be decoded like *Bee Translator*,
since it aims at collecting very small translation contributions from
a wide crowd of people and to dilute them into something useful.

It can also be decoded like *Be Translator*, as an invitation to
anybody to give his small contribution for translating programs or
making their translations better.

For more detailed information see: http://info.btranslator.org


## Installation

  - First install Docker:
    https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

  - Then install `ds`, `wsproxy` and `mariadb`:
     + https://github.com/docker-scripts/ds#installation
     + https://github.com/docker-scripts/wsproxy#installation
     + https://github.com/docker-scripts/mariadb#installation


  - Get the code from GitHub, like this:
    ```
    git clone https://github.com/B-Translator/btr_server /opt/docker-scripts/btr_server
    ```

  - Create a directory for the container: `ds init btr_server/ds @btr.example.org`

  - Fix the settings:
    ```
    cd /var/ds/btr.example.org/
    vim settings.sh
    ```

  - Build image, create the container and configure it: `ds make`

  - Customize the local command 'remake': `vim cmd/remake.sh`


## Install B-Translator Client

  - See: https://github.com/B-Translator/btr_client#installation

  - Setup oauth2 login between the client and the server: `ds @bcl.example.org setup-oauth2-login @btr.example.org`
    or
    ```
    cd /var/ds/bcl.example.org/
    ds setup-oauth2-login @btr.example.org
    ```


## Access the website

  - Tell `wsproxy` to manage the domain of this container: `ds wsproxy add`

  - Tell `wsproxy` to get a free letsencrypt.org SSL certificate for
    this domain (if it is a real one): `ds wsproxy ssl-cert`

  - If the domain is not a real one, add to `/etc/hosts` the lines
    `127.0.0.1 btr.example.org` and `127.0.0.1 bcl.example.org` and
    then try in browser https://btr.example.org and
    https://bcl.example.org


## Import the translation data

    ds inject data-get.sh
    ds inject data-import.sh
    
This may take a lot of time (many hours, and maybe a couple of days).


## Backup and restore

    ds backup data
    ds backup dev
    ds backup full
    ds restore <backup-file.tgz>
    
    
## Other commands

    ds help

    ds shell
    ds stop
    ds start
    ds snapshot

    ds inject set-adminpass.sh <new-drupal-admin-passwd>
    ds inject set-domain.sh <new.domain>
    ds inject set-emailsmtp.sh 'smtp_server' <smtp-server> <smtp-domain>
    ds inject set-emailsmtp.sh 'gmail_account' <gmail-user> <gmail-passwd>
    ds inject oauth2-client-add.sh <@alias> <client-key> <client-secret> <https://redirect-uri>
    ds inject set-languages.sh

    ds inject dev/clone.sh test
    ds inject dev/clone-del.sh test
    ds inject dev/clone.sh 01
