echo off

set _current=%CD%

set /p _dbname=<dbname.txt

set /p _username=<username.txt

cd ..\02_data
set _data=%CD%

cd %_current%

echo exit | cd /d C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\01_POSITION.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\02_EMPLOYEE.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\03_SCHEDULE.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\04_RECIPE.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\05_RECIPE_DUTY.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\06_INGREDIENT_STOCK.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\07_SUPPLIER.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\08_SUPPLIER_STOCK.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\09_SUPPLY_REQUEST.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\10_INGREDIENT.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\11_RESOURCES.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\12_COOK_LOG.sql"

echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_data%\13_preparatory_data_manipulations.sql"

cd /d %_current%


