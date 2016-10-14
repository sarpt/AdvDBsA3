
CREATE TABLE EMPLOYEE
(
	EmployeeID           INTEGER NOT NULL ,
	FirstName            VARCHAR(20) NULL ,
	LastName             VARCHAR2(20) NOT NULL ,
	DateContractFin      DATE NULL ,
	PositionID           INTEGER NULL 
);

CREATE UNIQUE INDEX XPKEMPLOYEE ON EMPLOYEE
(EmployeeID   ASC);

ALTER TABLE EMPLOYEE
	ADD CONSTRAINT  XPKEMPLOYEE PRIMARY KEY (EmployeeID);

CREATE TABLE SCHEDULE
(
	ScheduleID           INTEGER NOT NULL ,
	DayStart             INTEGER NULL ,
	EmployeeID           INTEGER NULL ,
	DateAccepted         DATE NULL ,
	DayFin               INTEGER NULL 
);

CREATE UNIQUE INDEX XPKSCHEDULE ON SCHEDULE
(ScheduleID   ASC);

ALTER TABLE SCHEDULE
	ADD CONSTRAINT  XPKSCHEDULE PRIMARY KEY (ScheduleID);

CREATE TABLE INGREDIENT_STOCK
(
	IngrStockID          INTEGER NOT NULL ,
	Title                VARCHAR(20) NOT NULL ,
	WeightAvail          DOUBLE PRECISION NOT NULL ,
	WeightMissing        DOUBLE PRECISION NOT NULL 
);

CREATE UNIQUE INDEX XPKINGREDIENT_STOCK ON INGREDIENT_STOCK
(IngrStockID   ASC);

ALTER TABLE INGREDIENT_STOCK
	ADD CONSTRAINT  XPKINGREDIENT_STOCK PRIMARY KEY (IngrStockID);

CREATE TABLE RECIPE
(
	RecipeID             INTEGER NOT NULL ,
	Title                VARCHAR2(20) NOT NULL ,
	RecipeFlow           VARCHAR2(300) NULL ,
	Price                DECIMAL NOT NULL ,
	DateCreated          DATE NOT NULL 
);

CREATE UNIQUE INDEX XPKRECIPE ON RECIPE
(RecipeID   ASC);

ALTER TABLE RECIPE
	ADD CONSTRAINT  XPKRECIPE PRIMARY KEY (RecipeID);

CREATE TABLE RECIPE_DUTY
(
	EmployeeID           INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL ,
	DutyDescription      VARCHAR2(20) NULL 
);

CREATE UNIQUE INDEX XPKRECIPE_DUTY ON RECIPE_DUTY
(EmployeeID   ASC,RecipeID   ASC);

ALTER TABLE RECIPE_DUTY
	ADD CONSTRAINT  XPKRECIPE_DUTY PRIMARY KEY (EmployeeID,RecipeID);

CREATE TABLE INGREDIENT
(
	IngrStockID          INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL ,
	WeightRecp           DOUBLE PRECISION NOT NULL 
);

CREATE UNIQUE INDEX XPKINGREDIENT ON INGREDIENT
(IngrStockID   ASC,RecipeID   ASC);

ALTER TABLE INGREDIENT
	ADD CONSTRAINT  XPKINGREDIENT PRIMARY KEY (IngrStockID,RecipeID);

