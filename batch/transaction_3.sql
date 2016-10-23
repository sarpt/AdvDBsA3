-- #3 Check if the whole menu is available
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

SET TRANSACTION NAME 'MENU_AVAIL';
    DECLARE
        ing_count NUMBER := 0;
    BEGIN	
        SELECT COUNT(*) INTO ing_count
        FROM INGREDIENT_STOCK IGS
        INNER JOIN INGREDIENT IG
        ON IGS.INGRSTOCKID = IG.INGRSTOCKID
        WHERE IG.RECIPEID IN (SELECT RECIPEID FROM RECIPE)
        AND IG.WEIGHTRECP > IGS.WEIGHTAVAIL;
            
        IF ing_count > 0 THEN
            -- set recipe as unavailable
            UPDATE RECIPE SET STATE = 'UNAVAILABLE'
            WHERE RECIPEID = recipe.RECIPEID;						
        ELSE
            -- set recipe as available
            UPDATE RECIPE SET STATE = 'AVAILABLE'
            WHERE RECIPEID = recipe.RECIPEID;
        END IF;						
    END;
/
COMMIT;

BEGIN
  :n := (dbms_utility.get_time - :n)/100;
  dbms_output.put_line('Execution time '||:n||' sec');
END;
/