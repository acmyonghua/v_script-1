SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   v2.sql
-- Create date: 7/15/2013
-- Modified:    7/30/2013
-- Description: Verification Script for OPEN DB.
--              Control File, Data File, Temp File, Database Setting, Diag Info
-- ============================================================================================
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 87
COL "DB Verification" FOR a80
COL ORD NOPRINT
TTITLE OFF

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS "DB Verification", 1 ORD FROM DUAL
      UNION
      SELECT 'User Connected:     '||USER AS "DB Verification", 2 ORD FROM DUAL
      UNION
      SELECT 'Status:             '||STATUS AS "DB Verification", 3 ORD FROM V$INSTANCE
      UNION
      SELECT 'Instance Name:      '||INSTANCE_NAME AS "DB Verification", 4 ORD FROM V$INSTANCE
      UNION
      SELECT 'Database Name:      '||value , 5 ORD FROM v$parameter where name in ('db_name')
      UNION
      SELECT RPAD('Open With: ',20)|| CASE WHEN VALUE IS NULL THEN 'PFILE' 
                                                 ELSE 'SPFILE' END, 6 ORD
      FROM V$SPPARAMETER WHERE NAME = 'control_files'
      UNION  
      SELECT ' ', 7 ORD FROM DUAL
      UNION
      SELECT 'Control File Info ---------------------------------------------- (V$CONTROLFILE)', 8 ORD FROM DUAL
      UNION
      SELECT NAME, 9 ORD FROM V$CONTROLFILE
      UNION
      SELECT ' ', 10 ORD FROM DUAL
      UNION
      SELECT 'Control File Record Section --------------------- (V$CONTROLFILE_RECORD_SECTION)', 11 ORD FROM DUAL
      UNION
      select decode(TYPE, 'REDO LOG', 'MAXLOGFILES',
			        'DATAFILE', 'MAXDATAFILES',
			        'DATABASE', 'MAXINSTANCES')||CHR(9)||RECORDS_TOTAL, 12 ORD
      from v$controlfile_record_section
      where type in ('REDO LOG','DATAFILE','DATABASE')
      -- SELECT 'MAX No of '||TYPE||':'||CHR(9)||CHR(9)||RECORDS_TOTAL, 12 ORD FROM V$CONTROLFILE_RECORD_SECTION
      -- WHERE TYPE IN ('DATAFILE', 'REDO LOG', 'DATABASE')
      UNION
      SELECT ' ', 15 ORD FROM DUAL
      UNION
      SELECT 'Datafile Info --------------------------------- (DBA_DATA_FILES, DBA_TEMP_FILES)', 16 ORD FROM DUAL
      UNION
      SELECT RPAD(FILE_ID,2)||RPAD(FILE_NAME,60)||RPAD(TABLESPACE_NAME||': ',9)||LPAD(ROUND(BYTES/1024/1024,2),7)||' M', 17 ORD 
      FROM DBA_DATA_FILES
      UNION
      SELECT RPAD(FILE_NAME,60)||RPAD(TABLESPACE_NAME||': ',9)||LPAD(ROUND(BYTES/1024/1024,2),7)||' MB', 18 ORD 
      FROM DBA_TEMP_FILES
      UNION
      SELECT ' ', 19 ORD FROM DUAL
      UNION
      SELECT 'Redo Log Info ----------------------------------------------- (V$LOGFILE, V$LOG)', 20 ORD FROM DUAL
      UNION
      SELECT 'GROUP '||GROUP#||':'||CHR(9)||f.MEMBER||CHR(9)||ROUND(l.BYTES/1024/1024,2)||' MB', 25 ORD 
      FROM V$LOGFILE f
      JOIN V$LOG l
      USING (GROUP#)
      UNION
      SELECT ' ', 27 ORD FROM DUAL
      UNION
      SELECT 'Database Setup Info -------------------------------------- (DATABASE_PROPERTIES)', 29 ORD FROM DUAL
      UNION
      SELECT RPAD(PROPERTY_NAME,30)||PROPERTY_VALUE, 32 ORD 
      FROM DATABASE_PROPERTIES
      WHERE PROPERTY_NAME IN ('DEFAULT_TEMP_TABLESPACE', 'DEFAULT_PERMANENT_TABLESPACE', 'NLS_LANGUAGE', 
                              'NLS_CHARACTERSET', 'NLS_DATE_FORMAT')
      UNION
      SELECT ' ', 35 ORD FROM DUAL
      UNION
      SELECT 'Diagnostic Info -------------------------------------------------- (V$DIAG_INFO)', 38 ORD FROM DUAL
      UNION
      SELECT RPAD(NAME,23)||VALUE, 40 ORD 
      FROM V$DIAG_INFO
     )
ORDER BY ORD, 1; 

@@copyright
SET FEEDBACK ON
SET ECHO ON
