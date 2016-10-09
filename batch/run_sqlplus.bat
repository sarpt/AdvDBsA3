echo off
C:
cd C:\oracle\product\11.2.0\dbhome_1\BIN
sqlplus.exe -S rsol/rsol@orarsol @D:\STUDENT\WROCLAW\Semestr_1\Advanced_Databases\batch\script.ddl
pause