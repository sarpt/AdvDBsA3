-- Generated by Oracle SQL Developer Data Modeler 4.1.5.907
--   at:        2016-10-12 20:39:36 CEST
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c




CREATE TABLE COOK_LOG
  (
    CookLogID INTEGER NOT NULL ,
    DateSold  DATE NOT NULL ,
    Amount    INTEGER NOT NULL ,
    RecipeID  INTEGER NOT NULL
  ) ;
CREATE UNIQUE INDEX XPKCOOK_LOG ON COOK_LOG
  (
    CookLogID ASC
  )
  ;
ALTER TABLE COOK_LOG ADD CONSTRAINT XPKCOOK_LOG PRIMARY KEY ( CookLogID ) ;


CREATE TABLE EMPLOYEE
  (
    EmployeeID      INTEGER NOT NULL ,
    FirstName       VARCHAR2 (20) ,
    LastName        VARCHAR2 (20) NOT NULL ,
    DateContractFin DATE ,
    PositionID      INTEGER
  ) ;
CREATE UNIQUE INDEX XPKEMPLOYEE ON EMPLOYEE
  (
    EmployeeID ASC
  )
  ;
ALTER TABLE EMPLOYEE ADD CONSTRAINT XPKEMPLOYEE PRIMARY KEY ( EmployeeID ) ;


CREATE TABLE INGREDIENT
  (
    IngrStockID INTEGER NOT NULL ,
    RecipeID    INTEGER NOT NULL ,
    WeightRecp FLOAT NOT NULL
  ) ;
CREATE UNIQUE INDEX XPKINGREDIENT ON INGREDIENT
  (
    IngrStockID ASC , RecipeID ASC
  )
  ;
ALTER TABLE INGREDIENT ADD CONSTRAINT XPKINGREDIENT PRIMARY KEY ( IngrStockID, RecipeID ) ;


CREATE TABLE INGREDIENT_STOCK
  (
    IngrStockID INTEGER NOT NULL ,
    Title       VARCHAR2 (20) NOT NULL ,
    WeightAvail FLOAT NOT NULL ,
    WeightMissing FLOAT NOT NULL
  ) ;
CREATE UNIQUE INDEX XPKINGREDIENT_STOCK ON INGREDIENT_STOCK
  (
    IngrStockID ASC
  )
  ;
ALTER TABLE INGREDIENT_STOCK ADD CONSTRAINT XPKINGREDIENT_STOCK PRIMARY KEY ( IngrStockID ) ;


CREATE TABLE POSITION
  (
    PositionID INTEGER NOT NULL ,
    Title      VARCHAR2 (20) ,
    Salary     NUMBER
  ) ;
CREATE UNIQUE INDEX XPKPOSITION ON POSITION
  (
    PositionID ASC
  )
  ;
ALTER TABLE POSITION ADD CONSTRAINT XPKPOSITION PRIMARY KEY ( PositionID ) ;


CREATE TABLE RECIPE
  (
    RecipeID    INTEGER NOT NULL ,
    Title       VARCHAR2 (20) NOT NULL ,
    RecipeFlow  VARCHAR2 (300) ,
    Price       NUMBER NOT NULL ,
    DateCreated DATE NOT NULL ,
    Category    VARCHAR2 (20)
  ) ;
CREATE UNIQUE INDEX XPKRECIPE ON RECIPE
  (
    RecipeID ASC
  )
  ;
ALTER TABLE RECIPE ADD CONSTRAINT XPKRECIPE PRIMARY KEY ( RecipeID ) ;


CREATE TABLE RECIPE_DUTY
  (
    EmployeeID      INTEGER NOT NULL ,
    RecipeID        INTEGER NOT NULL ,
    DutyDescription VARCHAR2 (20)
  ) ;
CREATE UNIQUE INDEX XPKRECIPE_CHEF ON RECIPE_DUTY
  (
    EmployeeID ASC , RecipeID ASC
  )
  ;
ALTER TABLE RECIPE_DUTY ADD CONSTRAINT XPKRECIPE_CHEF PRIMARY KEY ( EmployeeID, RecipeID ) ;


CREATE TABLE RESOURCES
  (
    ResourceID   INTEGER NOT NULL ,
    DateReceived DATE ,
    Total        NUMBER ,
    Type         VARCHAR2 (20)
  ) ;
CREATE UNIQUE INDEX XPKRESOURCES ON RESOURCES
  (
    ResourceID ASC
  )
  ;
ALTER TABLE RESOURCES ADD CONSTRAINT XPKRESOURCES PRIMARY KEY ( ResourceID ) ;


CREATE TABLE SCHEDULE
  (
    ScheduleID   INTEGER NOT NULL ,
    DayStart     INTEGER ,
    EmployeeID   INTEGER ,
    DateAccepted DATE ,
    DayFin       INTEGER
  ) ;
CREATE UNIQUE INDEX XPKSCHEDULE ON SCHEDULE
  (
    ScheduleID ASC
  )
  ;
