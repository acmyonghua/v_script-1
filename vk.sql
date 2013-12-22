SET ECHO OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 87
COL "DB Kill Session" FOR a80
COL ORD NOPRINT
TTITLE OFF

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS "DB Kill Session", 1 ORD FROM DUAL
      UNION
      SELECT 'User Connected:     '||USER AS "DB Kill Session", 2 ORD FROM DUAL
      UNION
      SELECT 'Status:             '||STATUS AS "DB Kill Session", 3 ORD FROM V$INSTANCE
      UNION
      SELECT 'Instance Name:      '||INSTANCE_NAME AS "DB Kill Session", 4 ORD FROM V$INSTANCE
      UNION
      SELECT 'Database Name:      '||value , 5 ORD FROM v$parameter where name in ('db_name')
      UNION
      SELECT ' ', 6 ORD FROM DUAL
      UNION
      SELECT 'Session Kill Help --------------------------------------------------------------', 7 ORD FROM DUAL
      UNION
      SELECT 'ALTER SYSTEM ENABLE RESTRICTED SESSION -> To restrict new session'||chr(10)||chr(10)||
            'ALTER SYSTEM KILL SESSION ''SID,SERIAL#'' -> To Kill Session', 8 ORD FROM DUAL
      UNION
      SELECT ' ', 9 ORD FROM DUAL
      UNION
      SELECT 'Session Info-------------------------------------------------------- (V$SESSION)', 10 ORD FROM DUAL
      UNION
      SELECT 'USERNAME: '||USERNAME||chr(9)||'SID: '||SID||CHR(9)||'SERIAL#: '||SERIAL#||chr(9)||
             '    Wait Time: '||ROUND(SECONDS_IN_WAIT/60,2)||' Minutes', 15 ORD 
      FROM v$SESSION
      WHERE USERNAME IS NOT NULL
      UNION
      SELECT ' ', 20 ORD FROM DUAL
      UNION
      SELECT 'Blocking Info---------------------------- (V$TRANSACTION, V$SESSION, V$ROLLSTAT)', 25 ORD FROM DUAL
      UNION
      SELECT 'USERNAME: '||USERNAME||chr(9)||'SID: '||SID||chr(9)||'SERIAL#: '||SERIAL#, 30 ORD 
      FROM v$SESSION
      WHERE sid IN (SELECT BLOCKING_SESSION FROM V$SESSION)
      UNION
      SELECT 'USERNAME: '||S.USERNAME||chr(9)||'SID: '||S.SID||chr(9)||'SERIAL#: '||S.SERIAL#||
             'Start Trans Time: '||T.START_TIME, 30 ORD 
      FROM V$SESSION S 
      JOIN V$TRANSACTION T 
      ON (s.saddr = t.ses_addr)
      JOIN V$ROLLSTAT R
      ON (t.xidusn = r.usn AND ((r.curext = t.start_uext-1) OR ((r.curext = r.extents-1) AND t.start_uext=0)))
      UNION
      SELECT ' ', 18 ORD FROM DUAL
     )
ORDER BY ORD, 1; 

@@copyright
SET FEEDBACK OFF
SET ECHO OFF
