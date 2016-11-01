CREATE UNIQUE INDEX XPKEMPLOYEE ON EMPLOYEE
(EmployeeID   ASC);

ALTER TABLE EMPLOYEE
	ADD CONSTRAINT  XPKEMPLOYEE PRIMARY KEY (EmployeeID);
	
CREATE UNIQUE INDEX XPKSCHEDULE ON SCHEDULE
(ScheduleID   ASC);

ALTER TABLE SCHEDULE
	ADD CONSTRAINT  XPKSCHEDULE PRIMARY KEY (ScheduleID);
	
CREATE UNIQUE INDEX XPKINGREDIENT_STOCK ON INGREDIENT_STOCK
(IngrStockID   ASC);

ALTER TABLE INGREDIENT_STOCK
	ADD CONSTRAINT  XPKINGREDIENT_STOCK PRIMARY KEY (IngrStockID);

CREATE UNIQUE INDEX XPKRECIPE ON RECIPE
(RecipeID   ASC);

ALTER TABLE RECIPE
	ADD CONSTRAINT  XPKRECIPE PRIMARY KEY (RecipeID);
	
CREATE UNIQUE INDEX XPKRECIPE_DUTY ON RECIPE_DUTY
(RecipeID   ASC, EmployeeID   ASC);

ALTER TABLE RECIPE_DUTY
	ADD CONSTRAINT  XPKRECIPE_DUTY PRIMARY KEY (EmployeeID,RecipeID);
	
CREATE UNIQUE INDEX XPKINGREDIENT ON INGREDIENT
(RecipeID   ASC, IngrStockID   ASC);

ALTER TABLE INGREDIENT
	ADD CONSTRAINT  XPKINGREDIENT PRIMARY KEY (IngrStockID,RecipeID);

CREATE UNIQUE INDEX XPKCOOK_LOG ON COOK_LOG
(CookLogID   ASC);

ALTER TABLE COOK_LOG
	ADD CONSTRAINT  XPKCOOK_LOG PRIMARY KEY (CookLogID);
	
CREATE UNIQUE INDEX XPKPOSITION ON POSITION
(PositionID   ASC);

ALTER TABLE POSITION
	ADD CONSTRAINT  XPKPOSITION PRIMARY KEY (PositionID);
	
CREATE UNIQUE INDEX XPKRESOURCES ON RESOURCES
(ResourceID   ASC);

ALTER TABLE RESOURCES
	ADD CONSTRAINT  XPKRESOURCES PRIMARY KEY (ResourceID);
	
CREATE UNIQUE INDEX XPKSUPPLIER ON SUPPLIER
(SupplierID   ASC);

ALTER TABLE SUPPLIER
	ADD CONSTRAINT  XPKSUPPLIER PRIMARY KEY (SupplierID);
	
CREATE UNIQUE INDEX XPKSUPPLIER_STOCK ON SUPPLIER_STOCK
(SupplierID   ASC,IngrStockID   ASC);

ALTER TABLE SUPPLIER_STOCK
	ADD CONSTRAINT  XPKSUPPLIER_STOCK PRIMARY KEY (SupplierID,IngrStockID);
	
CREATE UNIQUE INDEX XPKSUPPLY_REQUEST ON SUPPLY_REQUEST
(RequestID   ASC,IngrStockID   ASC);

ALTER TABLE SUPPLY_REQUEST
	ADD CONSTRAINT  XPKSUPPLY_REQUEST PRIMARY KEY (RequestID,IngrStockID);

ALTER TABLE EMPLOYEE
	ADD (CONSTRAINT R_19 FOREIGN KEY (PositionID) REFERENCES POSITION (PositionID) ON DELETE SET NULL);

ALTER TABLE SCHEDULE
	ADD (CONSTRAINT R_16 FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE (EmployeeID) ON DELETE SET NULL);

ALTER TABLE RECIPE_DUTY
	ADD (CONSTRAINT R_8 FOREIGN KEY (RecipeID) REFERENCES RECIPE (RecipeID));

ALTER TABLE RECIPE_DUTY
	ADD (CONSTRAINT R_7 FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE (EmployeeID));

ALTER TABLE INGREDIENT
	ADD (CONSTRAINT R_4 FOREIGN KEY (IngrStockID) REFERENCES INGREDIENT_STOCK (IngrStockID));

ALTER TABLE INGREDIENT
	ADD (CONSTRAINT R_5 FOREIGN KEY (RecipeID) REFERENCES RECIPE (RecipeID));

ALTER TABLE COOK_LOG
	ADD (CONSTRAINT R_15 FOREIGN KEY (RecipeID) REFERENCES RECIPE (RecipeID) ON DELETE SET NULL);

ALTER TABLE SUPPLIER_STOCK
	ADD (CONSTRAINT R_11 FOREIGN KEY (SupplierID) REFERENCES SUPPLIER (SupplierID));

ALTER TABLE SUPPLIER_STOCK
	ADD (CONSTRAINT R_20 FOREIGN KEY (IngrStockID) REFERENCES INGREDIENT_STOCK (IngrStockID));

ALTER TABLE SUPPLY_REQUEST
	ADD (CONSTRAINT R_17 FOREIGN KEY (IngrStockID) REFERENCES INGREDIENT_STOCK (IngrStockID));