SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   vt.sql
-- Create date: 7/31/2013
-- Modified:    9/8/2013
-- Description: Verification script for Tables and Constraints for a user.
--              Connect as table owner to run this script.
-- need to modify to 
-- 1. accomodate partition tables. user_tab_partitions, user_tab_statistics;
-- 2. add comment part of table and columns
-- 3. report child table on primary key.
-- 4. check if the column have index. if so, show the index information
-- Change Log:  9/8/2013 - Modify script to accept '%' for table name. 
-- ============================================================================================
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 88

-- Setting Serveroutput On to show DBMS_OUTPUT.PUT_LINE Message;
SET SERVEROUTPUT ON

PROMPT 
ACCEPT p_owner PROMPT "Please Enter Schema Name [Hit Enter for Current Schema]: "

-- List the tables that the user have.
EXEC v_script.list_tables('&p_owner');

-- Prompting User to chose report
PROMPT
PROMPT Please Enter TABLE_NAME or * for TABLE Reports.
PROMPT You can use '%' for TABLE_NAME. 
PROMPT eg) dim_% for all tables start with dim_.
ACCEPT p_table_name PROMPT "Input:> "


EXEC v_script.tables('&p_table_name','&p_owner');


SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON
