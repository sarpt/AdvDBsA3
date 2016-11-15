echo off
C:
cd C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\01_POSITION.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\02_EMPLOYEE.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\03_SCHEDULE.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\04_RECIPE.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\05_RECIPE_DUTY.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\06_INGREDIENT_STOCK.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\07_SUPPLIER.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\08_SUPPLIER_STOCK.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\09_SUPPLY_REQUEST.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\10_INGREDIENT.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\11_RESOURCES.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\12_COOK_LOG.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_data\13_preparatory_data_manipulations.sql