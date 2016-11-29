echo off

set _current=%CD%

set /p _dbname=<dbname.txt

set /p _username=<username.txt

cd ..\01_schema
set _schema=%CD%

cd %_current%

echo exit | cd /d C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S SYSTEM/1@%_dbname% "@%_schema%\01_create_user_%_username%.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_schema%\02_create_schema_partitions.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_schema%\03_erwin_constraints_partitions.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_schema%\04_erwin_triggers.sql"

cd /d %_current%