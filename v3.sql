SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   v3.sql
-- Create date: 9/19/2013
-- Description: Verification Script for remote database. Any user can run this.
-- Change Log:  9/19/2013 - file created
-- ============================================================================================
SET VERIFY OFF
SET PAGESIZE 1000
SET LINESIZE 88
SET FEEDBACK OFF
COL ORD NOPRINT
TTITLE OFF

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS 
        "Remote DB Server Info", 1 ORD FROM DUAL
    UNION
    SELECT ' ', 6 ORD FROM DUAL
    UNION
    SELECT 'Clien Info ------------------------------------------------------- (sys_context)', 
            7 ORD FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('SESSION_USER:',25)|| sys_context('USERENV', 'SESSION_USER'), 100 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('CURRENT_SCHEMA:',25)|| sys_context('USERENV', 'CURRENT_SCHEMA'), 
            110 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('CLIENT_INFO:',25)|| sys_context('USERENV', 'CLIENT_INFO'), 120 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('MODULE:',25)|| sys_context('USERENV', 'MODULE'), 130 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('TERMINAL:',25)|| sys_context('USERENV', 'TERMINAL') , 140 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('OS_USER:',25)|| sys_context('USERENV', 'OS_USER'), 150 FROM DUAL
    UNION
    SELECT ' ', 200 ORD FROM DUAL
    UNION
    SELECT 'DB Network Info -------------------------------------------------- (sys_context)', 
            201 ORD FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('DB_NAME:',25)|| sys_context('USERENV', 'DB_NAME'), 210 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('DB_UNIQUE_NAME:',25)|| sys_context('USERENV', 'DB_UNIQUE_NAME'), 
            220 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('SERVICE_NAME:',25)|| sys_context('USERENV', 'SERVICE_NAME'), 230 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('DB_DOMAIN:',25)|| sys_context('USERENV', 'DB_DOMAIN'), 240 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('INSTANCE_NAME:',25)|| sys_context('USERENV', 'INSTANCE_NAME'), 
            250 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('SERVER_HOST:',25)|| UPPER(sys_context('USERENV', 'SERVER_HOST')), 
            260 FROM DUAL
    UNION
    SELECT ' ', 300 ORD FROM DUAL
    UNION
    SELECT 'DB Settings ------------------------------------------------------ (sys_context)', 
            301 ORD FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('CURRENT_EDITION_NAME:',25)||sys_context('USERENV', 'CURRENT_EDITION_NAME')
            , 310 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('LANG:',25)|| sys_context('USERENV', 'LANG'), 320 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('LANGUAGE:',25)|| sys_context('USERENV', 'LANGUAGE'), 330 FROM DUAL
    UNION
    SELECT CHR(9)||RPAD('NLS_DATE_FORMAT:',25)|| sys_context('USERENV', 'NLS_DATE_FORMAT'), 
            340 FROM DUAL
    UNION
    SELECT ' ', 1000 ORD FROM DUAL
)
ORDER BY ORD, 1;

@@copyright

SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON
