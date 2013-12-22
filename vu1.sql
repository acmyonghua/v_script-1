SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   vu1.sql
-- Create date: 8/7/2013
-- Description: Verification Script for users privileges hierarchy. Modified code in internet.
--              Source: http://www.adp-gmbh.ch/ora/misc/recursively_list_privilege.html
-- Change Log:  9/19/2013 - Accepting username from @vu1 prompt. eg) "@vu1 username"
-- ============================================================================================
SET PAGESIZE 1000
SET LINESIZE 87
SET FEEDBACK OFF
SET VERIFY OFF
COL "User, his roles and privileges" FOR a80
TTITLE OFF

SELECT username "Username List" FROM DBA_USERS
ORDER BY username;

PROMPT Enter user name for Privileges Report: 
-- ACCEPT username PROMPT 'Enter user name for Privileges Report: '
DEFINE username = &1

-- Users to roles and system privileges
SELECT
  LPAD(' ', 2*LEVEL) || GRANTED_ROLE || OPT "Privileges Reports"
FROM
  (
  /* THE USERS */
    SELECT 
      NULL     GRANTEE, 
      USERNAME GRANTED_ROLE,
      NULL     OPT    -- BoRam Added to show options.
    FROM 
      DBA_USERS
    WHERE
      USERNAME LIKE UPPER('&username')
  /* THE ROLES TO ROLES RELATIONS */ 
  UNION
    SELECT 
      GRANTEE,
      GRANTED_ROLE,
      ' -- With '||DECODE(ADMIN_OPTION, 'YES', 'Admin Option', 'NO', 'No Admin Option')
      ||DECODE(DEFAULT_ROLE, 'YES', ' (Default)', 'No', '(No Default)')
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
PROMPT
PROMPT Script Modified by BoRam Hong (boram.hong@gmail.com)
PROMPT

UNDEFINE 1

SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON
