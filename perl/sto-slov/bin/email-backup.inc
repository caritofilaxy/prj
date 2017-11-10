#!/bin/bash

#===============================================================================
#     REVISION:  $Id: email-backup.inc 208 2012-07-09 11:17:15Z xdr.box@gmail.com $
#  DESCRIPTION:  Email DB backup 
#  DESCRIPTION:  Simple email-based backup script (common stuff)
#===============================================================================

EMAIL_SEND="$SS_ROOT/bin/sendEmail"
BACKUP_DATE=`date +%F`
BACKUP_FILE="$TMP_DIR/ss_dump-$BACKUP_DATE.gz"
SUBJECT="SS DB backup $BACKUP_DATE/$ENVIRONMENT"

trap "rm $BACKUP_FILE" EXIT
sqlite3 "$DB_FILE" '.dump' | gzip > "$BACKUP_FILE"
$EMAIL_SEND -f "$FROM_ADDRESS" \
            -t "$TO_ADDRESS"  \
            -u "$SUBJECT" \
            -m "SS DB backup $BACKUP_DATE/$ENVIRONMENT" \
            -a "$BACKUP_FILE" \
            -s "$RELAY" \
            $EXTRA_EMAIL_SEND_OPTS