ALTER TABLE SCHEDULE ADD CONSTRAINT XPKSCHEDULE PRIMARY KEY ( ScheduleID ) ;


CREATE TABLE SUPPLIER
  (
    SupplierID  INTEGER NOT NULL ,
    Title       VARCHAR2 (20) NOT NULL ,
    Address     VARCHAR2 (20) ,
    Phone       VARCHAR2 (20) ,
    Reliability INTEGER NOT NULL
  ) ;
CREATE UNIQUE INDEX XPKSUPPLIER ON SUPPLIER
  (
    SupplierID ASC
  )
  ;
ALTER TABLE SUPPLIER ADD CONSTRAINT XPKSUPPLIER PRIMARY KEY ( SupplierID ) ;


CREATE TABLE SUPPLIER_STOCK
  (
    SupplierID INTEGER NOT NULL ,
    Price      NUMBER NOT NULL ,
    WeightAvail FLOAT NOT NULL ,
    IngrStockID     INTEGER ,
    DateFreshSupply DATE
  ) ;
CREATE UNIQUE INDEX XPKSUPPLIER_STOCK ON SUPPLIER_STOCK
  (
    SupplierID ASC
  )
  ;
ALTER TABLE SUPPLIER_STOCK ADD CONSTRAINT XPKSUPPLIER_STOCK PRIMARY KEY ( SupplierID ) ;


CREATE TABLE SUPPLY_REQUEST
  (
    RequestID   INTEGER NOT NULL ,
    DateRequest DATE NOT NULL ,
    IngrStockID INTEGER NOT NULL ,
    State       VARCHAR2 (20) NOT NULL
  ) ;
CREATE UNIQUE INDEX XPKSUPPLY_REQUEST ON SUPPLY_REQUEST
  (
    RequestID ASC , IngrStockID ASC
  )
  ;
ALTER TABLE SUPPLY_REQUEST ADD CONSTRAINT XPKSUPPLY_REQUEST PRIMARY KEY ( RequestID, IngrStockID ) ;


ALTER TABLE SUPPLIER_STOCK ADD CONSTRAINT R_11 FOREIGN KEY ( SupplierID ) REFERENCES SUPPLIER ( SupplierID ) NOT DEFERRABLE ;

ALTER TABLE COOK_LOG ADD CONSTRAINT R_15 FOREIGN KEY ( RecipeID ) REFERENCES RECIPE ( RecipeID ) NOT DEFERRABLE ;

ALTER TABLE SCHEDULE ADD CONSTRAINT R_16 FOREIGN KEY ( EmployeeID ) REFERENCES EMPLOYEE ( EmployeeID ) ON
DELETE SET NULL NOT DEFERRABLE ;

ALTER TABLE SUPPLY_REQUEST ADD CONSTRAINT R_17 FOREIGN KEY ( IngrStockID ) REFERENCES INGREDIENT_STOCK ( IngrStockID ) NOT DEFERRABLE ;

ALTER TABLE SUPPLIER_STOCK ADD CONSTRAINT R_18 FOREIGN KEY ( IngrStockID ) REFERENCES INGREDIENT_STOCK ( IngrStockID ) ON
DELETE SET NULL NOT DEFERRABLE ;

ALTER TABLE EMPLOYEE ADD CONSTRAINT R_19 FOREIGN KEY ( PositionID ) REFERENCES POSITION ( PositionID ) ON
DELETE SET NULL NOT DEFERRABLE ;

ALTER TABLE INGREDIENT ADD CONSTRAINT R_4 FOREIGN KEY ( IngrStockID ) REFERENCES INGREDIENT_STOCK ( IngrStockID ) NOT DEFERRABLE ;

ALTER TABLE INGREDIENT ADD CONSTRAINT R_5 FOREIGN KEY ( RecipeID ) REFERENCES RECIPE ( RecipeID ) NOT DEFERRABLE ;

ALTER TABLE RECIPE_DUTY ADD CONSTRAINT R_7 FOREIGN KEY ( EmployeeID ) REFERENCES EMPLOYEE ( EmployeeID ) NOT DEFERRABLE ;

ALTER TABLE RECIPE_DUTY ADD CONSTRAINT R_8 FOREIGN KEY ( RecipeID ) REFERENCES RECIPE ( RecipeID ) NOT DEFERRABLE ;

CREATE OR REPLACE TRIGGER tD_EMPLOYEE 
    AFTER DELETE ON EMPLOYEE 
    FOR EACH ROW 
-- ERwin Builtin Trigger
-- DELETE trigger on EMPLOYEE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* EMPLOYEE  SCHEDULE on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0001ac00", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
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
    /* EMPLOYEE  RECIPE_CHEF on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="EmployeeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_CHEF
      WHERE
        /*  %JoinFKPK(RECIPE_CHEF,:%Old," = "," AND") */
        RECIPE_CHEF.EmployeeID = :old.EmployeeID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete EMPLOYEE because RECIPE_CHEF exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END; 
