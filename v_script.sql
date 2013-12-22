SET ECHO OFF
-- ============================================================================================
-- Author:      BoRam Hong         boramhong@gmail.com
-- Web:         http://github.com/borams/v_script
-- File Name:   v_script.sql
-- Create date: 12/21/2013
-- Modified:    12/21/2013
-- Important:   Run this script as "sys" user.
-- Description: Package for verification script.
--              Need to grant execute on v_script(package) to user before you use script.
--              ex) GRANT EXECUTE ON v_script TO scott;
-- ============================================================================================

CREATE OR REPLACE PACKAGE boram AS

-- Tablespaces Verify for @vts
PROCEDURE tablespaces (p_tablespace_name IN VARCHAR2);

-- User verify for @vu
PROCEDURE users(p_user_name IN VARCHAR2);

-- Table verify for @vt
PROCEDURE tables(p_table_name IN VARCHAR2, p_owner IN VARCHAR2 DEFAULT NULL);

-- Table list
PROCEDURE list_tables(p_owner IN VARCHAR2 DEFAULT NULL);

-- Tablespace list
PROCEDURE list_tablespace;

-- User List
PROCEDURE list_user;

-- Copyright
PROCEDURE version;

END boram;
/

CREATE OR REPLACE PACKAGE BODY boram AS

VERSION_NO VARCHAR2(20) := '0.1';
LAST_UPDATE DATE := TO_DATE('12/21/2013 07:11:00', 'MM/DD/YYYY HH:MI:SS');

-- Tablespace Verify for @vts
PROCEDURE tablespace_verify (v_tablespace_name IN VARCHAR2);

-- User Verify for @vu
PROCEDURE user_verify (v_user IN VARCHAR2);

-- User Table Verification for @vt
PROCEDURE table_verify (v_table_name IN VARCHAR2, v_schema_name IN VARCHAR2);

PROCEDURE version AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10)||RPAD('Last Updated: '||TO_CHAR(LAST_UPDATE,'fmMM/DD/YYYY'),44)||'Version: '||VERSION_NO);
    DBMS_OUTPUT.PUT_LINE('http://github.com/borams/v_script | boram.hong@gmail.com');
END version;

