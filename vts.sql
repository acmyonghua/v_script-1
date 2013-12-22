SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   vts.sql
-- Create date: 8/2/2013
-- Modified:    9/11/2013
-- Description: Verification script for Tablespaces.
-- Need: List all the tables in the table space.
--       BEGIN Backup status shows in v$backup.
--       dba_free_space to find out how much free space left
-- Change Log:  9/11/2013 - Changes to work with '%' on table space name.
-- ============================================================================================
SET VERIFY OFF
SET PAGESIZE 1000
SET LINESIZE 88
SET FEEDBACK OFF

-- Setting Serveroutput On to show DBMS_OUTPUT.PUT_LINE Message;
SET SERVEROUTPUT ON

execute v_script.list_tablespace;

-- Prompting User to chose report
PROMPT
PROMPT Please Enter Tablespace Name or * for the Tablespace Reports.
PROMPT Or you can use '%'. eg) sys% will print report for all tablespace start with sys.
ACCEPT p_tablespace_name PROMPT "Input:> "

execute v_script.tablespaces('&p_tablespace_name');

SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON

