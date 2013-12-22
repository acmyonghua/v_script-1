SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   vr2.sql
-- Create date: 8/7/2013
-- Modified:    8/12/2013
-- Description: Verification Script for obj privileges hierarchy. Modified code in internet.
--              Source: http://www.adp-gmbh.ch/ora/misc/recursively_list_privilege.html
-- ============================================================================================
SET PAGESIZE 1000
SET LINESIZE 87
SET FEEDBACK OFF
SET VERIFY OFF
COL "Object Privileges on Object" FOR a80
TTITLE OFF

SELECT username "Username List" FROM DBA_USERS
ORDER BY username;

PROMPT
PROMPT Print Object Privilege Report.
ACCEPT owner PROMPT 'Enter Owner: '

SELECT RPAD(object_name,40)||LPAD(' ('||object_type||')', 15) "Object Name" 
FROM dba_objects 
WHERE owner=UPPER('&owner') 
AND object_type IN ('VIEW', 'TABLE', 'SEQUENCE', 'PROCEDURE', 'FUNCTION')
ORDER BY object_type, object_name;

PROMPT
ACCEPT object_name PROMPT 'Enter Object Name: '

-- Object privileges
SELECT
  CASE WHEN level = 1 THEN own || '.' || obj || ' (' || typ || ')' ELSE
  LPAD (' ', 2*(level-1)) || obj || nvl2 (typ, ' (' || typ || ')', NULL)
  END "Object Privileges on Object"
FROM
  (
  /* THE OBJECTS */
    SELECT 
      NULL          p1, 
      NULL          p2,
      object_name   obj,
      owner         own,
      object_type   typ
    FROM 
      dba_objects
    WHERE
       owner NOT IN 
        ('SYS', 'SYSTEM', 'WMSYS', 'SYSMAN','MDSYS','ORDSYS','XDB', 'WKSYS', 'EXFSYS', 
         'OLAPSYS', 'DBSNMP', 'DMSYS','CTXSYS','WK_TEST', 'ORDPLUGINS', 'OUTLN')
      AND object_type NOT IN ('SYNONYM', 'INDEX')
      AND object_name = UPPER('&object_name') AND owner=UPPER('&owner')  -- Added by BoRam
  /* THE OBJECT TO PRIVILEGE RELATIONS */ 
  UNION
    SELECT
      table_name p1,
      owner      p2,
      grantee,
      grantee,
      privilege
    FROM
      dba_tab_privs
  /* THE ROLES TO ROLES/USERS RELATIONS */ 
  UNION
    SELECT 
      granted_role  p1,
      granted_role  p2,
      grantee,
      grantee,
      NULL
    FROM
      dba_role_privs
  )
START WITH p1 IS NULL AND p2 IS NULL
CONNECT BY p1 = PRIOR obj AND p2 = PRIOR own;

UNDEFINE onwer
UNDEFINE object_name

PROMPT
PROMPT Script Modified by BoRam Hong (boram.hong@gmail.com)
PROMPT


SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON

