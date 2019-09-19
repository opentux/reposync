#!/bin/bash
date=`date "+%Y-%m-%d"`

# création du fichier de log et nettoyage à 30jours
exec &> "/var/log/reposync-$date.log"
find /var/log -name "reposync-*.log" -a -mtime +30 -exec rm {} \;

## variable pour definir les noms des depots ##
LOCAL_REPOS="base update extras"
for REPO in ${LOCAL_REPOS}; do

## syncronisation des dépots ##
reposync -l -m --repoid=$REPO --newest-only --download-metadata --download_path=/var/www/html/repos/
##
# Option possible -g pour nettoyer les packages non signé correctement #
# Option possible -d pour nettoyer les packages qui ne doivent plus etre present dans le depot #
# Exemple reposync -g -l -d -m --repoid= #

## création des fichiers de REPODATA ##
createrepo /var/www/html/repos/$REPO/
done


