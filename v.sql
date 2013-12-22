SET ECHO OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 87
COL "DB Verification" FOR a35
COL ORD NOPRINT
TTITLE OFF

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS "DB Verification", 10 ORD FROM DUAL
      UNION
      SELECT 'User Connected:     '||USER AS "DB Verification", 20 ORD FROM DUAL
      UNION
      SELECT 'Status:             '||STATUS AS "DB Verification", 30 ORD FROM V$INSTANCE
      UNION
      SELECT 'Instance Name:      '||INSTANCE_NAME AS "DB Verification", 40 ORD FROM V$INSTANCE
      UNION
      SELECT RPAD(NAME||':',20)||value , 50 ORD FROM v$parameter WHERE name IN ('db_name', 'instance_type')
      UNION
      SELECT RPAD('Open With: ',20)|| CASE WHEN VALUE IS NULL THEN 'PFILE' 
                                                 ELSE 'SPFILE' END, 60 ORD
      FROM V$SPPARAMETER WHERE NAME = 'control_files'
     )
ORDER BY ORD; 

@@copyright

SET FEEDBACK ON
SET ECHO ON
 