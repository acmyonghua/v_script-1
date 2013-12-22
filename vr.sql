SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   vr.sql
-- Create date: 8/7/2013
-- Description: Verification Script for role privileges hierarchy. Create the script from
--              Source: http://www.adp-gmbh.ch/ora/misc/recursively_list_privilege.html
-- Change Log:  9/19/2013 - Accepting role from @vu1 prompt. eg) "@vu1 role"
-- ============================================================================================
SET PAGESIZE 1000
SET LINESIZE 87
SET FEEDBACK OFF
SET VERIFY OFF
COL "Role Privileges Reports" FOR a80
TTITLE OFF

SELECT role "Role List" FROM DBA_ROLES
ORDER BY role;

PROMPT Enter role name for Privileges Report: 
-- ACCEPT role PROMPT 'Enter role name for Privileges Report: '
DEFINE role = &1

-- Users to roles and system privileges
SELECT
  LPAD(' ', 2*LEVEL) || GRANTED_ROLE || OPT "Role Privileges Reports"
FROM
  (
  /* THE ROLES */
    SELECT 
      NULL     GRANTEE, 
      ROLE GRANTED_ROLE,
      NULL     OPT
    FROM 
      DBA_ROLES
    WHERE
      ROLE = UPPER('&role')
  /* THE ROLES TO ROLES RELATIONS */ 
  UNION
    SELECT 
      GRANTEE,
      GRANTED_ROLE,
      NULL
    FROM
      DBA_ROLE_PRIVS
  /* THE ROLES TO PRIVILEGE RELATIONS */ 
  UNION
    SELECT
      GRANTEE,
      PRIVILEGE,
      ' -- With '||DECODE(ADMIN_OPTION, 'YES', 'Admin Option', 'NO', 'No Admin Option')
    FROM
      DBA_SYS_PRIVS
  UNION
    SELECT
      GRANTEE,
      PRIVILEGE||' ON '||OWNER||'.'||TABLE_NAME,
      ' -- By '||GRANTOR||DECODE(GRANTABLE, 'YES', ' Grant Option', 'NO', ' No Grant Option')
    FROM
      DBA_TAB_PRIVS
  )
START WITH GRANTEE IS NULL
CONNECT BY GRANTEE = PRIOR GRANTED_ROLE;

UNDEFINE 1

PROMPT
PROMPT Script Modified by BoRam Hong (boram.hong@gmail.com)
PROMPT


SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON
