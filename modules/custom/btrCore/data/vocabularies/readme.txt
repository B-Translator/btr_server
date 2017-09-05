These files can be handled with drush commands, like these:

drush --filter=btranslator
drush btrv-ls
drush btrv-get --help
drush btrv-import --help
drush btrv-add --help

# export
drush btrv-get ICT sq > ICT_sq.txt
drush btrv-get huazime sq > huazime_sq.txt
drush btrv-get ICT de > ICT_de.txt

# import
drush btrv-import ICT sq $(pwd)/ICT_sq.txt
drush btrv-import huazime sq $(pwd)/huazime_sq.txt
drush btrv-import ICT de $(pwd)/ICT_de.txt
