-- #6 Remove worst Chef
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/

SET TRANSACTION NAME 'REM_CHEF';
    DECLARE        
        chef_id NUMBER;
        num_of_chefs_for_recipee NUMBER;
    BEGIN
        -- define worst chef
        WITH t1 AS
        (
            SELECT E.EMPLOYEEID, 
                   E.FIRSTNAME, 
                   E.LASTNAME,
                   P.SALARY,
                   P.TITLE,
                   SUM(CL.AMOUNT) AS RECIPECOUNT 
            FROM COOK_LOG CL
            INNER JOIN RECIPE R
            ON R.RECIPEID = CL.RECIPEID
            INNER JOIN RECIPE_DUTY RD
            ON RD.RECIPEID = CL.RECIPEID
            INNER JOIN EMPLOYEE E
            ON RD.EMPLOYEEID = E.EMPLOYEEID
            INNER JOIN POSITION P
            ON P.POSITIONID = E.POSITIONID
            WHERE UPPER(P.TITLE) LIKE '%COOK%'
            AND CL.DATESOLD BETWEEN '10/11/2016' AND '10/12/2016' 
            GROUP BY E.EMPLOYEEID, E.FIRSTNAME, E.LASTNAME, P.SALARY, P.TITLE,CL.AMOUNT
            ORDER BY SUM(CL.AMOUNT) ASC
        )                         
        SELECT EMPLOYEEID INTO chef_id 
                /*LASTNAME,
                FIRSTNAME,
                RECIPECOUNT,
                SALARY,
                TITLE*/
        FROM t1
        WHERE RECIPECOUNT <= 
            (
                SELECT MIN(RECIPECOUNT)
                FROM t1
            )
        AND ROWNUM = 1;
				
		dbms_output.put_line('Worst chef id: '||chef_id);
                
        UPDATE RECIPE
        SET STATE = 'UNAVAILABLE'
        WHERE RECIPEID IN 
                          (
                          SELECT rec3.RECIPEID
                          FROM RECIPE rec3
                          INNER JOIN RECIPE_DUTY rd3
                          ON rec3.RECIPEID = rd3.RECIPEID
                          WHERE ( 
                                  SELECT COUNT(*)
                                  FROM RECIPE rec2
                                  INNER JOIN RECIPE_DUTY rd2
                                  ON rec2.RECIPEID = rd2.RECIPEID
                                  INNER JOIN EMPLOYEE emp2     
                                  ON rd2.EMPLOYEEID = emp2.EMPLOYEEID
                                  WHERE emp2.EMPLOYEEID != chef_id
                                  AND rec2.RECIPEID = rec3.RECIPEID
                          ) = 0
                          AND rd3.EMPLOYEEID = chef_id
        );
        
        /*
        DELETE FROM EMPLOYEE
        WHERE EMPLOYEEID = chef_id;
        
        DELETE FROM RECIPE_DUTY
        WHERE EMPLOYEEID = chef_id;       
        
        DELETE FROM SCHEDULE
        WHERE EMPLOYEEID = chef_id;
        */    
    END;
/
COMMIT;

BEGIN   
  :n := (dbms_utility.get_time - :n)/100;
  dbms_output.put_line('Execution time '||:n||' sec');
END;
/