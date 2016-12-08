echo off

set _current=%CD%

set /p _dbname=<dbname.txt

set /p _username=<username.txt

cd ..\04_active_rules
set _arules=%CD%

cd %_current%

echo exit | cd /d C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_arules%\00_constraints.sql"
echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_arules%\01_normal_triggers.sql"
REM echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_arules%\02_scheduled_jobs.sql"

cd /d %_current%
