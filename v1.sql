SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong
-- File Name:   v1.sql
-- Create date: 7/14/2013
-- Modified:    9/23/2013
-- Description: Verification Script for NOMOUNT.
--              Parameter set for current instance
-- Change log:  add resumable_timeout 
-- ============================================================================================
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 87
COL "DB Verification" FOR a80
COL ORD NOPRINT
TTITLE OFF

SELECT * 
FROM (SELECT 'Today''s Date:       '||TO_CHAR(CURRENT_DATE,'fmmm/dd/yyyy') AS "DB Verification", 10 ORD FROM DUAL
      UNION
      SELECT 'User Connected:     '||USER AS "DB Verification", 20 ORD FROM DUAL
      UNION
      SELECT 'Status:             '||STATUS AS "DB Verification", 30 ORD FROM V$INSTANCE
      UNION
      SELECT 'Instance Name:      '||INSTANCE_NAME AS "DB Verification", 40 ORD FROM V$INSTANCE
      UNION
      SELECT RPAD(NAME||':',20)||value , 50 ORD FROM v$parameter WHERE name IN ('db_name', 'instance_type')
      UNION
      SELECT RPAD('Open With: ',20)|| CASE WHEN VALUE IS NULL THEN 'PFILE' 
                                                 ELSE 'SPFILE' END, 55 ORD
      FROM V$SPPARAMETER WHERE NAME = 'control_files'
      UNION
      SELECT ' ', 60 ORD FROM DUAL
      UNION
      SELECT 'SGA Info --------------------------------------------------------------- (V$SGA)', 70 ORD FROM DUAL
      UNION
      SELECT RPAD(NAME,20)||LPAD(ROUND(VALUE/1024/1024,2),13)||' MB', 80 ORD FROM V$SGA
      UNION
      SELECT RPAD(name,20)||LPAD(ROUND(VALUE/1024/1024,2),13)||' MB', 80 ORD 
       FROM v$parameter 
       WHERE name IN ('sga_target', 'sga_max_size')
      UNION
      SELECT ' ', 90 ORD FROM DUAL
      UNION
      SELECT 'Parameters ------------------------------------------------------- (V$PARAMETER)', 100 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(ROUND(value/1024/1024,2)||' MB',45), 160 ORD 
       FROM v$parameter 
       WHERE name IN ('db_cache_size', 'large_pool_size', 'shared_pool_size')
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 120 ORD 
       FROM v$parameter 
       WHERE name IN ('db_block_size', 'remote_login_passwordfile', 'log_checkpoints_to_alert')
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 130 ORD 
       FROM v$parameter 
       WHERE name IN ('background_dump_dest', 'user_dump_dest', 'diagnostic_dest', 'deferred_segment_creation')
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 140 ORD 
       FROM v$parameter 
       WHERE name IN ('db_files', 'db_file_multiblock_read_count', 'db_domain', 'db_name', 'timed_statistics', 'compatible', 'undo_management', 'undo_retention', 'undo_tablespace',
	                 'sort_area_size', 'nls_territory', 'nls_language')
      UNION
      SELECT ' ', 170 ORD FROM DUAL
      UNION
      SELECT 'Backup Parameter ------------------------------------------------- (V$PARAMETER)', 180 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 190 ORD 
       FROM v$parameter 
       WHERE name IN ('resumable_timeout', 'fast_start_mttr_target', 'db_recovery_file_dest', 'db_recovery_file_dest_size', 'log_archive_start', 'log_archive_max_processes', 'processes', 'recyclebin')
      UNION
      SELECT ' ', 200 ORD FROM DUAL
      UNION
      SELECT 'Memory Parameter ------------------------------------------------- (V$PARAMETER)', 204 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(ROUND(value/1024/1024,2)||' MB',45), 208 ORD 
       FROM v$parameter 
       WHERE name IN ('memory_target', 'memory_max_target','db_16k_cache_size', 'db_2k_cache_size', 'db_32k_cache_size', 'db_4k_cache_size', 'db_8k_cache_size')
      UNION
      SELECT ' ', 210 ORD FROM DUAL
      UNION
      SELECT 'Security Parameter ----------------------------------------------- (V$PARAMETER)', 220 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 230 ORD 
       FROM v$parameter 
       WHERE name IN ('os_authent_prefix', 'remote_os_authent', 'max_enabled_roles'
            , 'resource_limit', 'sec_case_sensitive_logon', 'sql_trace', 'audit_trail', 'audit_file_dest', 'audit_sys_operations')
      UNION
      SELECT ' ', 250 ORD FROM DUAL
      UNION
      SELECT 'Performance Parameter -------------------------------------------- (V$PARAMETER)', 260 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 270 ORD 
      FROM v$parameter 
      WHERE name IN ('create_stored_outlines', 'shared_servers', 'backup_tape_io_slaves', 'dbwr_io_slaves', 'db_file_multiblock_read_count', 'db_writer_processes', 'recovery_parallelism', 'fast_start_parallel_rollback', 'statistics_level')
      UNION
      SELECT ' ', 280 ORD FROM DUAL
      UNION
      SELECT 'Network Parameter ------------------------------------------------ (V$PARAMETER)', 290 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 300 ORD 
       FROM v$parameter 
       WHERE name IN ('listener_networks', 'local_listener', 'remote_listener', 'dispatchers', 'max_dispatchers')
      UNION
      SELECT ' ', 310 ORD FROM DUAL
      UNION
      SELECT 'Rollback Parameter ----------------------------------------------- (V$PARAMETER)', 320 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 330 ORD 
       FROM v$parameter 
       WHERE name IN ('undo_management', 'undo_tablespace', 'rollback_segments', 
                      'transactions_per_rollback_segment', 'transactions')
      UNION
      SELECT ' ', 500 ORD FROM DUAL
      UNION
      SELECT 'OMF Parameter ---------------------------------------------------- (V$PARAMETER)', 510 ORD FROM DUAL
      UNION
      SELECT RPAD(name,35)||RPAD(value,45), 550 ORD 
       FROM v$parameter 
       WHERE name IN ('db_create_file_dest', 'db_create_online_log_dest_1'
            , 'db_create_online_log_dest_2', 'db_create_online_log_dest_3'
            , 'db_create_online_log_dest_4', 'db_create_online_log_dest_5')
	 )
ORDER BY ORD, 1;

@@copyright
SET FEEDBACK ON
SET ECHO ON
