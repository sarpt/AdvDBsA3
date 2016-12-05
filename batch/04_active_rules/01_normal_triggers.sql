-- active rule #3
CREATE OR REPLACE TRIGGER employee_contract_time
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
  IF SYSDATE + 30 > :new.datecontractfin THEN
    :new.datecontractfin := SYSDATE + 30;
  END IF;
END;
/

-- active rule #4
CREATE OR REPLACE TRIGGER supplier_stock_update
AFTER INSERT OR UPDATE ON SUPPLIER_STOCK
FOR EACH ROW
DECLARE
  is_present number;
  weight_missing number;
  nid number;
BEGIN
  SELECT count(*) INTO is_present FROM INGREDIENT_STOCK WHERE ingrstockid=:new.ingrstockid;
  SELECT WEIGHTMISSING INTO weight_missing FROM INGREDIENT_STOCK WHERE ingrstockid=:new.ingrstockid;
  SELECT MAX(REQUESTID) + 1 INTO nid FROM SUPPLY_REQUEST;
  IF (is_present > 0) AND (weight_missing >= 0) THEN
    INSERT INTO SUPPLY_REQUEST VALUES (nid, SYSDATE, :new.ingrstockid, 'UNSATISFIED');
  END IF;
END;
/

-- active rule #5
CREATE OR REPLACE TRIGGER supply_request_exec
AFTER INSERT OR UPDATE ON SUPPLY_REQUEST
FOR EACH ROW
DECLARE
  is_present number;
  weight_missing number;
  nid number;
  total_price number;
  total_outcome number;
  total_res number;
BEGIN


END;
/