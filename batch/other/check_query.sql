-- Measuring time
set serveroutput on
variable n number
exec :n := dbms_utility.get_time

-- Tunning the db BEGIN
ALTER SYSTEM SET RESOURCE_MANAGER_PLAN = default_plan;
/
ALTER SYSTEM FLUSH BUFFER_CACHE;
/
ALTER SYSTEM FLUSH SHARED_POOL;
/
-- Tunning the db END

-- some query here BEGIN
SELECT COUNT(*) FROM POSITION;
/
SELECT COUNT(*) FROM EMPLOYEE;
/
SELECT COUNT(*) FROM SCHEDULE;
/
SELECT COUNT(*) FROM RECIPE;
/
SELECT COUNT(*) FROM RECIPE_DUTY;
/
SELECT COUNT(*) FROM INGREDIENT_STOCK;
/
SELECT COUNT(*) FROM SUPPLIER;
/
SELECT COUNT(*) FROM SUPPLIER_STOCK;
/
SELECT COUNT(*) FROM SUPPLY_REQUEST;
/
-- some query here END
exec :n := (dbms_utility.get_time - :n)/100
exec dbms_output.put_line(:n)
/