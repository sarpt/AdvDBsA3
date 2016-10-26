-- #3 Check if the whole menu is available
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/

SET TRANSACTION NAME 'MENU_AVAIL';
    DECLARE
        tmp_weight_missing      NUMBER;  
        tmp                     NUMBER;      
    BEGIN	
        FOR rec IN (SELECT * FROM RECIPE)
        LOOP
            FOR ingr IN (SELECT * FROM INGREDIENT t1                                                        
                            WHERE t1.RECIPEID = rec.RECIPEID
                        )
            LOOP                
                SELECT ingr.WEIGHTRECP - WEIGHTAVAIL 
                INTO tmp_weight_missing
                FROM INGREDIENT_STOCK
                WHERE INGRSTOCKID = ingr.INGRSTOCKID;
                
                -- if not enough request supply
                IF tmp_weight_missing > 0 THEN
                    -- set current recipe as unavailable
                    UPDATE RECIPE
                    SET STATE = 'UNAVAILABLE'
                    WHERE RECIPEID = rec.RECIPEID;
                    
                    -- update stocks for missing ingredients
                    UPDATE INGREDIENT_STOCK
                    SET WEIGHTMISSING = WEIGHTMISSING + tmp_weight_missing
                    WHERE INGRSTOCKID = ingr.INGRSTOCKID;
                    
                    -- request a supply
                    SELECT MAX(REQUESTID) + 1 INTO tmp
                    FROM SUPPLY_REQUEST;
                    
                    INSERT INTO SUPPLY_REQUEST(REQUESTID, INGRSTOCKID, DATEREQUEST, STATE)
                    VALUES (tmp, ingr.INGRSTOCKID, (SELECT CURRENT_DATE FROM DUAL), 'UNSATISFIED');
                ELSE
                    UPDATE RECIPE
                    SET STATE = 'AVAILABLE'
                    WHERE RECIPEID = rec.RECIPEID;
                END IF;
            END LOOP;
        END LOOP;
		
		--dbms_output.put_line('Number of unavailable ingredients: '||ing_count||'');                    		
    END;
/
COMMIT;

BEGIN
  :n := (dbms_utility.get_time - :n)/100;
  dbms_output.put_line('Execution time '||:n||' sec');
END;
/