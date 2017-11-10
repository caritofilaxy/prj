#!/bin/bash

#===============================================================================
#     REVISION:  $Id: prod-email-backup.sh 209 2012-07-09 12:45:19Z xdr.box@gmail.com $
#  DESCRIPTION:  Simple email-based backup script (production)
#===============================================================================

if [ -z "$SS_ROOT" ]; then
    echo "Please set SS_ROOT environment variable"
    exit 1
fi

ENVIRONMENT='production'
FROM_ADDRESS='ss-backup@100slov.ru'
TO_ADDRESS='xdr.box@gmail.com'
RELAY='localhost'
TMP_DIR='/tmp'
EXTRA_EMAIL_SEND_OPTS='-q'
DB_FILE="$SS_ROOT/../db/ss.db"

source "$SS_ROOT/bin/email-backup.inc"
