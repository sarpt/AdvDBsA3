echo off
C:
cd C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S SYSTEM/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\create_user.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\00_create_schema.ddl

REM sequences could be skipped
echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\sequences.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\01_POSITION.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_EMPLOYEE.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\03_SCHEDULE.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\04_RECIPE.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\05_RECIPE_DUTY.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\06_INGREDIENT_STOCK.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\07_SUPPLIER.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\08_SUPPLIER_STOCK.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\09_SUPPLY_REQUEST.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\10_INGREDIENT.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\11_RESOURCES.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\12_COOK_LOG.sql

echo exit | sqlplus.exe -S REST/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\preparatory_data_manipulations.sql
pause