-- #1 RECORD DISH ORDER
-- Measuring time
CREATE OR REPLACE PROCEDURE record_dish_order
	(recipe_id IN NUMBER, amount IN NUMBER, recipe_hour IN NUMBER)
IS
	vn NUMBER;
	chefs_avail		NUMBER;
	missing_buf		DECIMAL;
	recipe_price	DECIMAL;
BEGIN
  vn := dbms_utility.get_time;

	SET TRANSACTION NAME 'REC_DISH';
		BEGIN
			FOR ingr_row IN (
							SELECT *
							FROM INGREDIENT INGR
							WHERE INGR.RECIPEID = recipe_id
							)					
			LOOP
				-- compare with stock
				UPDATE INGREDIENT_STOCK
				SET WEIGHTMISSING = (ingr_row.WEIGHTRECP * amount - WEIGHTAVAIL)
				WHERE INGRSTOCKID = ingr_row.INGRSTOCKID
				AND WEIGHTAVAIL < ingr_row.WEIGHTRECP * amount;
			END LOOP;
			
			-- is there any chef available
			SELECT COUNT(*) INTO chefs_avail
			FROM EMPLOYEE E
			INNER JOIN POSITION P
			ON E.POSITIONID = P.POSITIONID
			INNER JOIN SCHEDULE S
			ON S.EMPLOYEEID = E.EMPLOYEEID
			WHERE DATECONTRACTFIN >= (SELECT CURRENT_DATE FROM DUAL)
			AND UPPER(P.TITLE) LIKE '%COOK%'
			AND S.DAYSTART < recipe_hour
			AND S.DAYFIN > recipe_hour;
			
			-- check if we have enough in stocks
			SELECT MAX(WEIGHTMISSING) INTO missing_buf
			FROM INGREDIENT_STOCK
			WHERE INGRSTOCKID IN (
				SELECT INGRSTOCKID
				FROM INGREDIENT
				WHERE RECIPEID = recipe_id
			);
			
			IF missing_buf = 0.0 AND chefs_avail > 0 THEN		
				-- record payment
				SELECT PRICE INTO recipe_price
				FROM RECIPE
				WHERE RECIPEID = recipe_id;
				
				INSERT INTO RESOURCES (RESOURCES.TOTAL, RESOURCES.TYPE, RESOURCES.DATERECEIVED)
				VALUES (recipe_price * amount, 'PAYMENT', (SELECT CURRENT_DATE FROM DUAL));
				
				INSERT INTO COOK_LOG (DATESOLD, AMOUNT, RECIPEID)
				VALUES ((SELECT CURRENT_DATE FROM DUAL), amount, recipe_id);
			END IF;
		END;
	
	COMMIT;

  vn := (dbms_utility.get_time - vn)/100;
  DBMS_OUTPUT.PUT_LINE('Execution time '||vn||' sec');

END;
/