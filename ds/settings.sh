APP=btr_server/ds

### Docker settings.
IMAGE=btr_server
CONTAINER=btr-example-org
DOMAIN="btr.example.org"

### Uncomment if this installation is for development.
DEV=true

### Other domains.
DOMAINS="dev.btr.example.org"

### DB settings
DBHOST=mariadb
DBPORT=3306
DBNAME=btr
DBUSER=btr
DBPASS=btr

### Gmail account for notifications.
### Make sure to enable less-secure-apps:
### https://support.google.com/accounts/answer/6010255?hl=en
GMAIL_ADDRESS=btr.example.org@gmail.com
GMAIL_PASSWD=

### Admin settings.
ADMIN_PASS=123456

### Translation languages supported by the B-Translator Server.
### Do not remove 'fr', because sometimes French translations
### are used instead of template files (when they are missing).
LANGUAGES='fr de it sq'
