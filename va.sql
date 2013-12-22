SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   va.sql
-- Create date: 9/25/2013
-- Description: Verification script for archive log mode.
--              V$ARCHIVE_DEST
-- Change Log:  9/25/2013 - Created 
-- ============================================================================================
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 88

COL "DB Verification" FOR a80
COL ORD NOPRINT
TTITLE OFF
SET HEADING OFF

SELECT * 
FROM (SELECT 'Archive Log Mode' as "Archive Log Mode Settings", 0 ORD FROM DUAL
      UNION
      SELECT 'Settings ---------------------------------------------------------- (V$DATABASE)', 1 ORD FROM DUAL
      UNION
      SELECT RPAD('Log Mode:',19)||RPAD(Log_mode, 30)||'Flashback ON:      '||flashback_on, 10 ORD FROM V$DATABASE
      UNION
      SELECT RPAD('Current SCN:',19)||RPAD(current_scn, 30), 50 FROM V$DATABASE
      UNION
      SELECT RPAD('Reset Log Time:',19)||RPAD(resetlogs_time, 30), 20 FROM V$DATABASE
      UNION
      SELECT RPAD('DB Open Mode:',19)||RPAD(open_mode, 30), 30 FROM V$DATABASE
      UNION
      SELECT RPAD('Platform:',19)||RPAD(platform_name, 30), 40 FROM V$DATABASE
      UNION
      SELECT RPAD('DBID:',19)||RPAD(dbid, 30), 5 FROM V$DATABASE
      UNION
      SELECT RPAD('DB_NAME:',19)||RPAD(name, 30), 2 FROM V$DATABASE
      UNION
      SELECT ' ', 100 ORD FROM DUAL
      UNION
      SELECT 'Archive Destination ------------------------------------------- (V$ARCHIVE_DEST)', 101 ORD FROM DUAL
      UNION
      SELECT RPAD('Dest_name: ',19)||RPAD(dest_name,30)||
             RPAD('Status: ',19)||status||CHR(10)||
             '  '||RPAD('Binding: ',17)||RPAD(binding,30)||
             RPAD('Reopen_secs: ',19)||reopen_secs||CHR(10)||
             '  '||RPAD('Destination: ',17)||RPAD(destination,60)||CHR(10)||
             '  '||RPAD('Schedule: ',17)||RPAD(schedule,30)||CHR(10)||
             '  '||RPAD('Log_sequence: ',17)||RPAD(log_sequence,30), 110
      FROM v$archive_dest WHERE destination IS NOT NULL
      UNION
      SELECT 'Redo Log Status -------------------------------------------------------- (V$LOG)', 150 ORD FROM DUAL
      UNION
      SELECT RPAD('Group#: ',10)||RPAD(group#,5)||
             RPAD('Status: ',10)||RPAD(status,10)||RPAD('Archived: ',10)||RPAD(archived,5)
             ||CHR(10)||'  '||RPAD('Sequence#: ',11)||RPAD(Sequence#,10)
             ||RPAD('First_change#: ',15)||RPAD(FIRST_CHANGE#,10)
             ||RPAD('Next_change#: ',15)||RPAD(NEXT_CHANGE#,10)
            , 155
      FROM v$log 
      UNION
      SELECT ' ', 170 ORD FROM DUAL
      UNION
      SELECT 'Backup Parameter ------------------------------------------------- (V$PARAMETER)', 180 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 190 ORD 
      FROM v$parameter 
      WHERE name IN ('db_recovery_file_dest')
      UNION
      SELECT RPAD(name,35)||RPAD(ROUND(VALUE/1024/1024,2)||'MB',45), 190 ORD 
      FROM v$parameter 
      WHERE name IN ('db_recovery_file_dest_size')
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 200 ORD 
      FROM v$parameter 
      WHERE name IN ('resumable_timeout', 'log_archive_start', 'log_archive_max_processes', 'log_archive_min_succeed_dest', 'log_archive_format')
      UNION
      SELECT ' ', 300 ORD FROM DUAL
      UNION
      SELECT 'Parallel Parameter ----------------------------------------------- (V$PARAMETER)', 301 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 310 ORD 
      FROM v$parameter 
      WHERE name IN ('backup_tape_io_slaves', 'dbwr_io_slaves', 'recovery_parallelism', 'fast_start_parallel_rollback', 'parallel_max_servers', 'processes')
     )
ORDER BY ORD, 1;


@@copyright

SET VERIFY ON
SET FEEDBACK ON
SET HEADING ON
SET ECHO ON
