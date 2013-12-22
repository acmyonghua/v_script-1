SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   vtd.sql
-- Create date: 9/1/2013
-- Modified:    9/1/2013
-- Description: Dynamic SQL Script that print Descriptions of all the tables that the current
--              Schema has.
-- ============================================================================================

SET HEADING OFF
SET PAGESIZE 0
SET FEED OFF

SPOOL vtd_created.sql
SELECT 'DESC '||TNAME FROM TAB
/
SPOOL OFF
SET ECHO ON
@@vtd_created
SET ECHO OFF
SET HEADING ON
SET FEED ON
SET ECHO ON