CREATE TABLE COOK_LOG
(
	CookLogID            INTEGER NOT NULL ,
	DateSold             DATE NOT NULL ,
	Amount               INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKCOOK_LOG ON COOK_LOG
(CookLogID   ASC);

ALTER TABLE COOK_LOG
	ADD CONSTRAINT  XPKCOOK_LOG PRIMARY KEY (CookLogID);

CREATE TABLE POSITION
(
	PositionID           INTEGER NOT NULL ,
	Title                VARCHAR2(20) NULL ,
	Salary               DECIMAL NULL 
);

CREATE UNIQUE INDEX XPKPOSITION ON POSITION
(PositionID   ASC);

ALTER TABLE POSITION
	ADD CONSTRAINT  XPKPOSITION PRIMARY KEY (PositionID);

CREATE TABLE RESOURCES
(
	ResourceID           INTEGER NOT NULL ,
	DateReceived         DATE NULL ,
	Total                DECIMAL NULL ,
	Type                 VARCHAR2(20) NULL 
);

CREATE UNIQUE INDEX XPKRESOURCES ON RESOURCES
(ResourceID   ASC);

ALTER TABLE RESOURCES
	ADD CONSTRAINT  XPKRESOURCES PRIMARY KEY (ResourceID);

CREATE TABLE SUPPLIER
(
	SupplierID           INTEGER NOT NULL ,
	Title                VARCHAR2(20) NOT NULL ,
	Address              VARCHAR2(20) NULL ,
	Phone                VARCHAR2(20) NULL ,
	Reliability          INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKSUPPLIER ON SUPPLIER
(SupplierID   ASC);

ALTER TABLE SUPPLIER
	ADD CONSTRAINT  XPKSUPPLIER PRIMARY KEY (SupplierID);

CREATE TABLE SUPPLIER_STOCK
(
	SupplierID           INTEGER NOT NULL ,
	Price                DECIMAL NOT NULL ,
	WeightAvail          DOUBLE PRECISION NOT NULL ,
	IngrStockID          INTEGER NULL ,
	DateFreshSupply      DATE NULL 
);

CREATE UNIQUE INDEX XPKSUPPLIER_STOCK ON SUPPLIER_STOCK
(SupplierID   ASC);

ALTER TABLE SUPPLIER_STOCK
	ADD CONSTRAINT  XPKSUPPLIER_STOCK PRIMARY KEY (SupplierID);

CREATE TABLE SUPPLY_REQUEST
(
	RequestID            INTEGER NOT NULL ,
	DateRequest          DATE NOT NULL ,
	IngrStockID          INTEGER NOT NULL ,
	State                VARCHAR2(20) NOT NULL 
);

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
	ADD (CONSTRAINT R_18 FOREIGN KEY (IngrStockID) REFERENCES INGREDIENT_STOCK (IngrStockID) ON DELETE SET NULL);

ALTER TABLE SUPPLY_REQUEST
	ADD (CONSTRAINT R_17 FOREIGN KEY (IngrStockID) REFERENCES INGREDIENT_STOCK (IngrStockID));

CREATE  TRIGGER  tD_EMPLOYEE AFTER DELETE ON EMPLOYEE for each row
-- ERwin Builtin Trigger
-- DELETE trigger on EMPLOYEE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* EMPLOYEE  SCHEDULE on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0001aa79", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="SCHEDULE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="EmployeeID" */
    UPDATE SCHEDULE
      SET
        /* %SetFK(SCHEDULE,NULL) */
        SCHEDULE.EmployeeID = NULL
      WHERE
        /* %JoinFKPK(SCHEDULE,:%Old," = "," AND") */
        SCHEDULE.EmployeeID = :old.EmployeeID;

    /* ERwin Builtin Trigger */
    /* EMPLOYEE  RECIPE_DUTY on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="EmployeeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_DUTY
      WHERE
        /*  %JoinFKPK(RECIPE_DUTY,:%Old," = "," AND") */
        RECIPE_DUTY.EmployeeID = :old.EmployeeID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete EMPLOYEE because RECIPE_DUTY exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_EMPLOYEE BEFORE INSERT ON EMPLOYEE for each row
-- ERwin Builtin Trigger
-- INSERT trigger on EMPLOYEE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* POSITION  EMPLOYEE on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000e77d", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="EMPLOYEE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="PositionID" */
    UPDATE EMPLOYEE
      SET
        /* %SetFK(EMPLOYEE,NULL) */
        EMPLOYEE.PositionID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM POSITION
            WHERE
              /* %JoinFKPK(:%New,POSITION," = "," AND") */
              :new.PositionID = POSITION.PositionID
        ) 
        /* %JoinPKPK(EMPLOYEE,:%New," = "," AND") */
         and EMPLOYEE.EmployeeID = :new.EmployeeID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_EMPLOYEE AFTER UPDATE ON EMPLOYEE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on EMPLOYEE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* EMPLOYEE  SCHEDULE on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00030bdf", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="SCHEDULE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="EmployeeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.EmployeeID <> :new.EmployeeID
  THEN
    UPDATE SCHEDULE
      SET
        /* %SetFK(SCHEDULE,NULL) */
        SCHEDULE.EmployeeID = NULL
      WHERE
        /* %JoinFKPK(SCHEDULE,:%Old," = ",",") */
        SCHEDULE.EmployeeID = :old.EmployeeID;
  END IF;

  /* ERwin Builtin Trigger */
  /* EMPLOYEE  RECIPE_DUTY on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="EmployeeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.EmployeeID <> :new.EmployeeID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_DUTY
      WHERE
        /*  %JoinFKPK(RECIPE_DUTY,:%Old," = "," AND") */
        RECIPE_DUTY.EmployeeID = :old.EmployeeID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update EMPLOYEE because RECIPE_DUTY exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* POSITION  EMPLOYEE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="EMPLOYEE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="PositionID" */
  SELECT count(*) INTO NUMROWS
    FROM POSITION
    WHERE
      /* %JoinFKPK(:%New,POSITION," = "," AND") */
      :new.PositionID = POSITION.PositionID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.PositionID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update EMPLOYEE because POSITION does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_SCHEDULE BEFORE INSERT ON SCHEDULE for each row
-- ERwin Builtin Trigger
-- INSERT trigger on SCHEDULE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* EMPLOYEE  SCHEDULE on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000eecd", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="SCHEDULE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="EmployeeID" */
    UPDATE SCHEDULE
      SET
        /* %SetFK(SCHEDULE,NULL) */
        SCHEDULE.EmployeeID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM EMPLOYEE
            WHERE
              /* %JoinFKPK(:%New,EMPLOYEE," = "," AND") */
              :new.EmployeeID = EMPLOYEE.EmployeeID
        ) 
        /* %JoinPKPK(SCHEDULE,:%New," = "," AND") */
         and SCHEDULE.ScheduleID = :new.ScheduleID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_SCHEDULE AFTER UPDATE ON SCHEDULE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on SCHEDULE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* EMPLOYEE  SCHEDULE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001003a", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="SCHEDULE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="EmployeeID" */
  SELECT count(*) INTO NUMROWS
    FROM EMPLOYEE
    WHERE
      /* %JoinFKPK(:%New,EMPLOYEE," = "," AND") */
      :new.EmployeeID = EMPLOYEE.EmployeeID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.EmployeeID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update SCHEDULE because EMPLOYEE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_INGREDIENT_STOCK AFTER DELETE ON INGREDIENT_STOCK for each row
-- ERwin Builtin Trigger
-- DELETE trigger on INGREDIENT_STOCK 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* INGREDIENT_STOCK  SUPPLIER_STOCK on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0002e853", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="IngrStockID" */
    UPDATE SUPPLIER_STOCK
      SET
        /* %SetFK(SUPPLIER_STOCK,NULL) */
        SUPPLIER_STOCK.IngrStockID = NULL
      WHERE
        /* %JoinFKPK(SUPPLIER_STOCK,:%Old," = "," AND") */
        SUPPLIER_STOCK.IngrStockID = :old.IngrStockID;

    /* ERwin Builtin Trigger */
    /* INGREDIENT_STOCK  SUPPLY_REQUEST on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLY_REQUEST"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="IngrStockID" */
    SELECT count(*) INTO NUMROWS
      FROM SUPPLY_REQUEST
      WHERE
        /*  %JoinFKPK(SUPPLY_REQUEST,:%Old," = "," AND") */
        SUPPLY_REQUEST.IngrStockID = :old.IngrStockID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete INGREDIENT_STOCK because SUPPLY_REQUEST exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* INGREDIENT_STOCK  INGREDIENT on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="IngrStockID" */
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT
      WHERE
        /*  %JoinFKPK(INGREDIENT,:%Old," = "," AND") */
        INGREDIENT.IngrStockID = :old.IngrStockID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete INGREDIENT_STOCK because INGREDIENT exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_INGREDIENT_STOCK AFTER UPDATE ON INGREDIENT_STOCK for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on INGREDIENT_STOCK 
DECLARE NUMROWS INTEGER;
BEGIN
  /* INGREDIENT_STOCK  SUPPLIER_STOCK on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00036c3a", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="IngrStockID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.IngrStockID <> :new.IngrStockID
  THEN
    UPDATE SUPPLIER_STOCK
      SET
        /* %SetFK(SUPPLIER_STOCK,NULL) */
        SUPPLIER_STOCK.IngrStockID = NULL
      WHERE
        /* %JoinFKPK(SUPPLIER_STOCK,:%Old," = ",",") */
        SUPPLIER_STOCK.IngrStockID = :old.IngrStockID;
  END IF;

  /* ERwin Builtin Trigger */
  /* INGREDIENT_STOCK  SUPPLY_REQUEST on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLY_REQUEST"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="IngrStockID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.IngrStockID <> :new.IngrStockID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM SUPPLY_REQUEST
      WHERE
        /*  %JoinFKPK(SUPPLY_REQUEST,:%Old," = "," AND") */
        SUPPLY_REQUEST.IngrStockID = :old.IngrStockID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update INGREDIENT_STOCK because SUPPLY_REQUEST exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* INGREDIENT_STOCK  INGREDIENT on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="IngrStockID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.IngrStockID <> :new.IngrStockID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT
      WHERE
        /*  %JoinFKPK(INGREDIENT,:%Old," = "," AND") */
        INGREDIENT.IngrStockID = :old.IngrStockID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update INGREDIENT_STOCK because INGREDIENT exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_RECIPE AFTER DELETE ON RECIPE for each row
