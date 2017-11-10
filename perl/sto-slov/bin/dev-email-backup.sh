#!/bin/bash

#===============================================================================
#     REVISION:  $Id: dev-email-backup.sh 208 2012-07-09 11:17:15Z xdr.box@gmail.com $
#  DESCRIPTION:  Simple email-based backup script (development)
#===============================================================================

if [ -z "$SS_ROOT" ]; then
    echo "Please set SS_ROOT environment variable"
    exit 1
fi

ENVIRONMENT='development'
FROM_ADDRESS='entropyware@inbox.ru'
TO_ADDRESS='xdr.box@gmail.com'
RELAY='localhost'
TMP_DIR='/tmp'
EXTRA_EMAIL_SEND_OPTS='-q'
DB_FILE="$SS_ROOT/ss.db"

source "$SS_ROOT/bin/email-backup.inc"