-- User Table Verification for @vt
PROCEDURE table_verify (v_table_name IN VARCHAR2, v_schema_name IN VARCHAR2)
AS
      v_wrong           EXCEPTION;
      v_count_rec       NUMBER(10);
      v_temp_string     VARCHAR2(4000);

      CURSOR dba_tables_cursor (par_table_name DBA_TABLES.table_name%TYPE,
                                par_owner DBA_TABLES.owner%TYPE) IS
        SELECT * FROM DBA_TABLES 
        WHERE table_name=UPPER(par_table_name) AND owner=UPPER(par_owner);
      CURSOR dba_tab_columns_cursor (par_table_name DBA_TAB_COLUMNS.table_name%TYPE) IS
        SELECT * FROM DBA_TAB_COLUMNS 
        WHERE TABLE_NAME=par_table_name
        ORDER BY COLUMN_ID;
      CURSOR dba_cons_columns_cursor (par_table_name DBA_TAB_COLUMNS.table_name%TYPE, 
                                       par_column_name DBA_CONS_COLUMNS.column_name%TYPE) IS
        SELECT * FROM DBA_CONS_COLUMNS cc 
        JOIN DBA_CONSTRAINTS c
        USING(CONSTRAINT_NAME) 
        WHERE cc.TABLE_NAME=par_table_name AND cc.COLUMN_NAME=par_column_name;
      CURSOR dba_indexes_cursor (par_index_name DBA_INDEXES.index_name%TYPE) IS
        SELECT * FROM DBA_INDEXES WHERE index_name=UPPER(par_index_name);
      CURSOR dba_cons_columns_cursor2 (par_constraint_name DBA_CONS_COLUMNS.constraint_name%TYPE) IS
        SELECT * FROM DBA_CONS_COLUMNS WHERE constraint_name=par_constraint_name;
      CURSOR dba_tablespaces_cursor (par_tablepsace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
        SELECT * FROM DBA_TABLESPACES WHERE tablespace_name=par_tablepsace_name;
BEGIN
      SELECT COUNT(*) INTO v_count_rec FROM DBA_TABLES WHERE table_name=v_table_name;
      -- if table name is not in the dba_table, then don't need to loop cursors.
      IF v_count_rec > 0 THEN
        -- Table information from DBA_TABLES.
        FOR dba_tables_record IN dba_tables_cursor (v_table_name, v_schema_name) LOOP
          FOR dba_tablespaces_record IN dba_tablespaces_cursor (dba_tables_record.tablespace_name) 
          LOOP
            v_temp_string := CHR(10)||'Table Name: '||v_table_name||' in Tablespace: '
                 ||dba_tables_record.tablespace_name||'('||dba_tablespaces_record.extent_management||')';
            IF dba_tablespaces_record.extent_management = 'LOCAL' THEN
              v_temp_string := v_temp_string ||CHR(9)|| 'UNIFORM SIZE: '
                               ||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB';
            ELSE
              v_temp_string := v_temp_string ||CHR(9)|| 'MINIMUM EXTENT: '
                               ||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB';
            END IF;
          END LOOP;
          DBMS_OUTPUT.PUT_LINE(v_temp_string);
          DBMS_OUTPUT.PUT_LINE(CHR(9)
          ||'General Info ----------------------------------------------------- (DBA_TABLES)');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'Status: '||dba_tables_record.status||CHR(9)||'Logging: '
          ||dba_tables_record.logging||CHR(9)||'Table lock: '||dba_tables_record.table_lock);
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'Read Only: '||dba_tables_record.read_only||CHR(9)
                ||'Row Movement: '||dba_tables_record.row_movement);
          DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(9)
          ||'Storage Info ----------------------------------------------------- (DBA_TABLES)');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  + Segments Setting (Segment Created: '||dba_tables_record.segment_created||')');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||'INITIAL: '
                          ||ROUND(dba_tables_record.initial_extent/1024,0)||' KB'||CHR(9)||
                          CHR(9)||'NEXT: '||ROUND(dba_tables_record.next_extent/1024,0)||' KB');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||'MINEXTENTS: '||dba_tables_record.min_extents||
                               CHR(9)||CHR(9)||'MAXEXTENTS: '||dba_tables_record.max_extents||
                               CHR(9)||CHR(9)||'PCTINCREASE: '||dba_tables_record.pct_increase);
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  + Blocks Setting');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||'PCTFREE: '||dba_tables_record.pct_free||
                               CHR(9)||CHR(9)||'PCTUSED: '||dba_tables_record.pct_used);
          DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||'INITRANS: '||dba_tables_record.ini_trans||
                               CHR(9)||CHR(9)||'MAXTRANS: '||dba_tables_record.max_trans);
          DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(9)
          ||'Column Info -------------------------------------------------- (DBA_TAB_COLUMS)');
          -- Column information from DBA_TAB_COLUMNS
          FOR dba_tab_columns_record IN dba_tab_columns_cursor (v_table_name) LOOP
            v_temp_string := CHR(9)||'=== Column: '||RPAD(dba_tab_columns_record.column_name, 26);
            v_temp_string := v_temp_string||dba_tab_columns_record.data_type;
            -- Checking data type and print proper information.
            IF dba_tab_columns_record.data_type = 'NUMBER' THEN
              v_temp_string := v_temp_string ||'('|| dba_tab_columns_record.data_precision ||','
                               ||dba_tab_columns_record.data_scale||')';
            ELSIF dba_tab_columns_record.data_type IN ('DATE', 'LONG')  THEN
              v_temp_string := v_temp_string||CHR(9);
            ELSE
              v_temp_string := v_temp_string ||'('|| dba_tab_columns_record.data_length||')';
            END IF;
            -- Checking Nullable
            IF dba_tab_columns_record.nullable = 'Y' THEN
              v_temp_string := v_temp_string ||CHR(9)||'Null: Yes';
            ELSE
              v_temp_string := v_temp_string ||CHR(9)||'Null: No';
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_temp_string);
            -- Checking for Default Values. Print it if there is a value.
            IF dba_tab_columns_record.data_default IS NOT Null THEN
              v_temp_string := CHR(9)||CHR(9)||'Data Default: '||dba_tab_columns_record.data_default;
              DBMS_OUTPUT.PUT_LINE(v_temp_string);
            END IF;
            -- All the constraints on each column.
            FOR dba_cons_columns_record IN dba_cons_columns_cursor (v_table_name, 
                                                              dba_tab_columns_record.column_name) LOOP
              DBMS_OUTPUT.PUT_LINE(CHR(9)||'    '||RPAD(dba_cons_columns_record.constraint_name,32,'-')
                                  ||LPAD('(DBA_CONS_COLUMNS,DBA_CONSTRAINTS)',43,'-'));
              IF dba_cons_columns_record.constraint_type = 'C' THEN  -- Report for check constraints.
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'+ CHECK:   '||dba_cons_columns_record.deferrable
                      ||' '||dba_cons_columns_record.deferred||CHR(9)||dba_cons_columns_record.status
                      ||'  '||dba_cons_columns_record.validated);
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'  '||dba_cons_columns_record.search_condition);
              ELSIF dba_cons_columns_record.constraint_type = 'P' THEN  -- Report for PK constraints.
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'+ PRIMARY KEY: '
                  ||dba_cons_columns_record.deferrable||' '||dba_cons_columns_record.deferred||CHR(9)
                  ||dba_cons_columns_record.status||'  '||dba_cons_columns_record.validated);
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'  INDEX: '
                  ||RPAD(dba_cons_columns_record.index_name,32,'-')||LPAD('(DBA_INDEXES)',31,'-'));
                -- Print information on index for primary kye
                FOR dba_indexes_record IN dba_indexes_cursor(dba_cons_columns_record.index_name) LOOP
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||' INDEX TYPE: '||dba_indexes_record.index_type
                    ||CHR(9)||dba_indexes_record.uniqueness||'   '||CHR(9)
                    ||'Logging: '||dba_indexes_record.logging);
                    -- Getting information about tablespace.
                    FOR dba_tablespaces_record IN dba_tablespaces_cursor 
                                                  (dba_indexes_record.tablespace_name) LOOP
                      v_temp_string := CHR(9)||CHR(9)||' Tablespace: '
                           ||dba_indexes_record.tablespace_name||'('
                           ||dba_tablespaces_record.extent_management||')';
                      IF dba_tablespaces_record.extent_management = 'LOCAL' THEN  -- For Local
                        v_temp_string := v_temp_string ||CHR(9)|| 'UNIFORM SIZE: '
                                         ||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB';
                      ELSE  -- For Dictionary
                        v_temp_string := v_temp_string ||CHR(9)|| 'MINIMUM EXTENT: '
                                         ||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB';
                      END IF;
                    END LOOP;  -- End Loop for dba_tablespaces_cursor
                  DBMS_OUTPUT.PUT_LINE(v_temp_string);  -- Print Tablespace Info
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||' Segment Info: '||CHR(9)||'INITIAL: '
                    ||ROUND(dba_indexes_record.initial_extent/1024,0)||' KB     '||CHR(9)||'NEXT: '
                    ||ROUND(dba_indexes_record.next_extent/1024,0)||' KB');
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||'    '||'MINEXTENTS: '
                    ||dba_indexes_record.min_extents||'   MAXEXTENTS: '
                    ||dba_indexes_record.max_extents||'   PCTINCREASE: '
                    ||dba_indexes_record.pct_increase);
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||' Block Info: '||CHR(9)||'PCTFREE: '
                    ||dba_indexes_record.pct_free||CHR(9)||'INITRANS: '
                    ||dba_indexes_record.ini_trans||CHR(9)||'MAXTRANS: '
                    ||dba_indexes_record.max_trans);
                END LOOP; -- End Loop dba_indexes_cursor.
              ELSIF dba_cons_columns_record.constraint_type = 'U' THEN  -- Report for UK constraints.
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'+ UNIQUE KEY: '
                  ||dba_cons_columns_record.deferrable||' '||dba_cons_columns_record.deferred
                  ||CHR(9)||dba_cons_columns_record.status||'  '||dba_cons_columns_record.validated);
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'  INDEX: '
                  ||RPAD(dba_cons_columns_record.index_name,32,'-')||LPAD('(DBA_INDEXES)',31,'-'));
                -- Print information on index for unique key.
                FOR dba_indexes_record IN dba_indexes_cursor(dba_cons_columns_record.index_name) LOOP
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||' INDEX TYPE: '||dba_indexes_record.index_type
                    ||CHR(9)||dba_indexes_record.uniqueness||'   '||CHR(9)||'Logging: '
                    ||dba_indexes_record.logging);
                    -- Getting information about tablespace.
                    FOR dba_tablespaces_record IN dba_tablespaces_cursor 
                                                         (dba_indexes_record.tablespace_name) LOOP
                      v_temp_string := CHR(9)||CHR(9)||' Tablespace: '
                           ||dba_indexes_record.tablespace_name||'('
                           ||dba_tablespaces_record.extent_management||')';
                      IF dba_tablespaces_record.extent_management = 'LOCAL' THEN  -- For Local
                        v_temp_string := v_temp_string ||CHR(9)|| 'UNIFORM SIZE: '
                                         ||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB';
                      ELSE  -- For Dictionary
                        v_temp_string := v_temp_string ||CHR(9)|| 'MINIMUM EXTENT: '
                                         ||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB';
                      END IF;
                    END LOOP;  -- End Loop for dba_tablespaces_cursor
                  DBMS_OUTPUT.PUT_LINE(v_temp_string);  -- Print Tablespace Info
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||' Segment Info: '||CHR(9)||'INITIAL: '
                    ||ROUND(dba_indexes_record.initial_extent/1024,0)||' KB     '||CHR(9)||'NEXT: '
                    ||ROUND(dba_indexes_record.next_extent/1024,0)||' KB');
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||'    '||'MINEXTENTS: '
                    ||dba_indexes_record.min_extents||'   MAXEXTENTS: '
                    ||dba_indexes_record.max_extents||'   PCTINCREASE: '
                    ||dba_indexes_record.pct_increase);
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||CHR(9)||' Block Info: '||CHR(9)||'PCTFREE: '
                    ||dba_indexes_record.pct_free||CHR(9)||'INITRANS: '
                    ||dba_indexes_record.ini_trans||CHR(9)||'MAXTRANS: '
                    ||dba_indexes_record.max_trans);
                END LOOP; -- End Loop dba_indexes_cursor.
              ELSIF dba_cons_columns_record.constraint_type = 'R' THEN  -- Report for FK constraints.
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'+ FOREIN KEY: '
                  ||dba_cons_columns_record.deferrable||' '||dba_cons_columns_record.deferred||CHR(9)
                  ||dba_cons_columns_record.status||'  '||dba_cons_columns_record.validated);
                -- Find parent table and column for forein key
                FOR dba_cons_columns_record2 IN dba_cons_columns_cursor2
                                                     (dba_cons_columns_record.r_constraint_name)LOOP
                  DBMS_OUTPUT.PUT_LINE(CHR(9)||'     '||'  Reference: '
                    ||dba_cons_columns_record2.table_name||'('||dba_cons_columns_record2.column_name||')');
                END LOOP;  -- End Loop for dba_cons_columns_cursor2
              END IF; -- End if for type of constraints.
            END LOOP; -- End Loop for dba_cons_columns_cursor
            DBMS_OUTPUT.PUT_LINE(CHR(9));  -- Blank line after each column
          END LOOP; -- End Loop for dba_tab_columns_cursor

        END LOOP; -- End Loof for dba_tables_cursor
      ELSE
            -- Raise the excpetion and give error message for no table name found.
            RAISE v_wrong;
      END IF;  -- End if for checking tables.

      EXCEPTION
      WHEN v_wrong THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10)||'Error -----------------------'||CHR(10)||
                                       'Table: '||v_table_name||' was not found in DB!');
      WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10)||'Table: '||v_table_name||' was not found in DB!');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
