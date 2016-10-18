-- #4 Request supplies with best suppliers
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
DECLARE
    best_sup_id     NUMBER;
    best_sup_rel    NUMBER;
BEGIN
	FOR sup_unsat IN (
                    SELECT *
                    FROM SUPPLY_REQUEST
                    WHERE STATE = 'UNSATISFIED'
                    )
	LOOP
        -- select the best supplier for the product
		SELECT SUPS.SUPPLIERID INTO best_sup_id                
		FROM SUPPLIER_STOCK SUPS
		INNER JOIN SUPPLIER SUP
		ON SUP.SUPPLIERID = SUPS.SUPPLIERID		
		WHERE SUPS.INGRSTOCKID = sup_unsat.INGRSTOCKID
		AND RELIABILITY = (
                            SELECT MAX(RELIABILITY)
                            FROM SUPPLIER SUP
                            INNER JOIN SUPPLIER_STOCK SUPS
                            ON SUPS.SUPPLIERID = SUP.SUPPLIERID
                            WHERE SUPS.INGRSTOCKID = sup_unsat.INGRSTOCKID
                        )
        AND PRICE = (
                        SELECT MIN(PRICE)
                        FROM SUPPLIER_STOCK
                        WHERE INGRSTOCKID = sup_unsat.INGRSTOCKID
                        -- available for the supply date
                        AND DATEFRESHSUPPLY > sup_unsat.DATEREQUEST
                    );
        -- inc suppliers reliability
        SELECT RELIABILITY INTO best_sup_rel
        FROM SUPPLIER
        WHERE SUPPLIERID = best_sup_id;
        --
        UPDATE SUPPLIER SET RELIABILITY = 1 + best_sup_rel;             
        
	END LOOP;
	
    COMMIT;
END;
    
exec :n := (dbms_utility.get_time - :n)/100
exec dbms_output.put_line('Execution time '||:n||' sec')