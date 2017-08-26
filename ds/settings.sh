APP=btr_server/ds

### Docker settings.
IMAGE=btr_server
CONTAINER=btr-example-org
SSHD_PORT=2201
#PORTS="80:80 443:443 $SSHD_PORT:22"    ## ports to be forwarded when running stand-alone
PORTS=""    ## no ports to be forwarded when running behind wsproxy

DOMAIN="btr.example.org"
DOMAINS="dev.btr.example.org tst.btr.example.org"  # other domains

### Gmail account for notifications.
### Make sure to enable less-secure-apps:
### https://support.google.com/accounts/answer/6010255?hl=en
GMAIL_ADDRESS=
GMAIL_PASSWD=

### Admin settings.
ADMIN_PASS=

### Translation languages supported by the B-Translator Server.
### Do not remove 'fr', because sometimes French translations
### are used instead of template files (when they are missing).
LANGUAGES='fr de it sq'

### Uncomment if this installation is for development.
DEV=true
