-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
--                                     Automation CODE
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

------------------------------------------------------------------------
-- Drop Task Procedure 
-- Use iff you are dropping Tasks
------------------------------------------------------------------------
-- Check if task name exists
show tasks LIKE 'USER_INFO%';

-- Step 1
-- SUSPEND all tasks before dropping.
ALTER TASK USER_DATA.PUBLIC.USER_INFO_1_load_stage SUSPEND;
ALTER TASK USER_DATA.PUBLIC.USER_INFO_2_load_attribution SUSPEND;
ALTER TASK USER_DATA.PUBLIC.USER_INFO_3_delete_stage_data SUSPEND;

-- Step 2
--Drop Task
DROP TASK USER_DATA.PUBLIC.USER_INFO_1_load_stage;
DROP TASK USER_DATA.PUBLIC.USER_INFO_2_load_attribution;
DROP TASK USER_DATA.PUBLIC.USER_INFO_3_delete_stage_data;

------------------------------------------------------------------------
--                         Prep Steps 
------------------------------------------------------------------------
-- Create File Format
CREATE OR REPLACE FILE FORMAT USER_DATA.PUBLIC.USER_INFO 
    COMPRESSION = 'GZIP' 
    FIELD_DELIMITER = '\t' 
    RECORD_DELIMITER = '\n' 
    SKIP_HEADER = 1 
    FIELD_OPTIONALLY_ENCLOSED_BY = '\042' 
    TRIM_SPACE = FALSE 
    ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE 
    ESCAPE = 'NONE' 
    ESCAPE_UNENCLOSED_FIELD = '\134' 
    DATE_FORMAT = 'AUTO' 
    TIMESTAMP_FORMAT = 'AUTO' 
    NULL_IF = ('\\N')
;

-- Create AWS Connection: This examples uses
-- @UTIL_DB.PUBLIC.user/USER_INFO/
-- This example assumes you have already made the Snowflake integration


------------------------------------------------------------------------
--              Automation CODE: Insert New Values
------------------------------------------------------------------------
------------------------------------------------------------------------
--                           Step 1 
-- Loads latest data from S3 into SF stage schema & schedules task time
------------------------------------------------------------------------
CREATE OR REPLACE USER_DATA.PUBLIC.USER_INFO_1_load_stage
WAREHOUSE = LOAD_WH

-- Run everyday at 11:30 am EST
SCHEDULE = 'USING CRON 30 11 * * * America/New_York'

AS 
COPY INTO  USER_DATA.STAGE.USER_INFO
  FROM (SELECT 
               $1  ,$2  ,$3  ,$4  ,$5  ,$6  ,$7  ,$8 
        , metadata$filename
        , metadata$file_row_number
        
       FROM @UTIL_DB.PUBLIC.user/USER_INFO/)
FILE_FORMAT = 'USER_DATA.PUBLIC.USER_INFO'  
;


------------------------------------------------------------------------
--                              Step 2 
-- Copy data from stage table into main schema.
-- Data Transformation and Load: In this case there is no addition Transformation
------------------------------------------------------------------------
CREATE OR REPLACE TASK USER_DATA.PUBLIC.USER_INFO_2_load_attribution
WAREHOUSE = LOAD_WH

AFTER USER_DATA.PUBLIC.USER_INFO_1_load_stage

AS 
INSERT INTO USER_DATA.REGISTERED_USER.USER_INFO
SELECT 
      EMAIL
    , BIRTH_YEAR
    , BIRTH_MONTH
    , BIRTH_DAY
    , GENDER
    , ZIP_CODE
    , TRACKING_ID
    , VENDER_ID
    , FILE_NAME
    , FILE_ROW_NUMBER

FROM USER_DATA.STAGE.USER_INFO
;


------------------------------------------------------------------------
--                             Step 3 
-- Delete data from the stage
------------------------------------------------------------------------
CREATE OR REPLACE TASK USER_DATA.PUBLIC.USER_INFO_3_delete_stage_data
WAREHOUSE = LOAD_WH

AFTER USER_DATA.PUBLIC.USER_INFO_2_load_attribution

AS 
DELETE
FROM USER_DATA.STAGE.USER_INFO
;


------------------------------------------------------------------------
--                             Step 4
-- Resume Task: Preps Tasks to run
------------------------------------------------------------------------
ALTER TASK USER_DATA.PUBLIC.USER_INFO_3_delete_stage_data RESUME;
ALTER TASK USER_DATA.PUBLIC.USER_INFO_2_load_attribution RESUME;
ALTER TASK USER_DATA.PUBLIC.USER_INFO_1_load_stage RESUME;



