insert into resources(RESOURCEID,DATERECEIVED,TOTAL,TYPE)
values (999999, (select current_date from dual), 10000000000, 'INVESTMENT');
/
UPDATE RESOURCES SET TYPE = UPPER(TYPE);
/
update recipe
set state = 'AVAILABLE'
/
update supplier_stock
set weightavail = weightavail * 1000;
/
delete from supply_request
where ingrstockid = 22615;
/