END table_verify;

PROCEDURE tables(p_table_name IN VARCHAR2, p_owner IN VARCHAR2 DEFAULT NULL) AS
  v_table_name      DBA_TABLES.table_name%TYPE := UPPER(p_table_name);
  v_owner           DBA_TABLES.owner%TYPE := UPPER(p_owner);
  v_wrong         EXCEPTION;

  -- cursor for '*' all tables.
  CURSOR dba_tables_cursor IS
      SELECT * FROM DBA_TABLES;
  -- cursor for single or '%' table names
  CURSOR dba_tables_like_cursor (par_table_name DBA_TABLES.table_name%TYPE,
                                  par_owner DBA_TABLES.owner%TYPE) IS
      SELECT * FROM DBA_TABLES 
      WHERE table_name like par_table_name AND owner=par_owner;
 
BEGIN
  -- Checking if v_owner is null or not
  IF v_owner IS NULL OR TRIM(v_owner) = '' THEN
    SELECT USER 
    INTO v_owner
    FROM dual;
  END IF;
  -- Print report for All the users in DB
  IF v_table_name = '*' THEN 
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'All the tables in this schema DB.'||CHR(10));
    FOR dba_tables_record IN dba_tables_cursor LOOP
      table_verify(dba_tables_record.table_name, v_owner);
      -- DBMS_OUTPUT.PUT_LINE(dba_tables_record.table_name);
    END LOOP;
  ELSE
    FOR dba_tables_like_record IN dba_tables_like_cursor(v_table_name, v_owner) LOOP
      table_verify(dba_tables_like_record.table_name, v_owner);
    END LOOP;
  END IF;

  version;

  EXCEPTION
    WHEN v_wrong THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Error -----------------------'||CHR(10)||
                                     'Table: '||p_table_name||' was not found in DB!');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Table: '||p_table_name||' was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END tables;

