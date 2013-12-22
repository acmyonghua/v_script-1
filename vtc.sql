SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   vtc.sql
-- Create date: 9/1/2013
-- Modified:    9/1/2013
-- Description: Shows row count on each tables.
-- ============================================================================================
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 88
SET SERVEROUTPUT ON

EXEC v_script.list_tables;

@@copyright

-- DROP PROCEDURE user_table_verify;
SET VERIFY ON
SET SERVEROUTPUT OFF
SET FEEDBACK ON
SET ECHO ON
