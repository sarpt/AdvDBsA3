-- active rule #6 (timed - scheduled job)
BEGIN
  dbms_scheduler.create_job(
    job_name => 'Monthly_resupply',
    job_type => 'PLSQL_BLOCK',
    job_action => '
                    DECLARE
                      total_outcome number;
                      total_res number;
                      supplier_price number;
                      elem_price number;
                      missing_weight number;
                      nrid number;

                    BEGIN
                      FOR elem IN (
                        SELECT INGRSTOCKID
                        FROM SUPPLY_REQUEST 
                        WHERE DATEREQUEST > SYSDATE - 30 
                        AND DATEREQUEST < SYSDATE 
                        AND STATE=''UNSATISFIED'')
                      LOOP
                        SELECT MIN(PRICE) INTO supplier_price FROM SUPPLIER_STOCK WHERE INGRSTOCKID=elem.INGRSTOCKID;
                        
                        SELECT SUM(TOTAL) INTO total_outcome
                        FROM resources res
                        WHERE UPPER(res.TYPE) = ''TRANSFER'';
                        
                        SELECT SUM(TOTAL) - total_outcome INTO total_res
                        FROM resources res        
                        WHERE UPPER(res.TYPE) IN (''PAYMENT'', ''INVESTMENT''); 
                        
                        SELECT WEIGHTMISSING INTO missing_weight FROM INGREDIENT_STOCK WHERE INGRSTOCKID=elem.INGRSTOCKID;
                        
                        IF (missing_weight * supplier_price <= total_res) THEN
                          UPDATE INGREDIENT_STOCK
                          SET WEIGHTAVAIL = WEIGHTAVAIL + WEIGHTMISSING,
                            WEIGHTMISSING = 0.0
                          WHERE INGRSTOCKID=elem.INGRSTOCKID;
                          
                          INSERT INTO resources VALUES ((SELECT MAX(RESOURCEID) + 1 FROM RESOURCES), SYSDATE, missing_weight * supplier_price,''TRANSFER'');
<<<<<<< HEAD

                          UPDATE SUPPLY_REQUEST SET STATE = ''SATISFIED'' WHERE REQUESTID=elem.REQUESTID;
=======
>>>>>>> upstream/master
                          
                        END IF;
                      
                      END LOOP;
<<<<<<< HEAD
                    n := (dbms_utility.get_time - n)/100;
                    DBMS_OUTPUT.PUT_LINE(''Execution time ''||n||'' sec'');
                    END;
=======
                    END;
                    /
>>>>>>> upstream/master
                  ',
    start_date => systimestamp,
    repeat_interval => 'FREQ=MONTHLY;INTERVAL=1;BYHOUR=0;BYMINUTE=0;',
    enabled => TRUE);
		    
END;
/