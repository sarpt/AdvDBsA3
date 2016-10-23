-- #5 Hire chef
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

SET TRANSACTION NAME 'HIRE_CHEF';
    DECLARE    
        recipe_id           NUMBER := 146;
        -- employee data
        firstname           VARCHAR2(20) := 'Jan';
        lastname            VARCHAR2(20) := 'Kowalski';
        date_contract_fin   DATE := '19/10/2020';
        chef_pos_id         NUMBER := 2;    
        --
        total_sal_pay       DECIMAL;
        total_res           DECIMAL;
        new_salary          DECIMAL;
        tmp                 NUMBER;
        tmp_s               NUMBER;
    BEGIN
        SELECT SALARY INTO new_salary
        FROM POSITION
        WHERE POSITIONID = chef_pos_id;
        
        -- calculate total salaries to pay
        SELECT SUM(TOTALPOSSAL) + new_salary INTO total_sal_pay
        FROM
        (
            SELECT pos.POSITIONID, SUM(SALARY) AS TOTALPOSSAL
            FROM POSITION pos
            INNER JOIN EMPLOYEE emp
            ON emp.POSITIONID = pos.POSITIONID
            WHERE emp.EMPLOYEEID IN (
                                        SELECT EMPLOYEEID 
                                        FROM EMPLOYEE
                                        WHERE DATECONTRACTFIN > '20/10/2016'
                                    )
            GROUP BY pos.POSITIONID, SALARY    
            ORDER BY pos.POSITIONID
        );
        
        -- calculate all the resources
        SELECT SUM(TOTAL) INTO total_res
        FROM RESOURCES
        WHERE DATERECEIVED > '20/10/2016';
        
        IF total_res > total_sal_pay THEN
            -- hire the chef        
            SELECT MAX(EMPLOYEEID) + 1 INTO tmp FROM EMPLOYEE;        
            INSERT INTO EMPLOYEE
            VALUES (tmp, firstname, lastname, date_contract_fin, chef_pos_id);
            
            INSERT INTO RECIPE_DUTY VALUES(tmp, recipe_id, 'Bake a cake');
            
            SELECT MAX(SCHEDULEID) + 1 INTO tmp_s FROM SCHEDULE;
            INSERT INTO SCHEDULE
            VALUES (tmp_s, 9, 17, '20/10/2016', tmp);
        END IF;
    END;
/
COMMIT; 

BEGIN   
  :n := (dbms_utility.get_time - :n)/100;
  dbms_output.put_line('Execution time '||:n||' sec');
END;
/