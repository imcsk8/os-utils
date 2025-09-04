#!/bin/bash

# Upgrades nextcloud to a given version
# © Iván Chavero <ichavero@chavero.com.mx>

# This script assumes that the 'html' directory is one level above the current
# directory.
# This script should only be run if the data directory is outside
# the document root

set -xe

source nu.shlib

BASE_URL="https://download.nextcloud.com/server/releases/"
# Let's be relative to the current directory
BACKUP_ID="backup_$( date +%F )"
PROD_DIR="html"
DOWNLOAD_DIR="downloads"
WWW_USER="nginx"
WWW_GROUP="nginx"


load_nextcloud_config
echo "Loaded Nextcloud Database Configuration:"
echo "DBNAME: ${DBNAME}"
echo "DBUSER: ${DBUSER}"
echo "DBHOST: ${DBOST}"
echo "DBPORT: ${DBPORT}"
echo "CONFIG_IS_READ_ONLY: ${CONFIG_IS_READ_ONLY}"

echo "ANTES DE INSTALLED APPS"
INSTALLED_APPS=$(get_installed_apps ${PROD_DIR} ${BACKUP_ID})
echo "DESPUES DE INSTALLED APPS"

echo "Adding installed applications to new nextcloud"
for app in ${INSTALLED_APPS}; do
    echo "Copying ${app}"
    cp -rp ../${BACKUP_ID}/apps/${app} ../${PROD_DIR}/apps/.
done
