SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong boramhong@gmail.com
-- File Name:   vl.sql
-- Create date: 9/7/2013
-- Modified:    9/7/2013
-- Description: Show list of Verification Scripts.
-- ============================================================================================
SET VERIFY OFF
SET FEEDBACK OFF
SET PAGESIZE 1000
SET LINESIZE 88

PROMPT
PROMPT
PROMPT ##########################################################################################
PROMPT ##                                                                                      ##
PROMPT ##          Verification List / Created by BoRam Hong (boramhong@gmail.com)             ##
PROMPT ##                                                                                      ##
PROMPT ##########################################################################################
PROMPT
PROMPT Simple V-Scripts ============================================================

PROMPT .  @v - Simple Instance Verification
PROMPT .  @v1 - Instance Verification / Can run on NOMOUNT (V$SGA, V$PARAMETER)
PROMPT .  @v2 - Database Files Verification 
PROMPT .        (V$CONTROLFILE, V$CONTROLFILE_RECORD_SECTION, DBA_DATA_FILES,
PROMPT .        DBA_TEMP_FILES, V$LOGFILE, V$LOG, V$DIAG_INFO, DATABASE_PROPERTIES)
PROMPT .  @v3 - Verification Script for remote database. (No privileges required)
PROMPT
PROMPT V-Scripts Installation / Privileges (Run as SYS) ============================

PROMPT .  @v_script - Run as "SYS" user to install v_script package.
PROMPT .  @vpg - Grant privilege for v_script.
PROMPT .  @vpc - Uninstall v_script package from system.
PROMPT
PROMPT Table Verifications =========================================================

PROMPT .  @vt - Table Structure Verification Script. (Procedure)
PROMPT .  @vtc - Show record counts on all tables. (Procedure)
PROMPT .  @vtd - Show Describe for all the tables. (Dynamic SQL)
PROMPT
PROMPT Tablespace Verifications ====================================================

PROMPT .  @vts - Tablespace Verification Script. (Procedure)
PROMPT .  @vts2 - Old Version of Tablespace Verification Script. 
PROMPT
PROMPT User Verifications ==========================================================

PROMPT .  @vu - User Verification Script. (Procedure)
PROMPT .  @vu1 - User Roles and Privileges Verification Script. (SQL) 
PROMPT
PROMPT Privilege Verifications =====================================================

PROMPT .  @vr - Shows privileges granted for a role. (SQL)
PROMPT .  @vr1 - Shows all users who have a specific role. (SQL)
PROMPT .  @vr2 - Shows any users who have privileges on object. (SQL)
PROMPT
PROMPT Archive Mode Verifications ==================================================

PROMPT .  @va - Shows archive mode settings. (SQL)
PROMPT
PROMPT Kill Session Verifications ==================================================

PROMPT .  @vk - Shows any information to kill session. 
PROMPT .        Deadlock information available. (SQL)
PROMPT .  @vh - Helpful information on oracle.
PROMPT
@@copyright

SET VERIFY ON
SET FEEDBACK ON
SET ECHO ON
