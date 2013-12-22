SET ECHO OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
COL "DB Help" FOR a80
COL ORD NOPRINT

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS "DB Help", 1 ORD FROM DUAL
      UNION
      SELECT 'User Connected:     '||USER AS "DB Help", 2 ORD FROM DUAL
      UNION
      SELECT 'INSTANCE_NAME:      '||sys_context('USERENV', 'INSTANCE_NAME'), 
            4 FROM DUAL
      UNION
      SELECT 'Database Name:      '||sys_context('USERENV', 'DB_NAME'), 5 FROM DUAL
      UNION
      SELECT ' ', 6 ORD FROM DUAL
      UNION
      SELECT 'Help ---------------------------------------------------------------------------', 7 ORD FROM DUAL
      UNION
      SELECT chr(10)||'Creating Password file:'||chr(10)||
             'C:> orapwd file=C:\orapwU15.ora password=admin entries=5'||chr(10)||chr(10)||
             'ALTER DATABASE DEFAULT TABLESPACE tablespace_name;'||chr(10)||
             'SELECT * FROM DATABASE_PROPERTIES WHERE PROPERTY_NAME LIKE ''%TABLESPACE'';'||chr(10)||chr(10)||
             'When a rollback segment is created, it is offline!!'||chr(10)||
             'ALTER ROLLBACK SEGMENT rollback_segment ONLINE;'
		      , 8 ORD FROM DUAL
      UNION
      SELECT chr(10)||'ARCHIVE LOG LIST'||
             chr(10)||'ALTER SYSTEM SWITCH LOGFILE;'||
             chr(10)||'ALTER SYSTEM CHECKPOINT;'||
             chr(10)||'ALTER SYSTEM ARCHIVE LOG CURRENT;'
                  , 9 ORD FROM DUAL
      UNION
      SELECT chr(10)||'DBA_OUTSTANDING_ALERTS'||
             chr(10)||'DBA_REGISTRY'||
             chr(10)||'V$LOG'||
             chr(10)||'V$LOGFILE (STALE / INVALID)'||
             chr(10)||'V$LOG_HISTORY'||
             chr(10)||
             chr(10)||'V$SGA'||
             chr(10)||'V$INSTANCE'||
             chr(10)||'V$PROCESS'||
             chr(10)||'V$BGPROCESS'||
             chr(10)||'V$DATABASE'||
             chr(10)||'V$DATAFILE'||
             chr(10)||'V$INSTANCE_RECOVERY'||
             chr(10)||'V$FAST_START_SERVERS -> fast_start_parallel_rollback'||
             chr(10)||'V$FAST_START_TRANSACTIONS -> fast_start_parallel_rollback'||
             chr(10)||'V$ARCHIVE_PROCESSES -> Checking ARCn Process'||
             chr(10)||'V$ARCHIVED_LOG'||
             chr(10)||'V$ARCHIVE_DEST'||
             chr(10)||'ALTER DATABASE BACKUP CONTROLFILE TO ''C:\backup.bu'' -> (binary) Online Backukp'||
             chr(10)||'ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS ''C:\backup.bu'' -> Online Backukp'||
             chr(10)||'V$BACKUP -> to check tablespace is in backup mode or not'||
             chr(10)||'V$RECOVER_FILE -> to check all the missing files for in recovery'||
             chr(10)||'V$DATAFILE_HEADER'||
             chr(10)||
             chr(10)||'ALTER DATABASE CLEAR UNARCHIVED LOGFILE GROUP 1;  <- clear and create redo log file'||
             chr(10)||'ALTER DATABASE CLEAR LOGFILE GROUP 1;  <- clear and create redo log file'||
             chr(10)||'ALTER DATABASE {ENABLE | DISABLE} BLOCK CHANGE TRACKING [USING FILE ''...''];   <- for rman change log.(shopping list)'||
             chr(10)||'V$BLOCK_CHANGE_TRACKING <- Show Block change tracking info'||
             chr(10)||
             chr(10)||'V$BACKUP_SET - Target / RC_BACKUP_SET - Catalog : Multi-section info in here'||
             chr(10)||'V$BACKUP_DATAFILE / RC_BACKUP_DATAFILE'||
             chr(10)||'V$SESSION_LONGOPS <- We can see rman job progressing'||
             chr(10)||'V$BACKUP_SYNC_IO <- for perfomance'||
             chr(10)||'V$BACKUP_ASYNC_IO <- LONG_WAIT / IO_COUNT to identify bottle neck'||
             chr(10)||
             chr(10)||'Data Recovery Advisor Views'||
             chr(10)||'V$IR_FAILURE'||
             chr(10)||'V$IR_MANUAL_CHECKLIST'||
             chr(10)||'V$IR_REPAIR'||
             chr(10)||
             chr(10)||'V$DATABASE_BLOCK_CORRUPTION -> for checking block corruption'||
             chr(10)||
             chr(10)||'Flashback transaction query'||
             chr(10)||'SELECT VERSIONS_XID, column FROM table VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE;'||
             chr(10)||'ALTER DATABASE ADD SUPPLEMENTAL LOG DATA; <- need it in 11g for undo_sql'||
             chr(10)||'SELECT * FROM FLASHBACK_TRANSACTION_QUERY WHERE XID=''<versions_xid>''; '||
             chr(10)
                  , 10 ORD FROM DUAL
	 )
ORDER BY ORD, 1; 

@@copyright

SET FEEDBACK ON
SET ECHO ON
