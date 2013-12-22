SET ECHO OFF
SET VERIFY OFF
PROMPT ##############################################################
PROMPT ##                                                          ##
PROMPT ##             Grant Privileges for V_Script                ##
PROMPT ##                                                          ##
PROMPT ##############################################################
PROMPT 

PROMPT You have to run @v_script.sql first.
PROMPT Please run @vpg as sys or system user.
ACCEPT user_name PROMPT 'Please enter username who will run v_script: '
-- PROMPT Please Enter SYS Password: 

-- conn sys as sysdba

-- UNDEFINE sys_password

GRANT EXECUTE ON v_script TO &user_name;
GRANT SELECT ON DBA_USERS TO &user_name;
GRANT SELECT ON DBA_TS_QUOTAS TO &user_name;
GRANT SELECT ON DBA_ROLE_PRIVS TO &user_name;
GRANT SELECT ON DBA_SYS_PRIVS TO &user_name;
GRANT SELECT ON DBA_TAB_PRIVS TO &user_name;
GRANT SELECT ON DBA_DATA_FILES TO &user_name;
GRANT SELECT ON DBA_TEMP_FILES TO &user_name;
GRANT SELECT ON DBA_ROLES TO &user_name;
GRANT SELECT ON V_$INSTANCE TO &user_name;
GRANT SELECT ON V_$PARAMETER TO &user_name;
GRANT SELECT ON V_$SPPARAMETER TO &user_name;
GRANT SELECT ON V_$DATABASE TO &user_name;
GRANT SELECT ON V_$SGA TO &user_name;
GRANT SELECT ON V_$CONTROLFILE TO &user_name;
GRANT SELECT ON V_$CONTROLFILE_RECORD_SECTION TO &user_name;
GRANT SELECT ON V_$LOG TO &user_name;
GRANT SELECT ON V_$LOGFILE TO &user_name;
GRANT SELECT ON V_$SESSION TO &user_name;
GRANT SELECT ON V_$TRANSACTION TO &user_name;
GRANT SELECT ON V_$ROLLSTAT TO &user_name;
GRANT SELECT ON DBA_TABLESPACES TO &user_name;
GRANT SELECT ON DBA_OBJECTS TO &user_name;

-- PROMPT Please Enter &user_name Password
-- conn &user_name

-- UNDEFINE user_name
