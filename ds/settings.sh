APP=btr_server/ds

### Docker settings.
IMAGE=btr_server
CONTAINER=btr.example.org
DOMAIN="btr.example.org"

### Uncomment if this installation is for development.
DEV=true

### Other domains.
DOMAINS="dev.$DOMAIN"

### DB settings
DBHOST=mariadb
DBPORT=3306
DBNAME=btr
DBUSER=btr
DBPASS=btr

### SMTP server for sending notifications. You can build an SMTP server
### as described here:
### https://github.com/docker-scripts/postfix/blob/master/INSTALL.md
### Comment out if you don't have a SMTP server and want to use
### a gmail account (as described below).
SMTP_SERVER=smtp.example.org
SMTP_DOMAIN=example.org

### Gmail account for notifications. This will be used by ssmtp.
### You need to create an application specific password for your account:
### https://www.lifewire.com/get-a-password-to-access-gmail-by-pop-imap-2-1171882
GMAIL_ADDRESS=btr.example.org@gmail.com
GMAIL_PASSWD=

### Admin settings.
ADMIN_PASS=123456

### Translation languages supported by the B-Translator Server.
### Do not remove 'fr', because sometimes French translations
### are used instead of template files (when they are missing).
LANGUAGES='fr de it sq'
