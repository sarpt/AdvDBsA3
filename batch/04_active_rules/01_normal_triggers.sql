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
BEFORE UPDATE ON SUPPLY_REQUEST
FOR EACH ROW
DECLARE
  is_present number;
  weight_missing number;
  total_price number;
  total_outcome number;
  total_res number;
  supplier_price number;
BEGIN
  select count(*) INTO is_present FROM INGREDIENT_STOCK WHERE ingrstockid=:new.ingrstockid;
  SELECT WEIGHTMISSING INTO weight_missing FROM INGREDIENT_STOCK WHERE ingrstockid=:new.ingrstockid;

  IF (is_present > 0) AND (weight_missing > 0) AND (:new.STATE = 'UNSATISFIED') THEN

    SELECT MIN(PRICE) INTO supplier_price FROM SUPPLIER_STOCK WHERE INGRSTOCKID=:new.INGRSTOCKID;
                          
    SELECT SUM(TOTAL) INTO total_outcome
    FROM resources res
    WHERE UPPER(res.TYPE) = 'TRANSFER';
    
    SELECT SUM(TOTAL) - total_outcome INTO total_res
    FROM resources res        
    WHERE UPPER(res.TYPE) IN ('PAYMENT', 'INVESTMENT');
    
    IF (weight_missing * supplier_price <= total_res) THEN
      UPDATE INGREDIENT_STOCK
      SET WEIGHTAVAIL = WEIGHTAVAIL + WEIGHTMISSING,
        WEIGHTMISSING = 0.0
      WHERE INGRSTOCKID=:new.INGRSTOCKID;
                          
      INSERT INTO resources VALUES ((SELECT MAX(RESOURCEID) + 1 FROM RESOURCES), SYSDATE, weight_missing * supplier_price,'TRANSFER');
      
      :new.STATE:='SATISFIED';           
    END IF;
    
  END IF;
END;
/