-- ERwin Builtin Trigger
-- DELETE trigger on RECIPE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  COOK_LOG on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00029883", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="COOK_LOG"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="RecipeID" */
    UPDATE COOK_LOG
      SET
        /* %SetFK(COOK_LOG,NULL) */
        COOK_LOG.RecipeID = NULL
      WHERE
        /* %JoinFKPK(COOK_LOG,:%Old," = "," AND") */
        COOK_LOG.RecipeID = :old.RecipeID;

    /* ERwin Builtin Trigger */
    /* RECIPE  RECIPE_DUTY on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_DUTY
      WHERE
        /*  %JoinFKPK(RECIPE_DUTY,:%Old," = "," AND") */
        RECIPE_DUTY.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RECIPE because RECIPE_DUTY exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* RECIPE  INGREDIENT on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="RecipeID" */
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT
      WHERE
        /*  %JoinFKPK(INGREDIENT,:%Old," = "," AND") */
        INGREDIENT.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RECIPE because INGREDIENT exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RECIPE AFTER UPDATE ON RECIPE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RECIPE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* RECIPE  COOK_LOG on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0002f1ab", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="COOK_LOG"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="RecipeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RecipeID <> :new.RecipeID
  THEN
    UPDATE COOK_LOG
      SET
        /* %SetFK(COOK_LOG,NULL) */
        COOK_LOG.RecipeID = NULL
      WHERE
        /* %JoinFKPK(COOK_LOG,:%Old," = ",",") */
        COOK_LOG.RecipeID = :old.RecipeID;
  END IF;

  /* ERwin Builtin Trigger */
  /* RECIPE  RECIPE_DUTY on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RecipeID <> :new.RecipeID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_DUTY
      WHERE
        /*  %JoinFKPK(RECIPE_DUTY,:%Old," = "," AND") */
        RECIPE_DUTY.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RECIPE because RECIPE_DUTY exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* RECIPE  INGREDIENT on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="RecipeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RecipeID <> :new.RecipeID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT
      WHERE
        /*  %JoinFKPK(INGREDIENT,:%Old," = "," AND") */
        INGREDIENT.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RECIPE because INGREDIENT exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_RECIPE_DUTY BEFORE INSERT ON RECIPE_DUTY for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RECIPE_DUTY 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  RECIPE_DUTY on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001ead6", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE
      WHERE
        /* %JoinFKPK(:%New,RECIPE," = "," AND") */
        :new.RecipeID = RECIPE.RecipeID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert RECIPE_DUTY because RECIPE does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* EMPLOYEE  RECIPE_DUTY on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="EmployeeID" */
    SELECT count(*) INTO NUMROWS
      FROM EMPLOYEE
      WHERE
        /* %JoinFKPK(:%New,EMPLOYEE," = "," AND") */
        :new.EmployeeID = EMPLOYEE.EmployeeID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert RECIPE_DUTY because EMPLOYEE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RECIPE_DUTY AFTER UPDATE ON RECIPE_DUTY for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RECIPE_DUTY 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RECIPE  RECIPE_DUTY on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001eabb", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
  SELECT count(*) INTO NUMROWS
    FROM RECIPE
    WHERE
      /* %JoinFKPK(:%New,RECIPE," = "," AND") */
      :new.RecipeID = RECIPE.RecipeID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RECIPE_DUTY because RECIPE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* EMPLOYEE  RECIPE_DUTY on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_DUTY"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="EmployeeID" */
  SELECT count(*) INTO NUMROWS
    FROM EMPLOYEE
    WHERE
      /* %JoinFKPK(:%New,EMPLOYEE," = "," AND") */
      :new.EmployeeID = EMPLOYEE.EmployeeID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RECIPE_DUTY because EMPLOYEE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_INGREDIENT BEFORE INSERT ON INGREDIENT for each row
-- ERwin Builtin Trigger
-- INSERT trigger on INGREDIENT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  INGREDIENT on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001fedf", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="RecipeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE
      WHERE
        /* %JoinFKPK(:%New,RECIPE," = "," AND") */
        :new.RecipeID = RECIPE.RecipeID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert INGREDIENT because RECIPE does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* INGREDIENT_STOCK  INGREDIENT on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="IngrStockID" */
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT_STOCK
      WHERE
        /* %JoinFKPK(:%New,INGREDIENT_STOCK," = "," AND") */
        :new.IngrStockID = INGREDIENT_STOCK.IngrStockID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert INGREDIENT because INGREDIENT_STOCK does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_INGREDIENT AFTER UPDATE ON INGREDIENT for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on INGREDIENT 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RECIPE  INGREDIENT on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00020d8a", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="RecipeID" */
  SELECT count(*) INTO NUMROWS
    FROM RECIPE
    WHERE
      /* %JoinFKPK(:%New,RECIPE," = "," AND") */
      :new.RecipeID = RECIPE.RecipeID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update INGREDIENT because RECIPE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* INGREDIENT_STOCK  INGREDIENT on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="IngrStockID" */
  SELECT count(*) INTO NUMROWS
    FROM INGREDIENT_STOCK
    WHERE
      /* %JoinFKPK(:%New,INGREDIENT_STOCK," = "," AND") */
      :new.IngrStockID = INGREDIENT_STOCK.IngrStockID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update INGREDIENT because INGREDIENT_STOCK does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_COOK_LOG BEFORE INSERT ON COOK_LOG for each row
-- ERwin Builtin Trigger
-- INSERT trigger on COOK_LOG 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  COOK_LOG on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000eca2", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="COOK_LOG"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="RecipeID" */
    UPDATE COOK_LOG
      SET
        /* %SetFK(COOK_LOG,NULL) */
        COOK_LOG.RecipeID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM RECIPE
            WHERE
              /* %JoinFKPK(:%New,RECIPE," = "," AND") */
              :new.RecipeID = RECIPE.RecipeID
        ) 
        /* %JoinPKPK(COOK_LOG,:%New," = "," AND") */
         and COOK_LOG.CookLogID = :new.CookLogID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_COOK_LOG AFTER UPDATE ON COOK_LOG for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on COOK_LOG 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RECIPE  COOK_LOG on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0000ff0f", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="COOK_LOG"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="RecipeID" */
  SELECT count(*) INTO NUMROWS
    FROM RECIPE
    WHERE
      /* %JoinFKPK(:%New,RECIPE," = "," AND") */
      :new.RecipeID = RECIPE.RecipeID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.RecipeID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update COOK_LOG because RECIPE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_POSITION AFTER DELETE ON POSITION for each row
-- ERwin Builtin Trigger
-- DELETE trigger on POSITION 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* POSITION  EMPLOYEE on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000af96", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="EMPLOYEE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="PositionID" */
    UPDATE EMPLOYEE
      SET
        /* %SetFK(EMPLOYEE,NULL) */
        EMPLOYEE.PositionID = NULL
      WHERE
        /* %JoinFKPK(EMPLOYEE,:%Old," = "," AND") */
        EMPLOYEE.PositionID = :old.PositionID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_POSITION AFTER UPDATE ON POSITION for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on POSITION 
DECLARE NUMROWS INTEGER;
BEGIN
  /* POSITION  EMPLOYEE on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000d02b", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="EMPLOYEE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="PositionID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.PositionID <> :new.PositionID
  THEN
    UPDATE EMPLOYEE
      SET
        /* %SetFK(EMPLOYEE,NULL) */
        EMPLOYEE.PositionID = NULL
      WHERE
        /* %JoinFKPK(EMPLOYEE,:%Old," = ",",") */
        EMPLOYEE.PositionID = :old.PositionID;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_SUPPLIER AFTER DELETE ON SUPPLIER for each row
