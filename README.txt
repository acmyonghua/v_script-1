Script by BoRam Hong
email: boram.hong@gmail.com
Link: http://github.com/borams/v_script

== License ==

Copyright 2013 BoRam Hong.

These programs are free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

These programs are distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

== Description ==
Oracle database verification scripts.
Simple V-Scripts ============================================================
.  @v - Simple Instance Verification
.  @v1 - Instance Verification / Can run on NOMOUNT (V$SGA, V$PARAMETER)
.  @v2 - Database Files Verification
.        (V$CONTROLFILE, V$CONTROLFILE_RECORD_SECTION, DBA_DATA_FILES,
.        DBA_TEMP_FILES, V$LOGFILE, V$LOG, V$DIAG_INFO, DATABASE_PROPERTIES)
.  @v3 - Verification Script for remote database. (No privileges required)

V-Scripts Installation / Privileges (Run as SYS) ============================
.  @v_script - Run as "SYS" user to install v_script package.
.  @vpg - Grant privilege for v_script.
.  @vpc - Uninstall v_script package from system.

Table Verifications =========================================================
.  @vt - Table Structure Verification Script. (Procedure)
.  @vtc - Show record counts on all tables. (Procedure)
.  @vtd - Show Describe for all the tables. (Dynamic SQL)

Tablespace Verifications ====================================================
.  @vts - Tablespace Verification Script. (Procedure)
.  @vts2 - Old Version of Tablespace Verification Script.

User Verifications ==========================================================
.  @vu - User Verification Script. (Procedure)
.  @vu1 - User Roles and Privileges Verification Script. (SQL)

Privilege Verifications =====================================================
.  @vr - Shows privileges granted for a role. (SQL)
.  @vr1 - Shows all users who have a specific role. (SQL)
.  @vr2 - Shows any users who have privileges on object. (SQL)

Archive Mode Verifications ==================================================
.  @va - Shows archive mode settings. (SQL)

Kill Session Verifications ==================================================
.  @vk - Shows any information to kill session.
.        Deadlock information available. (SQL)
.  @vh - Helpful information on oracle.


v_script Package Info =======================================================
v_script.version - Version info
v_script.list_tables - list all tables with record counts
v_script.list_tables('scott') - list all scott's tables with record counts
v_script.list_tablespace - list all tablespace with management type
v_script.list_user - list all database users
v_script.tables('table_name') - print table information in current schema
v_script.tables('table_name','owner') - Print table information in different schema
v_script.tablespaces('tablespace_name') - Print tablespace information
v_script.users('username') - Print schema information


== Installation ==
1. Run v_script.sql as SYS
2. Run vpg.sql as SYS to grant proper privileges to user.
3. @vl.sql for show list of commands.

