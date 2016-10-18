-- #3 Check if the whole menu is available
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
	--smth here
		
    COMMIT;
END;
exec :n := (dbms_utility.get_time - :n)/100
exec dbms_output.put_line('Execution time '||:n||' sec')