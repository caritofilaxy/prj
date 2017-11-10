#!/bin/bash

$SS_ROOT/script/ss_create.pl model DB DBIC::Schema SS::Schema \
    create=static dbi:SQLite:ss.db on_connect_do="PRAGMA foreign_keys = ON"
