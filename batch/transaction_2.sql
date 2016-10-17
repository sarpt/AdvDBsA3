-- #2 Find cook that cooked highest num of recipes 
-- by given period and increase his salary
set serveroutput on
variable n number
exec :n := dbms_utility.get_time
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
DECLARE
    period_start DATE := '10/11/2016';
    period_end DATE := '10/12/2016';
BEGIN    
     ----- increase salary                     
    
        SELECT EMPLOYEEID, 
                LASTNAME,
                FIRSTNAME,
                RECIPECOUNT,
                SALARY,
                TITLE
        FROM 
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
        WHERE RECIPECOUNT >= 
            (
                SELECT MAX(RECIPECOUNT)
                FROM 
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
            );
    COMMIT;
END;
exec :n := (dbms_utility.get_time - :n)/100
exec dbms_output.put_line('Execution time '||:n||' sec')