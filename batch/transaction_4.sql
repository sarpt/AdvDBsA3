-- #4 Request supplies with best suppliers
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
DECLARE
    total_sup_price DECIMAL;
    total_res       DECIMAL;
    best_sup_rel    NUMBER;    
BEGIN
    -- calc total supply price
    SELECT SUM(PRICE) INTO total_sup_price
    FROM 
    (
        -- selecting the best supplier
        SELECT SUPPLIERID, INGRSTOCKID, REQUESTID, PRICE
        FROM (
                -- all requests that are unsatisfied and can be satisfied
                SELECT ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE, sr.REQUESTID
                FROM supplier_stock sups
                INNER JOIN ingredient_stock ings
                ON sups.INGRSTOCKID = ings.INGRSTOCKID
                INNER JOIN supplier sup
                ON sup.SUPPLIERID = sups.SUPPLIERID
                INNER JOIN supply_request sr
                ON sr.INGRSTOCKID = sups.INGRSTOCKID
                WHERE sr.STATE = 'UNSATISFIED'
                AND ings.WEIGHTMISSING < sups.WEIGHTAVAIL      
                AND sr.DATEREQUEST < sups.DATEFRESHSUPPLY
                GROUP BY ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE, sr.REQUESTID
                ORDER BY ings.INGRSTOCKID, sup.RELIABILITY DESC, sups.PRICE ASC
            ) t1
        WHERE t1.RELIABILITY = (
                                SELECT MAX(RELIABILITY)
                                FROM
                                (
                                    SELECT ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE
                                    FROM supplier_stock sups
                                    INNER JOIN ingredient_stock ings
                                    ON sups.INGRSTOCKID = ings.INGRSTOCKID
                                    INNER JOIN supplier sup
                                    ON sup.SUPPLIERID = sups.SUPPLIERID
                                    INNER JOIN supply_request sr
                                    ON sr.INGRSTOCKID = sups.INGRSTOCKID
                                    WHERE sr.STATE = 'UNSATISFIED'
                                    AND ings.WEIGHTMISSING < sups.WEIGHTAVAIL      
                                    AND sr.DATEREQUEST < sups.DATEFRESHSUPPLY
                                    GROUP BY ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE
                                    ORDER BY ings.INGRSTOCKID, sup.RELIABILITY DESC, sups.PRICE ASC
                                ) t2
                                WHERE t1.INGRSTOCKID = t2.INGRSTOCKID
                            )
        GROUP BY t1.SUPPLIERID, t1.INGRSTOCKID, t1.REQUESTID, t1.PRICE
        ORDER BY t1.INGRSTOCKID ASC
    );
    -- satisfy the supply if there are sufficient resources
    SELECT SUM(TOTAL) INTO total_res
    FROM resources;
    
    IF total_sup_price < total_res THEN
        FOR sup_ingr IN 
        ( 
            SELECT SUPPLIERID, INGRSTOCKID, REQUESTID
            FROM (
                    SELECT ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE, sr.REQUESTID
                    FROM supplier_stock sups
                    INNER JOIN ingredient_stock ings
                    ON sups.INGRSTOCKID = ings.INGRSTOCKID
                    INNER JOIN supplier sup
                    ON sup.SUPPLIERID = sups.SUPPLIERID
                    INNER JOIN supply_request sr
                    ON sr.INGRSTOCKID = sups.INGRSTOCKID
                    WHERE sr.STATE = 'UNSATISFIED'
                    AND ings.WEIGHTMISSING < sups.WEIGHTAVAIL      
                    AND sr.DATEREQUEST < sups.DATEFRESHSUPPLY
                    GROUP BY ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE, sr.REQUESTID
                    ORDER BY ings.INGRSTOCKID, sup.RELIABILITY DESC, sups.PRICE ASC
                ) t1
            WHERE t1.RELIABILITY = (
                                    SELECT MAX(RELIABILITY)
                                    FROM
                                    (
                                        SELECT ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE
                                        FROM supplier_stock sups
                                        INNER JOIN ingredient_stock ings
                                        ON sups.INGRSTOCKID = ings.INGRSTOCKID
                                        INNER JOIN supplier sup
                                        ON sup.SUPPLIERID = sups.SUPPLIERID
                                        INNER JOIN supply_request sr
                                        ON sr.INGRSTOCKID = sups.INGRSTOCKID
                                        WHERE sr.STATE = 'UNSATISFIED'
                                        AND ings.WEIGHTMISSING < sups.WEIGHTAVAIL      
                                        AND sr.DATEREQUEST < sups.DATEFRESHSUPPLY
                                        GROUP BY ings.INGRSTOCKID, sup.SUPPLIERID, sup.RELIABILITY, sups.PRICE
                                        ORDER BY ings.INGRSTOCKID, sup.RELIABILITY DESC, sups.PRICE ASC
                                    ) t2
                                    WHERE t1.INGRSTOCKID = t2.INGRSTOCKID
                                )
            GROUP BY t1.SUPPLIERID, t1.INGRSTOCKID, t1.REQUESTID
            ORDER BY t1.INGRSTOCKID ASC
        )
        LOOP
            -- we made request so it is satisfied
            UPDATE supply_request
            SET STATE = 'SATISFIED'
            WHERE REQUESTID = sup_ingr.REQUESTID;    
            
            -- inc reliability of the supplier
            SELECT RELIABILITY INTO best_sup_rel
            FROM supplier sup
            WHERE sup.SUPPLIERID = sup_ingr.SUPPLIERID; 
            
            UPDATE supplier
            SET RELIABILITY = best_sup_rel + 1
            WHERE SUPPLIERID = sup_ingr.SUPPLIERID;
        END LOOP;
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END;
    
exec :n := (dbms_utility.get_time - :n)/100
exec dbms_output.put_line('Execution time '||:n||' sec')