PROCEDURE list_tables(p_owner IN VARCHAR2 DEFAULT NULL)
AS
  CURSOR dba_tables_cursor (par_owner DBA_TABLES.owner%TYPE) IS
      SELECT * FROM DBA_TABLES
      WHERE owner = par_owner
      ORDER BY table_name;
  v_count_rec     NUMBER;
  v_check_no      NUMBER;
  nn_cursor       INTEGER;
  ignore          INTEGER;
  v_owner         DBA_TABLES.owner%TYPE := UPPER(p_owner);
BEGIN
    IF v_owner IS NULL OR TRIM(v_owner) = '' THEN
        SELECT USER
        INTO v_owner
        FROM dual;
    END IF;
    DBMS_OUTPUT.PUT_LINE(CHR(10)||RPAD(v_owner||' Table List',35)||LPAD('Records',7)||CHR(10)
      ||'==========================================');
    FOR dba_tables_record IN dba_tables_cursor(v_owner) LOOP
      -- getting row counts from the table using dynamic sql.

      nn_cursor := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(nn_cursor, 'SELECT COUNT(*) FROM '||v_owner||'.'||dba_tables_record.table_name,DBMS_SQL.NATIVE);
      DBMS_SQL.DEFINE_COLUMN(nn_cursor,1,v_count_rec);
      ignore := DBMS_SQL.EXECUTE(nn_cursor);

      v_check_no := DBMS_SQL.FETCH_ROWS(nn_cursor);
      DBMS_SQL.COLUMN_VALUE(nn_cursor, 1, v_count_rec);

      -- close the cursor.
      DBMS_SQL.CLOSE_CURSOR(nn_cursor);

      DBMS_OUTPUT.PUT_LINE(RPAD(dba_tables_record.table_name,35)||LPAD(v_count_rec,7));
    END LOOP;



  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Table: was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END list_tables;


