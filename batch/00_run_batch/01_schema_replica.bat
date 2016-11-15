echo off
C:
cd C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S SYSTEM/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\01_schema\01_create_user_replica.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\01_schema\02_create_schema_replica.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\01_schema\03_erwin_constraints_replica.sql

echo exit | sqlplus.exe -S REST_REPLICA/1@ORASLOW @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\01_schema\04_erwin_triggers.sql