-- #6 Remove worst Chef:	
set serveroutput on
variable n number

ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
COMMIT;

exec :n := dbms_utility.get_time
SET TRANSACTION NAME 'REM_CHEF';
    DECLARE        
        chef_id NUMBER;
    BEGIN
        -- define worst chef
        WITH t1 AS
        (
            SELECT E.EMPLOYEEID, 
                   E.FIRSTNAME, 
                   E.LASTNAME,
                   P.SALARY,
                   P.TITLE,
                   COUNT(CL.RECIPEID) AS RECIPECOUNT 
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
            GROUP BY E.EMPLOYEEID, E.FIRSTNAME, E.LASTNAME, P.SALARY, P.TITLE
            ORDER BY COUNT(R.RECIPEID) ASC
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

        UPDATE RECIPE
        SET STATE = 'UNAVAILABLE'
        WHERE RECIPEID IN 
        (
            SELECT rec.RECIPEID
            FROM RECIPE rec
            INNER JOIN RECIPE_DUTY rd
            ON rec.RECIPEID = rd.RECIPEID
            INNER JOIN EMPLOYEE emp        
            ON rd.EMPLOYEEID = emp.EMPLOYEEID
            WHERE emp.EMPLOYEEID = chef_id
        );
        /*
        DELETE FROM RECIPE_DUTY
        WHERE EMPLOYEEID = chef_id;       
        
        DELETE FROM SCHEDULE
        WHERE EMPLOYEEID = chef_id;
        
        DELETE FROM EMPLOYEE
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