-- Procedure for tablespace_verify for @vts
PROCEDURE tablespace_verify (v_tablespace_name IN VARCHAR2)
AS
    v_wrong         EXCEPTION;
    v_count_rec     NUMBER(10);
    v_temp_string   VARCHAR2(1000);

    CURSOR dba_tablespaces_cursor (par_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
        SELECT * FROM DBA_TABLESPACES WHERE tablespace_name=UPPER(par_tablespace_name);
  CURSOR dba_data_files_cursor (par_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
      SELECT * FROM DBA_DATA_FILES WHERE tablespace_name=UPPER(par_tablespace_name);
  CURSOR dba_temp_files_cursor (par_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
      SELECT * FROM DBA_TEMP_FILES WHERE tablespace_name=UPPER(par_tablespace_name);
BEGIN
    SELECT COUNT(*) INTO v_count_rec FROM DBA_TABLESPACES 
    WHERE tablespace_name=v_tablespace_name;
    -- if tablespace is not in the user_tablespaces, then don't need to loop cursors.
    -- raise the excecption for no data in the db.
    IF v_count_rec > 0 THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10)||'Tablespace: '||v_tablespace_name);
      DBMS_OUTPUT.PUT_LINE(
           '------------------------------------------------------------- (DBA_TABLESPACES)');
      DBMS_OUTPUT.PUT_LINE(v_temp_string);
        -- Loop for user_tablespaces.
      FOR dba_tablespaces_record IN dba_tablespaces_cursor(v_tablespace_name) LOOP
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'Extent Management:     '
          ||dba_tablespaces_record.extent_management||CHR(10)||CHR(9)
          ||'Status:            '||dba_tablespaces_record.status||CHR(9));
        DBMS_OUTPUT.PUT_LINE(CHR(9)||'Allocation Type: '
          ||dba_tablespaces_record.allocation_type||CHR(10)||CHR(9)
          ||'Contents: '||dba_tablespaces_record.contents);
        DBMS_OUTPUT.PUT_LINE(CHR(9)||'Segment Space Management: '
          ||dba_tablespaces_record.segment_space_management||CHR(10));
        DBMS_OUTPUT.PUT_LINE(CHR(2)||'  '||
          '  + Storage Options + + + + + + + + + + + + + + + + + + + + + + + + + + + + ');
        IF dba_tablespaces_record.extent_management = 'LOCAL' THEN
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'Block Size: '
            ||ROUND(dba_tablespaces_record.block_size/1024,0)||' KB'||CHR(9)
            ||'Uniform Size: '||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB');
        ELSE
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'Block Size: '
            ||ROUND(dba_tablespaces_record.block_size/1024,0)||' KB'||CHR(9)
            ||'Minimum Extent: '||ROUND(dba_tablespaces_record.min_extlen/1024,0)||' KB');
        END IF;
        DBMS_OUTPUT.PUT_LINE(CHR(9)||'Initial: '
          ||ROUND(dba_tablespaces_record.initial_extent/1024,0)||' KB   '||CHR(9)
          ||'Next: '||ROUND(dba_tablespaces_record.next_extent/1024,0)||' KB');
        DBMS_OUTPUT.PUT_LINE(CHR(9)||'MINEXTENTS: '||dba_tablespaces_record.min_extents
          ||CHR(9)||CHR(9)||'MAXEXTENTS: '||dba_tablespaces_record.max_extents||CHR(9)
          ||CHR(9)||'PCTINCREASE: '||dba_tablespaces_record.pct_increase||' %'||CHR(10));

        IF dba_tablespaces_record.contents = 'TEMPORARY' THEN
          DBMS_OUTPUT.PUT_LINE(CHR(2)||'  '||
          '  + Data Files + + + + + + + + + + + + + + + + + + + + + + (DBA_TEMP_FILES)');
          FOR dba_temp_files_record IN dba_temp_files_cursor (v_tablespace_name) LOOP
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'Location: '||dba_temp_files_record.file_name);
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'File Size: '
              ||ROUND(dba_temp_files_record.bytes/1024/1024,0)|| ' MB / Max: '
              ||ROUND(dba_temp_files_record.maxbytes/1024/1024,0)||' MB');
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'Autoextend: '||dba_temp_files_record.autoextensible
              ||CHR(9)||CHR(9)||ROUND(dba_temp_files_record.increment_by/1024/1024,0)||' MB');
          END LOOP;
        ELSE
          DBMS_OUTPUT.PUT_LINE(CHR(2)||'  '||
          '  + Data Files + + + + + + + + + + + + + + + + + + + + + + + (DBA_DATA_FILES)');
          FOR dba_data_files_record IN dba_data_files_cursor (v_tablespace_name) LOOP
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'Location: '||dba_data_files_record.file_name);
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'File Size: '
              ||ROUND(dba_data_files_record.bytes/1024/1024,0)|| ' MB / Max: '
              ||ROUND(dba_data_files_record.maxbytes/1024/1024,0)||' MB');
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'Autoextend: '||dba_data_files_record.autoextensible
              ||CHR(9)||CHR(9)||ROUND(dba_data_files_record.increment_by/1024/1024,0)||' MB');
            DBMS_OUTPUT.PUT_LINE(CHR(9)||'Status: '
              ||dba_data_files_record.online_status||CHR(10));
          END LOOP;
        END IF;   -- End If for checking temporary tablespaces

        END LOOP;  -- End Loop for dba_users_cursor
    ELSE
        -- Raise the excpetion and give error message for no user found.
        RAISE v_wrong;
    END IF;  -- End if for checking users.
    EXCEPTION
    WHEN v_wrong THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Error -----------------------'||CHR(10)||
                           'USER: '||v_tablespace_name||' was not found in DB!');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'USER: '||v_tablespace_name||' was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END tablespace_verify;

-- list all tablespaces
PROCEDURE list_tablespace AS
  CURSOR dba_tablespaces_cursor IS
    SELECT tablespace_name, extent_management FROM DBA_TABLESPACES;
 
BEGIN
  -- Print the list of users
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'Tablespace List'||CHR(10)
      ||'===========================================');
    FOR dba_tablespaces_record IN dba_tablespaces_cursor LOOP
      DBMS_OUTPUT.PUT_LINE(RPAD(dba_tablespaces_record.tablespace_name, 30)
        ||LPAD('('||dba_tablespaces_record.extent_management,12)||')');
    END LOOP;
  -- Checking for the specific user

  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Tablespace was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;

-- user input for tablespaces
PROCEDURE tablespaces (p_tablespace_name IN VARCHAR2) AS
  v_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE := UPPER(p_tablespace_name);
  v_wrong     EXCEPTION;
  CURSOR all_dba_tablespaces_cursor IS
    SELECT * FROM DBA_TABLESPACES;
  CURSOR dba_tablespaces_cursor (par_tablespace_name DBA_TABLESPACES.tablespace_name%TYPE) IS
    SELECT * FROM DBA_TABLESPACES WHERE tablespace_name LIKE par_tablespace_name;
 
