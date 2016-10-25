-- #2 Find cook that cooked highest num of recipes 
-- by given period and increase his salary
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

set serveroutput on
variable n number

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
/
exec :n := dbms_utility.get_time;

SET TRANSACTION NAME 'CALCULATE_MONTHS_BALANCE';
DECLARE
  start_date DATE := '20/01/2015';
  end_date DATE := '20/01/2018';
  chef_money_spent NUMBER;
  supply_money_spent NUMBER;
  resource_money_income NUMBER;
  price NUMBER;
BEGIN

  -- calculate money spent on chefs
  SELECT SUM(SALARY) * months_between(end_date, start_date) INTO chef_money_spent
  FROM (
    SELECT * 
    FROM EMPLOYEE E
    INNER JOIN POSITION P
    ON E.POSITIONID = P.POSITIONID
    WHERE DATECONTRACTFIN <= end_date
    AND DATECONTRACTFIN >= start_date
    AND UPPER(P.TITLE) LIKE '%COOK%'
  );
  
  dbms_output.put_line('Money spent on chefs: '||chef_money_spent||'');
  -- calculate money spent on supplies
  
  SELECT SUM(PRICE) INTO supply_money_spent
  FROM SUPPLY_REQUEST X  
  INNER JOIN SUPPLIER_STOCK V
  ON X.INGRSTOCKID = V.INGRSTOCKID
  WHERE V.PRICE = (            
                    SELECT MIN(PRICE)
                    FROM SUPPLIER S2
                    INNER JOIN SUPPLIER_STOCK T2
                    ON S2.SUPPLIERID = T2.SUPPLIERID
                    WHERE S2.RELIABILITY = (
                                            SELECT MAX(S1.RELIABILITY)
                                            FROM SUPPLIER_STOCK T1
                                            INNER JOIN SUPPLIER S1
                                            ON T1.SUPPLIERID = S1.SUPPLIERID
                                            WHERE T1.INGRSTOCKID = T2.INGRSTOCKID
                                            )
                    AND T2.INGRSTOCKID = T3.INGRSTOCKID
                    )
  )
  AND X.STATE = 'SATISFIED'
  AND X.DATEREQUEST <= end_date
  AND X.DATEREQUEST >= start_date;
  
  dbms_output.put_line('Money spent on resources: '||supply_money_spent||'');
  
  -- get income from resources
  SELECT SUM(TOTAL) INTO resource_money_income
  FROM RESOURCES
  WHERE DATERECEIVED <= end_date
  AND DATERECEIVED >= start_date;
  
  dbms_output.put_line('Money received: '||resource_money_income||'');
  
  --dbms_output.put_line('Balance: '||resource_money_income - chef_money_spent||'');
END;
/
COMMIT;

BEGIN
  :n := (dbms_utility.get_time - :n)/100;
  dbms_output.put_line('Execution time '||:n||' sec');
END;
/