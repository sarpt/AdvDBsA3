echo REST>username.txt

set _current=%CD%

set /p _dbname=<dbname.txt
set /p _username=<username.txt

cd ..\transactions
set _transactions=%CD%

cd ..\transactions_logs
set _transaction_logs=%CD%

cd %_current%

for /l %%x in (1, 1, 5) do (
echo normal number %%x >> "%_transaction_logs%\transaction_1_log.txt"
echo normal number %%x >> "%_transaction_logs%\transaction_2_log.txt"
echo normal number %%x >> "%_transaction_logs%\transaction_3_log.txt"
echo normal number %%x >> "%_transaction_logs%\transaction_4_log.txt"
echo normal number %%x >> "%_transaction_logs%\transaction_5_log.txt"
echo normal number %%x >> "%_transaction_logs%\transaction_6_log.txt"

call 01_schema.bat
call 02_data.bat
call 04_active_rules.bat

echo exit | cd /d C:\oracle\product\11.2.0\dbhome_1\BIN
echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_transactions%\transaction_1.sql">>"%_transaction_logs%\transaction_1_log.txt"
echo exit | sqlplus.exe -S %_username%/1@%_dbname% "@%_transactions%\transaction_3.sql">>"%_transaction_logs%\transaction_3_log.txt"
echo exit | sqlplus.exe -S %_username%/1@%_dbname%  "@%_transactions%\transaction_4.sql">>"%_transaction_logs%\transaction_4_log.txt"
echo exit | sqlplus.exe -S %_username%/1@%_dbname%  "@%_transactions%\transaction_2.sql">>"%_transaction_logs%\transaction_2_log.txt"
echo exit | sqlplus.exe -S %_username%/1@%_dbname%  "@%_transactions%\transaction_5.sql">>"%_transaction_logs%\transaction_5_log.txt"
echo exit | sqlplus.exe -S %_username%/1@%_dbname%  "@%_transactions%\transaction_6.sql">>"%_transaction_logs%\transaction_6_log.txt"

cd /d %_current%

)

