echo off

set _current=%CD%

set /p _dbname=<dbname.txt

set /p _username=<username.txt

cd ..\03_optimization
set _optim=%CD%

cd %_current%

echo exit | cd /d C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_optim%\01_index_optimization_#1.sql"

cd /d %_current%
