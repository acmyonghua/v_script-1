SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   vr1.sql
-- Create date: 8/7/2013
-- Modified:    8/12/2013
-- Description: Verification Script for privileges hierarchy. Modified code in internet.
--              Source: http://www.adp-gmbh.ch/ora/misc/recursively_list_privilege.html
-- ============================================================================================
SET PAGESIZE 1000
SET LINESIZE 87
SET FEEDBACK OFF
SET VERIFY OFF
COL "Privilege, Roles and Users" FOR a80
TTITLE OFF

SELECT role "Role List" FROM DBA_ROLES;

PROMPT 
ACCEPT privilege PROMPT 'Enter Privilege or Role for user Report: '

-- System privileges to roles and users
SELECT
  LPAD(' ', 2*LEVEL) || C "Privilege, Roles and Users"
FROM
  (
  /* THE PRIVILEGES */
    SELECT 
      NULL   P, 
      NAME   C
    FROM 
      --SYSTEM_PRIVILEGE_MAP --Remove from original
      (SELECT name FROM SYSTEM_PRIVILEGE_MAP
       UNION
       SELECT role FROM DBA_ROLES) -- BoRam Added this to check Privs and Roles
    WHERE
      NAME = UPPER('&privilege')
  /* THE ROLES TO ROLES RELATIONS */ 
  UNION
    SELECT 
      GRANTED_ROLE  P,
      GRANTEE       C
    FROM
      DBA_ROLE_PRIVS
  /* THE ROLES TO PRIVILEGE RELATIONS */ 
  UNION
    SELECT
      PRIVILEGE     P,
      GRANTEE       C
    FROM
      DBA_SYS_PRIVS
  )
START WITH P IS NULL
CONNECT BY P = PRIOR C;

PROMPT
PROMPT Script Modified by BoRam Hong (boram.hong@gmail.com)
PROMPT


SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON

