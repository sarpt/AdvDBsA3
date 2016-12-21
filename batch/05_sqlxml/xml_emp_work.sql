SELECT XMLElement("employee", 
            XMLAttributes(emp.EMPLOYEEID AS "empid",
                        emp.LASTNAME AS "lastname",
                        pos.TITLE AS "title",
                        pos.SALARY AS "salary"
            ),             
            XMLAgg(XMLElement("recipe",
                        XMLAttributes(rd.RECIPEID AS "recipeid",
                            ckl.DATESOLD AS "date",
                            ckl.AMOUNT AS "amount"
                        )                        
                    )
            )
        )
FROM employee emp 
INNER JOIN position pos
ON emp.POSITIONID = pos.POSITIONID	 
INNER JOIN recipe_duty rd
ON emp.EMPLOYEEID = rd.EMPLOYEEID
INNER JOIN cook_log ckl
ON rd.RECIPEID = ckl.RECIPEID
GROUP BY emp.EMPLOYEEID, emp.LASTNAME, pos.TITLE, pos.SALARY