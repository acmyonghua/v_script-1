SET ECHO OFF
SET VERIFY OFF
PROMPT ##############################################################
PROMPT ##                                                          ##
PROMPT ##                  Clean up the V_Script                   ##
PROMPT ##                                                          ##
PROMPT ##############################################################
PROMPT 


ACCEPT test PROMPT "Please run @vpc as sys user."
REVOKE EXECUTE ON v_script FROM &user_name;
REVOKE SELECT ON DBA_USERS FROM &user_name;
REVOKE SELECT ON DBA_TS_QUOTAS FROM &user_name;
REVOKE SELECT ON DBA_ROLE_PRIVS FROM &user_name;
REVOKE SELECT ON DBA_SYS_PRIVS FROM &user_name;
REVOKE SELECT ON DBA_TAB_PRIVS FROM &user_name;
REVOKE SELECT ON DBA_DATA_FILES FROM &user_name;
REVOKE SELECT ON DBA_TEMP_FILES FROM &user_name;
REVOKE SELECT ON DBA_ROLES FROM &user_name;
REVOKE SELECT ON V_$INSTANCE FROM &user_name;
REVOKE SELECT ON V_$PARAMETER FROM &user_name;
REVOKE SELECT ON V_$SPPARAMETER FROM &user_name;
REVOKE SELECT ON V_$DATABASE FROM &user_name;
REVOKE SELECT ON V_$SGA FROM &user_name;
REVOKE SELECT ON V_$CONTROLFILE FROM &user_name;
REVOKE SELECT ON V_$CONTROLFILE_RECORD_SECTION FROM &user_name;
REVOKE SELECT ON V_$LOG FROM &user_name;
REVOKE SELECT ON V_$LOGFILE FROM &user_name;
REVOKE SELECT ON V_$SESSION FROM &user_name;
REVOKE SELECT ON V_$TRANSACTION FROM &user_name;
REVOKE SELECT ON V_$ROLLSTAT FROM &user_name;
REVOKE SELECT ON DBA_TABLESPACES FROM &user_name;
REVOKE SELECT ON DBA_OBJECTS FROM &user_name;

DROP PUBLIC SYNONYM v_script;
DROP PACKAGE boram;


SET VERIFY ON
SET ECHO ON