BEGIN
  -- Print report for All the tablespaces in DB
  IF v_tablespace_name = '*' THEN 
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'All the users in DB.'||CHR(10));
    FOR all_dba_tablespaces_record IN all_dba_tablespaces_cursor LOOP
      tablespace_verify(all_dba_tablespaces_record.tablespace_name);
    END LOOP;
  -- Checking for the specific tablespaces
  ELSE
    FOR dba_tablespaces_record IN dba_tablespaces_cursor(v_tablespace_name) LOOP
      tablespace_verify(dba_tablespaces_record.tablespace_name);
    END LOOP;
  END IF;

  version;

  EXCEPTION
    WHEN v_wrong THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Error -----------------------'||CHR(10)||
                           'Tablespace: '||v_tablespace_name||' was not found in DB!');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Tablespace: '||v_tablespace_name||' was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END tablespaces;

-- List all users for @vu
PROCEDURE list_user AS
  CURSOR all_dba_users_cursor IS
    SELECT username FROM DBA_USERS;
 
BEGIN
  -- Print the list of users
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'User List'||CHR(10)||'-----------------------');
    FOR all_dba_users_record IN all_dba_users_cursor LOOP
      DBMS_OUTPUT.PUT_LINE(all_dba_users_record.username);
    END LOOP;
  -- Checking for the specific user

  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'USER was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END list_user;

-- Private function for User verification for @vu
PROCEDURE user_verify (v_user IN VARCHAR2)
AS
    v_username      DBA_USERS.username%TYPE := UPPER(v_user);
    v_wrong         EXCEPTION;
    v_count_rec     NUMBER(10)  :=0;
    v_temp_string   LONG;
  v_check_unlimited_tbs  VARCHAR2(2)  := 'N';
  v_count_even_rec  NUMBER(10)  :=0;

    CURSOR dba_users_cursor (par_username DBA_USERS.username%TYPE) IS
    SELECT * FROM DBA_USERS WHERE USERNAME=UPPER(par_username);
    CURSOR dba_ts_quotas_cursor (par_username DBA_USERS.username%TYPE) IS
        SELECT * FROM DBA_TS_QUOTAS WHERE USERNAME=UPPER(par_username);
    CURSOR dba_role_privs_cursor (par_username DBA_USERS.username%TYPE) IS
      SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE=UPPER(par_username);
  CURSOR dba_sys_privs_cursor (par_username DBA_USERS.username%TYPE) IS
    SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE=UPPER(par_username);
  CURSOR dba_tab_privs_cursor (par_username DBA_USERS.username%TYPE) IS
    SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE=UPPER(par_username);
