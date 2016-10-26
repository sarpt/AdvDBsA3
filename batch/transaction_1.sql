-- #1 RECORD DISH ORDER
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

-- Measuring time
set serveroutput on
var n number
exec :n := dbms_utility.get_time

SET TRANSACTION NAME 'REC_DISH';
    DECLARE
        recipe_id		NUMBER := 297;
        amount			NUMBER := 10;
        recipe_hour		NUMBER := 13;
        chefs_avail		NUMBER;
        missing_buf		DECIMAL;
        recipe_price	DECIMAL;
        --
        tmp_req_id      NUMBER;
        tmp_weight      NUMBER;
        tmp             NUMBER;
    BEGIN
        FOR ingr_row IN (
                        SELECT *
                        FROM INGREDIENT INGR
                        WHERE INGR.RECIPEID = recipe_id
                        )					
        LOOP
            -- compare with stock
            UPDATE INGREDIENT_STOCK
            SET WEIGHTMISSING = (ingr_row.WEIGHTRECP * amount - WEIGHTAVAIL)
            WHERE INGRSTOCKID = ingr_row.INGRSTOCKID
            AND WEIGHTAVAIL < ingr_row.WEIGHTRECP * amount;
            
            -- request the supply if we have WEIGHTMISSING > 0
            SELECT (WEIGHTAVAIL - ingr_row.WEIGHTRECP * amount) INTO tmp_weight
            FROM INGREDIENT_STOCK igs
            WHERE igs.INGRSTOCKID = ingr_row.INGRSTOCKID;
            
            IF tmp_weight < 0 THEN            
                SELECT MAX(REQUESTID) + 1 INTO tmp_req_id 
                FROM SUPPLY_REQUEST;
                
                INSERT INTO SUPPLY_REQUEST(REQUESTID, INGRSTOCKID, STATE, DATEREQUEST)
                VALUES (tmp_req_id, ingr_row.INGRSTOCKID, 'UNSATISFIED', (SELECT CURRENT_DATE FROM DUAL));
            END IF;
        END LOOP;
        
        -- is there any chef available
        SELECT COUNT(*) INTO chefs_avail
        FROM EMPLOYEE E
        INNER JOIN POSITION P
        ON E.POSITIONID = P.POSITIONID
        INNER JOIN SCHEDULE S
        ON S.EMPLOYEEID = E.EMPLOYEEID
        WHERE DATECONTRACTFIN >= (SELECT CURRENT_DATE FROM DUAL)
        AND UPPER(P.TITLE) LIKE '%COOK%'
        AND S.DAYSTART < recipe_hour
        AND S.DAYFIN > recipe_hour;
		
		dbms_output.put_line('Number of chefs available: '||chefs_avail||'');
        
        -- check if we have enough in stocks
        SELECT MAX(WEIGHTMISSING) INTO missing_buf
        FROM INGREDIENT_STOCK
        WHERE INGRSTOCKID IN (
            SELECT INGRSTOCKID
            FROM INGREDIENT
            WHERE RECIPEID = recipe_id
        );
		
		dbms_output.put_line('Maximum missing weight of ingredient (all should be available so max=0): '||missing_buf||'');
        
        IF missing_buf = 0.0 AND chefs_avail > 0 THEN		
            -- record payment
            -- get price                        
            SELECT PRICE INTO recipe_price
            FROM RECIPE
            WHERE RECIPEID = recipe_id;
            
            -- get maxid
            SELECT MAX(RESOURCEID) + 1 INTO tmp
            FROM RESOURCES;
            
            INSERT INTO RESOURCES (RESOURCEID, TOTAL, TYPE, DATERECEIVED)
            VALUES (tmp, recipe_price * amount, 'PAYMENT', (SELECT CURRENT_DATE FROM DUAL));
            
            -- get maxid
            SELECT MAX(COOKLOGID) + 1 INTO tmp
            FROM COOK_LOG;
             
            INSERT INTO COOK_LOG (COOKLOGID, DATESOLD, AMOUNT, RECIPEID)
            VALUES (tmp, (SELECT CURRENT_DATE FROM DUAL), amount, recipe_id);
        END IF;
    END;
/
COMMIT;

BEGIN
  :n := (dbms_utility.get_time - :n)/100;
  DBMS_OUTPUT.PUT_LINE('Execution time '||:n||' sec');
END;
/