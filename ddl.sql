USE WAREHOUSE LOAD_WH;
Create DATABASE USER_DATA;
Create Schema USER_DATA.REGISTERED_USER;


--CREATE STAGE TABLE
CREATE OR REPLACE TABLE USER_DATA.STAGE.USER_INFO(
      EMAIL              VARCHAR(300)
    , BIRTH_YEAR         NUMBER(4,0)
    , BIRTH_MONTH        NUMBER(2,0)
    , BIRTH_DAY          NUMBER(2,0)
    , GENDER             VARCHAR(25)
    , ZIP_CODE           VARCHAR(10)
    , TRACKING_ID        NUMBER(38,0)
    , VENDER_ID          VARCHAR(10)
    , FILE_NAME          VARCHAR(200)
    , FILE_ROW_NUMBER    VARCHAR()
);

--CREATE MAIN TABLE
CREATE OR REPLACE TABLE USER_DATA.REGISTERED_USER.USER_INFO(
      EMAIL              VARCHAR(300)
    , BIRTH_YEAR         NUMBER(4,0)
    , BIRTH_MONTH        NUMBER(2,0)
    , BIRTH_DAY          NUMBER(2,0)
    , GENDER             VARCHAR(25)
    , ZIP_CODE           VARCHAR(10)
    , TRACKING_ID        NUMBER(38,0)
    , VENDER_ID          VARCHAR(10)
    , FILE_NAME          VARCHAR(200)
    , FILE_ROW_NUMBER    VARCHAR()
);