-- ERwin Builtin Trigger
-- DELETE trigger on SUPPLIER 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* SUPPLIER  SUPPLIER_STOCK on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e597", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="SupplierID" */
    SELECT count(*) INTO NUMROWS
      FROM SUPPLIER_STOCK
      WHERE
        /*  %JoinFKPK(SUPPLIER_STOCK,:%Old," = "," AND") */
        SUPPLIER_STOCK.SupplierID = :old.SupplierID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete SUPPLIER because SUPPLIER_STOCK exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_SUPPLIER AFTER UPDATE ON SUPPLIER for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on SUPPLIER 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* SUPPLIER  SUPPLIER_STOCK on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000111ef", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="SupplierID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.SupplierID <> :new.SupplierID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM SUPPLIER_STOCK
      WHERE
        /*  %JoinFKPK(SUPPLIER_STOCK,:%Old," = "," AND") */
        SUPPLIER_STOCK.SupplierID = :old.SupplierID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update SUPPLIER because SUPPLIER_STOCK exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_SUPPLIER_STOCK BEFORE INSERT ON SUPPLIER_STOCK for each row
-- ERwin Builtin Trigger
-- INSERT trigger on SUPPLIER_STOCK 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* INGREDIENT_STOCK  SUPPLIER_STOCK on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0002255c", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="IngrStockID" */
    UPDATE SUPPLIER_STOCK
      SET
        /* %SetFK(SUPPLIER_STOCK,NULL) */
        SUPPLIER_STOCK.IngrStockID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM INGREDIENT_STOCK
            WHERE
              /* %JoinFKPK(:%New,INGREDIENT_STOCK," = "," AND") */
              :new.IngrStockID = INGREDIENT_STOCK.IngrStockID
        ) 
        /* %JoinPKPK(SUPPLIER_STOCK,:%New," = "," AND") */
         and SUPPLIER_STOCK.SupplierID = :new.SupplierID;

    /* ERwin Builtin Trigger */
    /* SUPPLIER  SUPPLIER_STOCK on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="SupplierID" */
    SELECT count(*) INTO NUMROWS
      FROM SUPPLIER
      WHERE
        /* %JoinFKPK(:%New,SUPPLIER," = "," AND") */
        :new.SupplierID = SUPPLIER.SupplierID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert SUPPLIER_STOCK because SUPPLIER does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_SUPPLIER_STOCK AFTER UPDATE ON SUPPLIER_STOCK for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on SUPPLIER_STOCK 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* INGREDIENT_STOCK  SUPPLIER_STOCK on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00022037", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="IngrStockID" */
  SELECT count(*) INTO NUMROWS
    FROM INGREDIENT_STOCK
    WHERE
      /* %JoinFKPK(:%New,INGREDIENT_STOCK," = "," AND") */
      :new.IngrStockID = INGREDIENT_STOCK.IngrStockID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.IngrStockID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update SUPPLIER_STOCK because INGREDIENT_STOCK does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* SUPPLIER  SUPPLIER_STOCK on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="SUPPLIER_STOCK"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="SupplierID" */
  SELECT count(*) INTO NUMROWS
    FROM SUPPLIER
    WHERE
      /* %JoinFKPK(:%New,SUPPLIER," = "," AND") */
      :new.SupplierID = SUPPLIER.SupplierID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update SUPPLIER_STOCK because SUPPLIER does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_SUPPLY_REQUEST BEFORE INSERT ON SUPPLY_REQUEST for each row
-- ERwin Builtin Trigger
-- INSERT trigger on SUPPLY_REQUEST 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* INGREDIENT_STOCK  SUPPLY_REQUEST on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001013e", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLY_REQUEST"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="IngrStockID" */
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT_STOCK
      WHERE
        /* %JoinFKPK(:%New,INGREDIENT_STOCK," = "," AND") */
        :new.IngrStockID = INGREDIENT_STOCK.IngrStockID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert SUPPLY_REQUEST because INGREDIENT_STOCK does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_SUPPLY_REQUEST AFTER UPDATE ON SUPPLY_REQUEST for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on SUPPLY_REQUEST 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* INGREDIENT_STOCK  SUPPLY_REQUEST on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="000103f0", PARENT_OWNER="", PARENT_TABLE="INGREDIENT_STOCK"
    CHILD_OWNER="", CHILD_TABLE="SUPPLY_REQUEST"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="IngrStockID" */
  SELECT count(*) INTO NUMROWS
    FROM INGREDIENT_STOCK
    WHERE
      /* %JoinFKPK(:%New,INGREDIENT_STOCK," = "," AND") */
      :new.IngrStockID = INGREDIENT_STOCK.IngrStockID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update SUPPLY_REQUEST because INGREDIENT_STOCK does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/

