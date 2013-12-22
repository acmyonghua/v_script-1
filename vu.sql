SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   vu.sql
-- Create date: 7/31/2013
-- Modified:    9/11/2013
-- Description: Verification script for users. 
--              v$pwfile_users -> add later for password files
-- Change Log:  9/11/2013 - Now accepting '%' to choose multiple users.
--              9/18/2013 - Now can pass values using '@vu username'
-- ============================================================================================
SET VERIFY OFF
SET PAGESIZE 1000
SET LINESIZE 88
SET FEEDBACK OFF

-- Setting Serveroutput On to show DBMS_OUTPUT.PUT_LINE Message;
SET SERVEROUTPUT ON

EXECUTE v_script.list_user;

-- Prompting User to chose report
PROMPT
PROMPT Please Enter USERNAME or * for Regular User Reports. 
PROMPT (Or "*sys" for with sys and system users Or "*all" for all the users in DB)
PROMPT (Or "%" for search. eg) sys% will print all user starts with sys. )

-- ACCEPT 1 PROMPT "Input:> "
DEFINE p_username = '&1'

EXECUTE v_script.users('&p_username');

UNDEFINE p_username
UNDEFINE 1


SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON

