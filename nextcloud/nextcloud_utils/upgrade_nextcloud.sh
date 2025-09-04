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

mkdir -p $DOWNLOAD_DIR ../$BACKUP_ID

CURRENT_VERSION=$(check_version)

echo "Current Nextcloud Version: ${CURRENT_VERSION}"
CURRENT_VERSION_NUMBER=$(semver_to_number $CURRENT_VERSION)
echo "Current Nextcloud version number: ${CURRENT_VERSION_NUMBER}"

if [[ ${1} == "" ]]; then
    echo "Usage $0 <Nextcloud version>"
    exit 1
fi

VERSION=$1
VERSION_NUMBER=$(semver_to_number $VERSION)
echo "Requested Version Number: ${VERSION_NUMBER}"

load_nextcloud_config
echo "Loaded Nextcloud Database Configuration:"
echo "DBNAME: ${DBNAME}"
echo "DBUSER: ${DBUSER}"
echo "DBHOST: ${DBOST}"
echo "DBPORT: ${DBPORT}"
echo "CONFIG_IS_READ_ONLY: ${CONFIG_IS_READ_ONLY}"

set_config_read_only_status "false"
set_maintenance "on"

echo "Backup config.php"
cp ../${PROD_DIR}/config/config.php ../${BACKUP_ID}/.

FILENAME="latest-${VERSION}.tar.bz2"
NEXTCLOUD_URL="${BASE_URL}/${FILENAME}"
FILENAME_DL_PATH="${DOWNLOAD_DIR}/${FILENAME}"

if [[ -f "${FILENAME_DL_PATH}" ]]; then
    echo "${FILENAME_DL_PATH} exists, skipping download"
else
    wget $NEXTCLOUD_URL -O $FILENAME_DL_PATH 
fi

echo "Stopping services"
systemctl stop php-fpm
systemctl stop nginx

echo "Renaming production directory ${PROD_DIR} to ${BACKUP_ID}"
mv ../${PROD_DIR}/* ../${BACKUP_ID}/

echo "Backing up database: ${DBNAME}"
backup_database

tar --strip-components=1 -jxf $FILENAME_DL_PATH -C ../${PROD_DIR}

echo "ANTES DE INSTALLED APPS"
INSTALLED_APPS=$(get_installed_apps ${PROD_DIR} ${BACKUP_ID})
echo "DESPUES DE INSTALLED APPS"

echo "Adding installed applications to new nextcloud"
for app in ${INSTALLED_APPS}; do
    echo "Copying ${app}"
    cp -rp ../${BACKUP_ID}/apps/${app} ../${PROD_DIR}/apps/.
done

echo "Restore config.php"
cp ../${BACKUP_ID}/config.php ../${PROD_DIR}/config/config.php
rm ../${PROD_DIR}/config/CAN_INSTALL

pushd ../
echo "Fix permissions"
chown -R root:${WWW_GROUP} ${PROD_DIR}
find ${PROD_DIR} -type d -exec chmod 750 {} \;
find ${PROD_DIR} -type f -exec chmod 640 {} \;
popd

echo "Starting services"
systemctl start php-fpm
systemctl start nginx

set_maintenance "off"
occ_upgrade
set_config_read_only_status "true"

echo "Upgrade from ${CURRENT_VERSION} to ${VERSION} successfully completed"
echo "remember to remove backup directory ../${BACUP_ID} after checking"
echo "that everything is ok"