/



CREATE OR REPLACE TRIGGER tD_INGREDIENT_STOCK 
    AFTER DELETE ON INGREDIENT_STOCK 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tD_POSITION 
    AFTER DELETE ON POSITION 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tD_RECIPE 
    AFTER DELETE ON RECIPE 
    FOR EACH ROW 
-- ERwin Builtin Trigger
-- DELETE trigger on RECIPE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  COOK_LOG on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00029a94", PARENT_OWNER="", PARENT_TABLE="RECIPE"
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
    /* RECIPE  RECIPE_CHEF on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_CHEF
      WHERE
        /*  %JoinFKPK(RECIPE_CHEF,:%Old," = "," AND") */
        RECIPE_CHEF.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RECIPE because RECIPE_CHEF exists.'
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



CREATE OR REPLACE TRIGGER tD_SUPPLIER 
    AFTER DELETE ON SUPPLIER 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tI_COOK_LOG 
    BEFORE INSERT ON COOK_LOG 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tI_EMPLOYEE 
    BEFORE INSERT ON EMPLOYEE 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tI_INGREDIENT 
    BEFORE INSERT ON INGREDIENT 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tI_RECIPE_CHEF 
    BEFORE INSERT ON RECIPE_DUTY 
    FOR EACH ROW 
-- ERwin Builtin Trigger
-- INSERT trigger on RECIPE_CHEF 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  RECIPE_CHEF on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001fca5", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
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
        'Cannot insert RECIPE_CHEF because RECIPE does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* EMPLOYEE  RECIPE_CHEF on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
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
        'Cannot insert RECIPE_CHEF because EMPLOYEE does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END; 
/



CREATE OR REPLACE TRIGGER tI_SCHEDULE 
    BEFORE INSERT ON SCHEDULE 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tI_SUPPLIER_STOCK 
    BEFORE INSERT ON SUPPLIER_STOCK 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tI_SUPPLY_REQUEST 
    BEFORE INSERT ON SUPPLY_REQUEST 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_COOK_LOG 
    AFTER UPDATE ON COOK_LOG 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_EMPLOYEE 
    AFTER UPDATE ON EMPLOYEE 
    FOR EACH ROW 
-- ERwin Builtin Trigger
-- UPDATE trigger on EMPLOYEE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* EMPLOYEE  SCHEDULE on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00030dbb", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
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
  /* EMPLOYEE  RECIPE_CHEF on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="EmployeeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.EmployeeID <> :new.EmployeeID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_CHEF
      WHERE
        /*  %JoinFKPK(RECIPE_CHEF,:%Old," = "," AND") */
        RECIPE_CHEF.EmployeeID = :old.EmployeeID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update EMPLOYEE because RECIPE_CHEF exists.'
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



CREATE OR REPLACE TRIGGER tU_INGREDIENT 
    AFTER UPDATE ON INGREDIENT 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_INGREDIENT_STOCK 
    AFTER UPDATE ON INGREDIENT_STOCK 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_POSITION 
    AFTER UPDATE ON POSITION 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_RECIPE 
    AFTER UPDATE ON RECIPE 
    FOR EACH ROW 
-- ERwin Builtin Trigger
-- UPDATE trigger on RECIPE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* RECIPE  COOK_LOG on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0002eb42", PARENT_OWNER="", PARENT_TABLE="RECIPE"
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
  /* RECIPE  RECIPE_CHEF on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RecipeID <> :new.RecipeID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_CHEF
      WHERE
        /*  %JoinFKPK(RECIPE_CHEF,:%Old," = "," AND") */
        RECIPE_CHEF.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RECIPE because RECIPE_CHEF exists.'
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



CREATE OR REPLACE TRIGGER tU_RECIPE_CHEF 
    AFTER UPDATE ON RECIPE_DUTY 
    FOR EACH ROW 
-- ERwin Builtin Trigger
-- UPDATE trigger on RECIPE_CHEF 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RECIPE  RECIPE_CHEF on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001e8b0", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
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
      'Cannot update RECIPE_CHEF because RECIPE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* EMPLOYEE  RECIPE_CHEF on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="EMPLOYEE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_CHEF"
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
      'Cannot update RECIPE_CHEF because EMPLOYEE does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END; 
/



CREATE OR REPLACE TRIGGER tU_SCHEDULE 
    AFTER UPDATE ON SCHEDULE 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_SUPPLIER 
    AFTER UPDATE ON SUPPLIER 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_SUPPLIER_STOCK 
    AFTER UPDATE ON SUPPLIER_STOCK 
    FOR EACH ROW 
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



CREATE OR REPLACE TRIGGER tU_SUPPLY_REQUEST 
    AFTER UPDATE ON SUPPLY_REQUEST 
    FOR EACH ROW 
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




-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                            12
-- ALTER TABLE                             22
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                          23
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
