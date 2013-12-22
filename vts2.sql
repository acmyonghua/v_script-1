SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   vts2.sql
-- Create date: 7/15/2013
-- Modified:    7/30/2013
-- Description: Verification Script for all tablespaces.
-- ============================================================================================
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 87
COL "DB Varification" FOR a80
COL "DB Tablespace Varification" FOR a80
COL ORD NOPRINT
TTITLE OFF

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS "DB Tablespace Varification", 1 ORD FROM DUAL
      UNION
      SELECT 'User Connected:     '||USER AS "DB Varification", 2 ORD FROM DUAL
      UNION
      SELECT 'Status:             '||STATUS AS "DB Varification", 3 ORD FROM V$INSTANCE
      UNION
      SELECT 'Instance Name:      '||INSTANCE_NAME AS "DB Varification", 4 ORD FROM V$INSTANCE
      UNION
      SELECT 'Database Name:      '||value , 5 ORD FROM v$parameter where name in ('db_name')
      UNION  
      SELECT ' ', 6 ORD FROM DUAL
      UNION
      SELECT 'Tablespaces Files Info ------------------------ (DBA_DATA_FILES, DBA_TEMP_FILES)', 7 ORD FROM DUAL
      UNION
      SELECT TABLESPACE_NAME||CHR(9)||FILE_NAME||CHR(10)||CHR(9)||
            'File Size:     '||ROUND(BYTES/1024/1024,2)||'MB / '||ROUND(MAXBYTES/1024/1024,2)||'MB'||CHR(10)||CHR(9)||
            'Autoextend:    '||AUTOEXTENSIBLE||CHR(9)||ROUND(MAXBYTES/MAXBLOCKS*INCREMENT_BY/1024/1024,2)||'MB'||CHR(10)||CHR(9)||
            'Online Status: '||ONLINE_STATUS, 10 ORD 
      FROM DBA_DATA_FILES DDF
      UNION
      SELECT TABLESPACE_NAME||CHR(9)||FILE_NAME||CHR(10)||CHR(9)||
            'File Size:     '||ROUND(BYTES/1024/1024,2)||'MB / '||ROUND(MAXBYTES/1024/1024,2)||'MB'||CHR(10)||CHR(9)||
            'Autoextend:    '||AUTOEXTENSIBLE||CHR(9)||ROUND(MAXBYTES/MAXBLOCKS*INCREMENT_BY/1024/1024,2)||'MB', 11 ORD 
      FROM DBA_TEMP_FILES
      UNION
      SELECT 'Tablespaces Segment Info ------------------------------------- (DBA_TABLESPACES)', 13 ORD FROM DUAL
      UNION
      SELECT TABLESPACE_NAME||CHR(9)||STATUS||CHR(9)||CHR(9)||
            'Extent Management: '||EXTENT_MANAGEMENT||CHR(9)||
            'Allocation Type: '||ALLOCATION_TYPE||CHR(9)||CHR(10)||CHR(9)||
            'TS type:        '||CONTENTS||CHR(10)||CHR(9)||
            'Block Size:     '||ROUND(BLOCK_SIZE/1024,0)||'KB'||CHR(10)||CHR(9)||
            'Minimum Extent: '||ROUND(MIN_EXTLEN/1024,0)||'KB'||CHR(10)||CHR(9)||
            'Initial Extent: '||ROUND(INITIAL_EXTENT/1024,2)||'KB'||CHR(10)||CHR(9)||
            'Next Extent:    '||ROUND(NEXT_EXTENT/1024,2)||'KB'||CHR(10)||CHR(9)||
            'Minextents:     '||MIN_EXTENTS||CHR(10)||CHR(9)||
            'Maxextents:     '||MAX_EXTENTS||CHR(10)||CHR(9)||
            'Pctincrease:    '||PCT_INCREASE||'%'||CHR(10)||CHR(9)||
            'Seg Spc Manage: '||SEGMENT_SPACE_MANAGEMENT, 15 ORD 
      FROM DBA_TABLESPACES
     )
ORDER BY ORD, 1; 

@@copyright

SET FEEDBACK OFF
SET ECHO OFF

