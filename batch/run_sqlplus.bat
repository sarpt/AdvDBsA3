echo off
C:
cd C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S SYSTEM/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\create_user.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\00_create_schema.ddl
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\01_sequences.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\02_POSITION.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\03_EMPLOYEE.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\04_SCHEDULE.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\05_RECIPE.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\06_RECIPE_2.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\07_RECIPE_DUTY_1.sql
pause
echo exit | sqlplus.exe -S REST/1@ORARSOL @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\08_RECIPE_DUTY_2.sql
pause