<img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.netguru.com%2Fhs-fs%2Fhubfs%2FSnowflake%2520logo.jpg%3Fwidth%3D653%26name%3DSnowflake%2520logo.jpg&f=1&nofb=1" alt="Snowflake ETL" title="Snowflake ETL">

______________________________________________________________________
______________________________________________________________________
### Snowflake Task ETL Example
```
This is an example of a basic snowflake ETL task process.
This file shows a simple AWS to Snowflake ETL. 


A task can execute a single SQL statement or a call to a stored procedure. 
Tasks can be combined with table streams for continuous ELT workflows to process recently changed table rows. Streams ensure exactly once semantics for new or changed data in a table.

```
______________________________________________________________________
______________________________________________________________________
### Files
```
ddl.sql:
    Shows how to create a table in snowflake and define table values

snowflake_task_etl.sql:
    Shows how to create file format, drop tasks, and create tasks.
```
______________________________________________________________________
______________________________________________________________________
### Steps
```
1. Use DDL.sql to create database, schema, stage table, and main table
2. Use snowflake_task_etl.sql
    a. Create File format
    b. Run automation steps 1 copy to stage table
    c. Run automation steps 2 insert into main table
    d. Run automation steps 3 delete rows in stage table
    e. Run automation steps 4 alter tasks to resume

That's it. 
Note: Creating AWS to SF integration is not shown here. Step 1 shows
FROM @UTIL_DB.PUBLIC.user/USER_INFO/ which is the named external stage 
that references an external location. In Snowflake this can be Amazon S3, 
Google Cloud Storage, or Microsoft Azure.
More information on this can be found here: 
```
<a href="https://docs.snowflake.com/en/sql-reference/sql/copy-into-table.html" title="Snowflake Copy">Snowflake Copy</a>
______________________________________________________________________
______________________________________________________________________
### Input Data Example

| EMAIL    | BIRTH_YEAR | BIRTH_MONTH | BIRTH_DAY  | GENDER     |   ZIP_CODE | TRACKING_ID | VENDER_ID
|----------|:----------:|------------:|-----------:|-----------:|-----------:|------------:|------------:|
| abc@fake.com |   1963 |          01 |         15 |   male     |      60026 |   123456789 |       12abt |
| def@fake.com |   2004 |          12 |         23 | female     |      81126 |   223456789 |       72ahc |
| ghi@fake.com |   1990 |          09 |         04 | non-binary |  14216-123 |   323456789 |       62awj |

### Output Data Example
| EMAIL    | BIRTH_YEAR | BIRTH_MONTH | BIRTH_DAY  | GENDER     |   ZIP_CODE | TRACKING_ID | VENDER_ID   |  FILE_NAME | FILE_ROW_NUMBER
|----------|:----------:|------------:|-----------:|-----------:|-----------:|------------:|------------:|------------:|------------:|
| abc@fake.com |   1963 |          01 |         15 |   male     |      60026 |   123456789 |       12abt | USER_INFO/myfile.csv       |       1 |
| def@fake.com |   2004 |          12 |         23 | female     |      81126 |   223456789 |       72ahc |       USER_INFO/myfile.csv |       2 |
| ghi@fake.com |   1990 |          09 |         04 | non-binary |  14216-123 |   323456789 |       62awj |       USER_INFO/myfile.csv |       3 |

______________________________________________________________________
______________________________________________________________________