-- trans 1,3,4
insert into resources(RESOURCEID,DATERECEIVED,TOTAL,TYPE)
values (999999, (select current_date from dual), 10000000000, 'INVESTMENT');

update recipe
set state = 'AVAILABLE'

update supplier_stock
set weightavail = weightavail * 1000;

delete from supply_request
where ingrstockid = 22615

-----------
select * 
from ingredient_stock t1 
inner join ingredient t2
on t1.INGRSTOCKID = t2.INGRSTOCKID
inner join recipe t3
on t2.RECIPEID = t3.RECIPEID
where t3.recipeid = 297--297 --577

select *
from supply_request
where ingrstockid = 22615--22615 --5056 16911

select *
from supplier_stock t1
inner join supplier t2
on t1.SUPPLIERID = t2.SUPPLIERID
where ingrstockid = 22615 --22615--5056 16911

select *
from resources
order by resourceid desc

select *
from cook_log
order by cooklogid desc

-- trans 5,6
select * from employee
where lastname = 'Kowalski'