BEGIN
    SELECT COUNT(*) INTO v_count_rec FROM DBA_USERS WHERE username=v_username;
    -- if username is not in the dba_users, then don't need to loop cursors.
    -- raise the excecption for no data in the db.
    IF v_count_rec > 0 THEN
        v_temp_string := CHR(10)||'USER: '||v_username;

    -- Print user name with roles
        DBMS_OUTPUT.PUT_LINE(v_temp_string);
        -- Loop for dba_users.
      FOR dba_users_record IN dba_users_cursor(v_username) LOOP
          DBMS_OUTPUT.PUT_LINE(CHR(9)
          ||'General ------------------------------------------------------------ (DBA_USERS)');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  Account_Status:     '||dba_users_record.account_status);
        DBMS_OUTPUT.PUT_LINE(CHR(9)||'  Created:            '
          ||TO_CHAR(dba_users_record.created, 'MM/DD/YYYY')||CHR(9)||'    Expiry_Date: '
          ||RPAD(TO_CHAR(dba_users_record.expiry_date, 'MM/DD/YYYY'),11)); 
        -- RPAD to display exp date on the same line.
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  Default_Tablespace: '||RPAD(dba_users_record.default_tablespace,15)
          ||CHR(9)||'    Temporary_Tablespace: '||dba_users_record.temporary_tablespace);
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  Profile:            '||dba_users_record.profile||CHR(9));
          DBMS_OUTPUT.PUT_LINE(CHR(9));

        DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'System Privileges ---------------------------------------------- (DBA_SYS_PRIVS)');
        -- Count how many record in dba_sys_privs.
        SELECT COUNT(*) INTO v_count_rec FROM DBA_SYS_PRIVS WHERE GRANTEE=v_username;
        IF v_count_rec>0 THEN
          -- Print all the System Privileges
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'  '||RPAD('Privileges',34)||'Admin '||RPAD('Privileges',33)||'Admin');
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'  '||RPAD('-',33,'-')||' ----- '||RPAD('-',32,'-')||' -----');
          FOR dba_sys_privs_record IN dba_sys_privs_cursor(v_username) LOOP
            -- This is for print two privs in one line
            v_count_even_rec := v_count_even_rec + 1;
            IF v_count_even_rec = 1 THEN
              v_temp_string := CHR(9)||'  '||RPAD(dba_sys_privs_record.privilege, 36);
              IF dba_sys_privs_record.admin_option='YES' THEN
                v_temp_string := v_temp_string||'Y | ';
              ELSE
                v_temp_string := v_temp_string||'N | ';
              END IF;
            ELSE
              -- if v_count_even_rec = 2 Then append it v_temp_string and print line
              v_temp_string := v_temp_string || RPAD(dba_sys_privs_record.privilege, 36);
              IF dba_sys_privs_record.admin_option='YES' THEN
                v_temp_string := v_temp_string||'Y';
              ELSE
                v_temp_string := v_temp_string||'N';
              END IF;
              DBMS_OUTPUT.PUT_LINE(v_temp_string);

              -- Set the counter 0 for next round.
              v_count_even_rec := 0;
            END IF;

            -- CHecking Unlimited Tablespace Privilege
            IF dba_sys_privs_record.privilege='UNLIMITED TABLESPACE' THEN
              v_check_unlimited_tbs := 'Y';
            END IF; -- Checking for Unlimited Tablespace
          END LOOP; -- End Loop for dba_sys_privs_cursor
          
          -- Print if there is one record in buffer.
          IF v_count_even_rec = 1 THEN
            DBMS_OUTPUT.PUT_LINE(v_temp_string||CHR(10));
          ELSE -- only print spacer
            DBMS_OUTPUT.PUT_LINE(CHR(9));
          END IF; -- End IF for v_count_even_rec
        ELSE  -- v_rec_count for dba_sys_privs = 0
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'  No System Privileges has been granted!'||CHR(10));
        END IF; --End IF for record count.

        SELECT COUNT(*) INTO v_count_rec FROM DBA_TAB_PRIVS WHERE GRANTEE=v_username;
        -- Print all the Object Privileges
        DBMS_OUTPUT.PUT_LINE(CHR(9)
          ||'Object Privileges ---------------------------------------------- (DBA_TAB_PRIVS)');
        IF v_count_rec > 0 Then   -- Checking if the DBA_TAB_PRIVS has record
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  '
            ||RPAD('Grantor',12)||RPAD('Privileges',23)||RPAD('Owner.Table',37)||'Grant');
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  '
            ||RPAD('-',11,'-')||' '||RPAD('-',22,'-')||' '||RPAD('-',36,'-')||' -----');
          FOR dba_tab_privs_record IN dba_tab_privs_cursor(v_username) LOOP
            v_temp_string := CHR(9)||'  '||RPAD(dba_tab_privs_record.grantor,12)
            ||RPAD(dba_tab_privs_record.privilege,23)||RPAD(dba_tab_privs_record.owner
            ||'.'||dba_tab_privs_record.table_name, 40);
            IF dba_tab_privs_record.grantable = 'YES' THEN
              v_temp_string := v_temp_string || 'Y';
            ELSE
              v_temp_string := v_temp_string || 'N';
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_temp_string);
          END LOOP; -- End Loop for dba_tab_privs_cursor
          DBMS_OUTPUT.PUT_LINE(CHR(9));
        ELSE    -- If DBA_TAB_PRIVS don't have record
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'  No Object Privileges has been granted!'||CHR(10));
        END IF;   -- End if for DBA_TAB_PRIVS record count.

        -- Checking for roles that granted for this user.
        SELECT COUNT(*) INTO v_count_rec FROM DBA_ROLE_PRIVS WHERE grantee=v_username;
        -- Print all the Role Privileges
        DBMS_OUTPUT.PUT_LINE(CHR(9)
          ||'Role Privileges ----------------------------------------------- (DBA_ROLE_PRIVS)');
        IF v_count_rec > 0 Then   -- Checking if the DBA_TAB_PRIVS has record
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  '
            ||RPAD('Role',33)||RPAD('Admin',7)||RPAD('Default',7));
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  '
            ||RPAD('-',32,'-')||' '||RPAD('-',6,'-')||' '||RPAD('-',7,'-'));
          FOR dba_role_privs_record IN dba_role_privs_cursor(v_username) LOOP
            v_temp_string := CHR(9)||'  '||RPAD(dba_role_privs_record.granted_role,33)
            ||RPAD(dba_role_privs_record.admin_option,7)||RPAD(dba_role_privs_record.default_role,7);
            DBMS_OUTPUT.PUT_LINE(v_temp_string);
          END LOOP; -- End Loop for dba_tab_privs_cursor
          DBMS_OUTPUT.PUT_LINE(CHR(9));
        ELSE    -- If DBA_TAB_PRIVS don't have record
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'  No Role has been granted!'||CHR(10));
        END IF;   -- End if for DBA_TAB_PRIVS record count.

        -- Print heading for Qoutas. If Unlimited tbs, show the privilege.
        IF v_check_unlimited_tbs = 'N' THEN
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'Quotas --------------------------------------------------------- (DBA_TS_QUOTAS)');
        ELSE
          DBMS_OUTPUT.PUT_LINE(CHR(9)
            ||'Quotas (Unlimited Tablespace) ---------------------------------- (DBA_TS_QUOTAS)');
        END IF;
        -- Checking if user have quota information. If no, then skip printing.
        SELECT COUNT(*) INTO v_count_rec FROM DBA_TS_QUOTAS WHERE username=v_username;
        IF v_count_rec > 0 THEN
          -- loops for quotas inforamtion for one db user.
          FOR dba_ts_quotas_record IN dba_ts_quotas_cursor(dba_users_record.username) LOOP
            IF dba_ts_quotas_record.max_bytes = -1 THEN
              DBMS_OUTPUT.PUT_LINE(CHR(9)||'  '
                               ||RPAD(dba_ts_quotas_record.tablespace_name, 20)||
                                 LPAD(ROUND(dba_ts_quotas_record.bytes/1024/1024,1),6)||' MB / Unlimited Tablespace');
            ELSE
                DBMS_OUTPUT.PUT_LINE(CHR(9)||'  '
                               ||RPAD(dba_ts_quotas_record.tablespace_name, 20)||
                                 LPAD(ROUND(dba_ts_quotas_record.bytes/1024/1024,1),6)||' / '||
                                 ROUND(dba_ts_quotas_record.max_bytes/1024/1024,1)||' MB'||
                                 CHR(9)||'Used: '|| ROUND(dba_ts_quotas_record.bytes/dba_ts_quotas_record.max_bytes,0)||'%');
            END IF;
          END LOOP; -- End Loop for dba_ts_quotas_cursor
        ELSE
          DBMS_OUTPUT.PUT_LINE(CHR(9)||'  No Quotas has been assigned!'||CHR(9));
        END IF; -- End If for checking quotas.
        END LOOP;  -- End Loop for dba_users_cursor
    ELSE
        -- Raise the excpetion and give error message for no user found.
        RAISE v_wrong;
    END IF;  -- End if for checking users.
    EXCEPTION
    WHEN v_wrong THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Error -----------------------'||CHR(10)||
                           'USER: '||v_username||' was not found in DB!');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'USER: '||v_username||' was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END user_verify;

