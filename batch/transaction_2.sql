-- #2 Find cook that cooked highest num of recipes 
-- by given period and increase his salary
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
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
        ORDER BY COUNT(R.RECIPEID) DESC
    )                         
    SELECT EMPLOYEEID, 
            LASTNAME,
            FIRSTNAME,
            RECIPECOUNT,
            SALARY,
            TITLE
    FROM t1
    WHERE RECIPECOUNT >= 
        (
            SELECT MAX(RECIPECOUNT)
            FROM t1
        );
    COMMIT;
exec :n := (dbms_utility.get_time - :n)/100
exec dbms_output.put_line('Execution time '||:n||' sec')