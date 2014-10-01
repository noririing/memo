#!/bin/sh

export NLS_DATE_FORMAT="YYYY/MM/DD HH24:MI:SS"
export BACKUP_DIR=/u11/app/oracle/backup

rman target / << EOF
RUN {
  configure channel device type disk format='$BACKUP_DIR/full_db_%U';
  backup database plus archivelog delete all input format 'backupset_%t_%s_%p';
  backup current controlfile;
  report obsolete;
  delete noprompt obsolete;
  restore database validate;
}
EOF