-- User verify for @vu
PROCEDURE users(p_user_name IN VARCHAR2) AS
  v_username      DBA_USERS.username%TYPE := UPPER(p_user_name);
  v_wrong       EXCEPTION;
  CURSOR all_dba_users_cursor IS
    SELECT * FROM DBA_USERS;
  CURSOR multi_dba_users_cursor (par_username DBA_USERS.username%TYPE) IS
    SELECT * FROM DBA_USERS WHERE username LIKE par_username;
  CURSOR dba_users_cursor IS  -- Cursor for Only created users
    SELECT * FROM DBA_USERS WHERE username NOT IN ('MGMT_VIEW', 'SYS', 'SYSTEM', 'DBSNMP'
      , 'SYSMAN', 'OUTLN', 'FLOWS_FILES', 'MDSYS', 'ORDSYS', 'EXFSYS', 'WMSYS'
      , 'APPQOSSYS', 'APEX_030200', 'OWBSYS_AUDIT', 'ORDDATA', 'CTXSYS', 'ANONYMOUS'
      , 'XDB', 'ORDPLUGINS', 'OWBSYS', 'SI_INFORMTN_SCHEMA', 'OLAPSYS', 'ORACLE_OCM'
      , 'XS$NULL', 'BI', 'PM', 'MDDATA', 'IX', 'SH', 'DIP', 'OE', 'APEX_PUBLIC_USER'
      , 'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR');
  CURSOR sys_dba_users_cursor IS  -- Cursor for All the users create and sys users.
    SELECT * FROM DBA_USERS WHERE username NOT IN ('MGMT_VIEW', 'DBSNMP', 'OUTLN'
      , 'FLOWS_FILES', 'MDSYS', 'ORDSYS', 'EXFSYS', 'WMSYS', 'APPQOSSYS', 'APEX_030200'
      , 'OWBSYS_AUDIT', 'ORDDATA', 'CTXSYS', 'ANONYMOUS', 'XDB', 'ORDPLUGINS', 'OWBSYS'
      , 'SI_INFORMTN_SCHEMA', 'OLAPSYS', 'ORACLE_OCM', 'XS$NULL', 'BI', 'PM', 'MDDATA'
      , 'IX', 'SH', 'DIP', 'OE', 'APEX_PUBLIC_USER', 'SPATIAL_CSW_ADMIN_USR'
      , 'SPATIAL_WFS_ADMIN_USR');
BEGIN
  -- Print report for All the users in DB
  IF v_username = '*' THEN 
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'All the users in DB. (No Sys or Apps User)'||CHR(10));
    FOR dba_users_record IN dba_users_cursor LOOP
      user_verify(dba_users_record.username);
    END LOOP;
  -- Checking for the specific user
  ELSIF v_username = '*ALL' THEN
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'All the users in DB. (Including Sys and Apps User'
      ||CHR(10));
    FOR all_dba_users_record IN all_dba_users_cursor LOOP
      user_verify(all_dba_users_record.username);
    END LOOP;
  ELSIF v_username = '*SYS' THEN
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'All the users in DB. (Including Sys)'
      ||CHR(10));
    FOR sys_dba_users_record IN sys_dba_users_cursor LOOP
    END LOOP;
  ELSE
    FOR multi_dba_users_record IN multi_dba_users_cursor(v_username) LOOP
      user_verify(multi_dba_users_record.username);
    END LOOP;
  END IF;

  version;

  EXCEPTION
    WHEN v_wrong THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Error -----------------------'||CHR(10)||
                           'USER: '||p_user_name||' was not found in DB!');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'Too many rows returned!');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(CHR(10)||'USER: '||p_user_name||' was not found in DB!');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(sqlerrm);
END users;

END boram;
/

CREATE PUBLIC SYNONYM v_script FOR sys.boram;
GRANT EXECUTE ON v_script TO dba;
GRANT EXECUTE ON v_script TO system WITH GRANT OPTION;
SET ECHO ON

