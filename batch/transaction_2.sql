-- #2 Calculate balance for given period of time

set serveroutput on
variable n number

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

exec :n := dbms_utility.get_time

SET TRANSACTION NAME 'CALCULATE_MONTHS_BALANCE';
DECLARE
  start_date DATE := '20/01/2018';
  end_date DATE := '20/10/2018';
  chef_money_spent NUMBER;
  supply_money_spent NUMBER;
  resource_money_income NUMBER;
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
  
  
  -- get income from resources
  SELECT SUM(TOTAL) INTO resource_money_income
  FROM RESOURCES
  WHERE DATERECEIVED <= end_date
  AND DATERECEIVED >= start_date;
  
  dbms_output.put_line('Money received: '||resource_money_income||'');
  
  dbms_output.put_line('Balance: '||resource_money_income - chef_money_spent - supply_money_spent||'');
END;
/
COMMIT;

BEGIN
  :n := (dbms_utility.get_time - :n)/100;
  dbms_output.put_line('Execution time '||:n||' sec');
END;
/