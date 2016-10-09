
CREATE TABLE AUTHOR
(
	AuthorID             INTEGER NOT NULL ,
	FirstName            VARCHAR(20) NULL ,
	LastName             VARCHAR2(20) NOT NULL ,
	DateEmployed         DATE NULL ,
	PositionID           INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKAUTHOR ON AUTHOR
(AuthorID   ASC);

ALTER TABLE AUTHOR
	ADD CONSTRAINT  XPKAUTHOR PRIMARY KEY (AuthorID);

CREATE TABLE CATEGORY
(
	CategoryID           INTEGER NOT NULL ,
	Title                VARCHAR2(20) NOT NULL ,
	DateCreated          DATE NULL 
);

CREATE UNIQUE INDEX XPKCATEGORY ON CATEGORY
(CategoryID   ASC);

ALTER TABLE CATEGORY
	ADD CONSTRAINT  XPKCATEGORY PRIMARY KEY (CategoryID);

CREATE TABLE ORDER_SUPPLY
(
	OrderID              INTEGER NOT NULL ,
	DateSupply           DATE NOT NULL 
);

CREATE UNIQUE INDEX XPKORDER_SUPPLY ON ORDER_SUPPLY
(OrderID   ASC);

ALTER TABLE ORDER_SUPPLY
	ADD CONSTRAINT  XPKORDER_SUPPLY PRIMARY KEY (OrderID);

CREATE TABLE POSITION
(
	Title                VARCHAR(20) NULL ,
	Salary               DECIMAL NULL ,
	PositionID           INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKPOSITION ON POSITION
(PositionID   ASC);

ALTER TABLE POSITION
	ADD CONSTRAINT  XPKPOSITION PRIMARY KEY (PositionID);

CREATE TABLE RAW_INGREDIENT
(
	RawIngrID            INTEGER NOT NULL ,
	Title                VARCHAR(20) NOT NULL ,
	WeightAvail          DOUBLE PRECISION NOT NULL ,
	OrderID              INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKRAW_INGREDIENT ON RAW_INGREDIENT
(RawIngrID   ASC);

ALTER TABLE RAW_INGREDIENT
	ADD CONSTRAINT  XPKRAW_INGREDIENT PRIMARY KEY (RawIngrID);

CREATE TABLE RECIPE
(
	RecipeID             INTEGER NOT NULL ,
	Title                VARCHAR2(20) NOT NULL ,
	RecipeFlow           VARCHAR2(300) NULL ,
	Price                DECIMAL NOT NULL ,
	DateCreated          DATE NOT NULL ,
	CategoryID           INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKRECIPE ON RECIPE
(RecipeID   ASC);

ALTER TABLE RECIPE
	ADD CONSTRAINT  XPKRECIPE PRIMARY KEY (RecipeID);

CREATE TABLE RECIPE_AUTHOR
(
	AuthorID             INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL 
);

CREATE UNIQUE INDEX XPKRECIPE_AUTHOR ON RECIPE_AUTHOR
(AuthorID   ASC,RecipeID   ASC);

ALTER TABLE RECIPE_AUTHOR
	ADD CONSTRAINT  XPKRECIPE_AUTHOR PRIMARY KEY (AuthorID,RecipeID);

CREATE TABLE INGREDIENT
(
	RawIngrID            INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL ,
	WeightRecp           DOUBLE PRECISION NOT NULL 
);

CREATE UNIQUE INDEX XPKINGREDIENT ON INGREDIENT
(RawIngrID   ASC,RecipeID   ASC);

ALTER TABLE INGREDIENT
	ADD CONSTRAINT  XPKINGREDIENT PRIMARY KEY (RawIngrID,RecipeID);

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

CREATE TABLE RAW_INGR_SUPL
(
	RawIngrID            INTEGER NOT NULL ,
	SupplierID           INTEGER NOT NULL ,
	Price                DECIMAL NOT NULL ,
	WeightAvail          DOUBLE PRECISION NOT NULL 
);

CREATE UNIQUE INDEX XPKRAW_INGR_SUPL ON RAW_INGR_SUPL
(RawIngrID   ASC,SupplierID   ASC);

ALTER TABLE RAW_INGR_SUPL
	ADD CONSTRAINT  XPKRAW_INGR_SUPL PRIMARY KEY (RawIngrID,SupplierID);

ALTER TABLE AUTHOR
	ADD (CONSTRAINT R_9 FOREIGN KEY (PositionID) REFERENCES POSITION (PositionID) ON DELETE SET NULL);

ALTER TABLE RAW_INGREDIENT
	ADD (CONSTRAINT R_13 FOREIGN KEY (OrderID) REFERENCES ORDER_SUPPLY (OrderID) ON DELETE SET NULL);

ALTER TABLE RECIPE
	ADD (CONSTRAINT R_12 FOREIGN KEY (CategoryID) REFERENCES CATEGORY (CategoryID) ON DELETE SET NULL);

ALTER TABLE RECIPE_AUTHOR
	ADD (CONSTRAINT R_7 FOREIGN KEY (AuthorID) REFERENCES AUTHOR (AuthorID));

ALTER TABLE RECIPE_AUTHOR
	ADD (CONSTRAINT R_8 FOREIGN KEY (RecipeID) REFERENCES RECIPE (RecipeID));

ALTER TABLE INGREDIENT
	ADD (CONSTRAINT R_4 FOREIGN KEY (RawIngrID) REFERENCES RAW_INGREDIENT (RawIngrID));

ALTER TABLE INGREDIENT
	ADD (CONSTRAINT R_5 FOREIGN KEY (RecipeID) REFERENCES RECIPE (RecipeID));

ALTER TABLE RAW_INGR_SUPL
	ADD (CONSTRAINT R_10 FOREIGN KEY (RawIngrID) REFERENCES RAW_INGREDIENT (RawIngrID));

ALTER TABLE RAW_INGR_SUPL
	ADD (CONSTRAINT R_11 FOREIGN KEY (SupplierID) REFERENCES SUPPLIER (SupplierID));

CREATE  TRIGGER  tD_AUTHOR AFTER DELETE ON AUTHOR for each row
-- ERwin Builtin Trigger
-- DELETE trigger on AUTHOR 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* AUTHOR  RECIPE_AUTHOR on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d9fa", PARENT_OWNER="", PARENT_TABLE="AUTHOR"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="AuthorID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_AUTHOR
      WHERE
        /*  %JoinFKPK(RECIPE_AUTHOR,:%Old," = "," AND") */
        RECIPE_AUTHOR.AuthorID = :old.AuthorID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete AUTHOR because RECIPE_AUTHOR exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_AUTHOR BEFORE INSERT ON AUTHOR for each row
-- ERwin Builtin Trigger
-- INSERT trigger on AUTHOR 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* POSITION  AUTHOR on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000d6f2", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="PositionID" */
    UPDATE AUTHOR
      SET
        /* %SetFK(AUTHOR,NULL) */
        AUTHOR.PositionID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM POSITION
            WHERE
              /* %JoinFKPK(:%New,POSITION," = "," AND") */
              :new.PositionID = POSITION.PositionID
        ) 
        /* %JoinPKPK(AUTHOR,:%New," = "," AND") */
         and AUTHOR.AuthorID = :new.AuthorID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_AUTHOR AFTER UPDATE ON AUTHOR for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on AUTHOR 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* AUTHOR  RECIPE_AUTHOR on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000211e0", PARENT_OWNER="", PARENT_TABLE="AUTHOR"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="AuthorID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.AuthorID <> :new.AuthorID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_AUTHOR
      WHERE
        /*  %JoinFKPK(RECIPE_AUTHOR,:%Old," = "," AND") */
        RECIPE_AUTHOR.AuthorID = :old.AuthorID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update AUTHOR because RECIPE_AUTHOR exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* POSITION  AUTHOR on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="PositionID" */
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
      'Cannot update AUTHOR because POSITION does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_CATEGORY AFTER DELETE ON CATEGORY for each row
-- ERwin Builtin Trigger
-- DELETE trigger on CATEGORY 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* CATEGORY  RECIPE on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000a476", PARENT_OWNER="", PARENT_TABLE="CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="RECIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="CategoryID" */
    UPDATE RECIPE
      SET
        /* %SetFK(RECIPE,NULL) */
        RECIPE.CategoryID = NULL
      WHERE
        /* %JoinFKPK(RECIPE,:%Old," = "," AND") */
        RECIPE.CategoryID = :old.CategoryID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_CATEGORY AFTER UPDATE ON CATEGORY for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on CATEGORY 
DECLARE NUMROWS INTEGER;
BEGIN
  /* CATEGORY  RECIPE on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000d47d", PARENT_OWNER="", PARENT_TABLE="CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="RECIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="CategoryID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.CategoryID <> :new.CategoryID
  THEN
    UPDATE RECIPE
      SET
        /* %SetFK(RECIPE,NULL) */
        RECIPE.CategoryID = NULL
      WHERE
        /* %JoinFKPK(RECIPE,:%Old," = ",",") */
        RECIPE.CategoryID = :old.CategoryID;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_ORDER_SUPPLY AFTER DELETE ON ORDER_SUPPLY for each row
-- ERwin Builtin Trigger
-- DELETE trigger on ORDER_SUPPLY 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* ORDER_SUPPLY  RAW_INGREDIENT on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000d1bd", PARENT_OWNER="", PARENT_TABLE="ORDER_SUPPLY"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OrderID" */
    UPDATE RAW_INGREDIENT
      SET
        /* %SetFK(RAW_INGREDIENT,NULL) */
        RAW_INGREDIENT.OrderID = NULL
      WHERE
        /* %JoinFKPK(RAW_INGREDIENT,:%Old," = "," AND") */
        RAW_INGREDIENT.OrderID = :old.OrderID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_ORDER_SUPPLY AFTER UPDATE ON ORDER_SUPPLY for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on ORDER_SUPPLY 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ORDER_SUPPLY  RAW_INGREDIENT on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000f3ca", PARENT_OWNER="", PARENT_TABLE="ORDER_SUPPLY"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OrderID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.OrderID <> :new.OrderID
  THEN
    UPDATE RAW_INGREDIENT
      SET
        /* %SetFK(RAW_INGREDIENT,NULL) */
        RAW_INGREDIENT.OrderID = NULL
      WHERE
        /* %JoinFKPK(RAW_INGREDIENT,:%Old," = ",",") */
        RAW_INGREDIENT.OrderID = :old.OrderID;
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
    /* POSITION  AUTHOR on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000a6f8", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="PositionID" */
    UPDATE AUTHOR
      SET
        /* %SetFK(AUTHOR,NULL) */
        AUTHOR.PositionID = NULL
      WHERE
        /* %JoinFKPK(AUTHOR,:%Old," = "," AND") */
        AUTHOR.PositionID = :old.PositionID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_POSITION AFTER UPDATE ON POSITION for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on POSITION 
DECLARE NUMROWS INTEGER;
BEGIN
  /* POSITION  AUTHOR on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000cbe3", PARENT_OWNER="", PARENT_TABLE="POSITION"
    CHILD_OWNER="", CHILD_TABLE="AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="PositionID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.PositionID <> :new.PositionID
  THEN
    UPDATE AUTHOR
      SET
        /* %SetFK(AUTHOR,NULL) */
        AUTHOR.PositionID = NULL
      WHERE
        /* %JoinFKPK(AUTHOR,:%Old," = ",",") */
        AUTHOR.PositionID = :old.PositionID;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_RAW_INGREDIENT AFTER DELETE ON RAW_INGREDIENT for each row
-- ERwin Builtin Trigger
-- DELETE trigger on RAW_INGREDIENT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RAW_INGREDIENT  RAW_INGR_SUPL on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001de69", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="RawIngrID" */
    SELECT count(*) INTO NUMROWS
      FROM RAW_INGR_SUPL
      WHERE
        /*  %JoinFKPK(RAW_INGR_SUPL,:%Old," = "," AND") */
        RAW_INGR_SUPL.RawIngrID = :old.RawIngrID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RAW_INGREDIENT because RAW_INGR_SUPL exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* RAW_INGREDIENT  INGREDIENT on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="RawIngrID" */
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT
      WHERE
        /*  %JoinFKPK(INGREDIENT,:%Old," = "," AND") */
        INGREDIENT.RawIngrID = :old.RawIngrID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RAW_INGREDIENT because INGREDIENT exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_RAW_INGREDIENT BEFORE INSERT ON RAW_INGREDIENT for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RAW_INGREDIENT 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* ORDER_SUPPLY  RAW_INGREDIENT on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00011291", PARENT_OWNER="", PARENT_TABLE="ORDER_SUPPLY"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OrderID" */
    UPDATE RAW_INGREDIENT
      SET
        /* %SetFK(RAW_INGREDIENT,NULL) */
        RAW_INGREDIENT.OrderID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM ORDER_SUPPLY
            WHERE
              /* %JoinFKPK(:%New,ORDER_SUPPLY," = "," AND") */
              :new.OrderID = ORDER_SUPPLY.OrderID
        ) 
        /* %JoinPKPK(RAW_INGREDIENT,:%New," = "," AND") */
         and RAW_INGREDIENT.RawIngrID = :new.RawIngrID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RAW_INGREDIENT AFTER UPDATE ON RAW_INGREDIENT for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RAW_INGREDIENT 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RAW_INGREDIENT  RAW_INGR_SUPL on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="000354f0", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="RawIngrID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RawIngrID <> :new.RawIngrID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RAW_INGR_SUPL
      WHERE
        /*  %JoinFKPK(RAW_INGR_SUPL,:%Old," = "," AND") */
        RAW_INGR_SUPL.RawIngrID = :old.RawIngrID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RAW_INGREDIENT because RAW_INGR_SUPL exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* RAW_INGREDIENT  INGREDIENT on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="RawIngrID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RawIngrID <> :new.RawIngrID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM INGREDIENT
      WHERE
        /*  %JoinFKPK(INGREDIENT,:%Old," = "," AND") */
        INGREDIENT.RawIngrID = :old.RawIngrID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RAW_INGREDIENT because INGREDIENT exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* ORDER_SUPPLY  RAW_INGREDIENT on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ORDER_SUPPLY"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OrderID" */
  SELECT count(*) INTO NUMROWS
    FROM ORDER_SUPPLY
    WHERE
      /* %JoinFKPK(:%New,ORDER_SUPPLY," = "," AND") */
      :new.OrderID = ORDER_SUPPLY.OrderID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.OrderID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RAW_INGREDIENT because ORDER_SUPPLY does not exist.'
    );
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
    /* RECIPE  RECIPE_AUTHOR on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001ca73", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_AUTHOR
      WHERE
        /*  %JoinFKPK(RECIPE_AUTHOR,:%Old," = "," AND") */
        RECIPE_AUTHOR.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete RECIPE because RECIPE_AUTHOR exists.'
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

CREATE  TRIGGER tI_RECIPE BEFORE INSERT ON RECIPE for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RECIPE 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* CATEGORY  RECIPE on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0000dc63", PARENT_OWNER="", PARENT_TABLE="CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="RECIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="CategoryID" */
    UPDATE RECIPE
      SET
        /* %SetFK(RECIPE,NULL) */
        RECIPE.CategoryID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM CATEGORY
            WHERE
              /* %JoinFKPK(:%New,CATEGORY," = "," AND") */
              :new.CategoryID = CATEGORY.CategoryID
        ) 
        /* %JoinPKPK(RECIPE,:%New," = "," AND") */
         and RECIPE.RecipeID = :new.RecipeID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RECIPE AFTER UPDATE ON RECIPE for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RECIPE 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RECIPE  RECIPE_AUTHOR on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00032728", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="RecipeID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.RecipeID <> :new.RecipeID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RECIPE_AUTHOR
      WHERE
        /*  %JoinFKPK(RECIPE_AUTHOR,:%Old," = "," AND") */
        RECIPE_AUTHOR.RecipeID = :old.RecipeID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update RECIPE because RECIPE_AUTHOR exists.'
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

  /* ERwin Builtin Trigger */
  /* CATEGORY  RECIPE on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="CATEGORY"
    CHILD_OWNER="", CHILD_TABLE="RECIPE"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="CategoryID" */
  SELECT count(*) INTO NUMROWS
    FROM CATEGORY
    WHERE
      /* %JoinFKPK(:%New,CATEGORY," = "," AND") */
      :new.CategoryID = CATEGORY.CategoryID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.CategoryID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RECIPE because CATEGORY does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_RECIPE_AUTHOR BEFORE INSERT ON RECIPE_AUTHOR for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RECIPE_AUTHOR 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* RECIPE  RECIPE_AUTHOR on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001e8b7", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
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
        'Cannot insert RECIPE_AUTHOR because RECIPE does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* AUTHOR  RECIPE_AUTHOR on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AUTHOR"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="AuthorID" */
    SELECT count(*) INTO NUMROWS
      FROM AUTHOR
      WHERE
        /* %JoinFKPK(:%New,AUTHOR," = "," AND") */
        :new.AuthorID = AUTHOR.AuthorID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert RECIPE_AUTHOR because AUTHOR does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RECIPE_AUTHOR AFTER UPDATE ON RECIPE_AUTHOR for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RECIPE_AUTHOR 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* RECIPE  RECIPE_AUTHOR on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001ef72", PARENT_OWNER="", PARENT_TABLE="RECIPE"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
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
      'Cannot update RECIPE_AUTHOR because RECIPE does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* AUTHOR  RECIPE_AUTHOR on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AUTHOR"
    CHILD_OWNER="", CHILD_TABLE="RECIPE_AUTHOR"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="AuthorID" */
  SELECT count(*) INTO NUMROWS
    FROM AUTHOR
    WHERE
      /* %JoinFKPK(:%New,AUTHOR," = "," AND") */
      :new.AuthorID = AUTHOR.AuthorID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RECIPE_AUTHOR because AUTHOR does not exist.'
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
    /* ERWIN_RELATION:CHECKSUM="0001eaed", PARENT_OWNER="", PARENT_TABLE="RECIPE"
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
    /* RAW_INGREDIENT  INGREDIENT on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="RawIngrID" */
    SELECT count(*) INTO NUMROWS
      FROM RAW_INGREDIENT
      WHERE
        /* %JoinFKPK(:%New,RAW_INGREDIENT," = "," AND") */
        :new.RawIngrID = RAW_INGREDIENT.RawIngrID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert INGREDIENT because RAW_INGREDIENT does not exist.'
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
  /* ERWIN_RELATION:CHECKSUM="0001f86b", PARENT_OWNER="", PARENT_TABLE="RECIPE"
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
  /* RAW_INGREDIENT  INGREDIENT on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="INGREDIENT"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="RawIngrID" */
  SELECT count(*) INTO NUMROWS
    FROM RAW_INGREDIENT
    WHERE
      /* %JoinFKPK(:%New,RAW_INGREDIENT," = "," AND") */
      :new.RawIngrID = RAW_INGREDIENT.RawIngrID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update INGREDIENT because RAW_INGREDIENT does not exist.'
    );
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
    /* SUPPLIER  RAW_INGR_SUPL on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000ddcb", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="SupplierID" */
    SELECT count(*) INTO NUMROWS
      FROM RAW_INGR_SUPL
      WHERE
        /*  %JoinFKPK(RAW_INGR_SUPL,:%Old," = "," AND") */
        RAW_INGR_SUPL.SupplierID = :old.SupplierID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete SUPPLIER because RAW_INGR_SUPL exists.'
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
  /* SUPPLIER  RAW_INGR_SUPL on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00010314", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="SupplierID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.SupplierID <> :new.SupplierID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM RAW_INGR_SUPL
      WHERE
        /*  %JoinFKPK(RAW_INGR_SUPL,:%Old," = "," AND") */
        RAW_INGR_SUPL.SupplierID = :old.SupplierID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update SUPPLIER because RAW_INGR_SUPL exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_RAW_INGR_SUPL BEFORE INSERT ON RAW_INGR_SUPL for each row
-- ERwin Builtin Trigger
-- INSERT trigger on RAW_INGR_SUPL 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* SUPPLIER  RAW_INGR_SUPL on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00020a1b", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
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
        'Cannot insert RAW_INGR_SUPL because SUPPLIER does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* RAW_INGREDIENT  RAW_INGR_SUPL on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="RawIngrID" */
    SELECT count(*) INTO NUMROWS
      FROM RAW_INGREDIENT
      WHERE
        /* %JoinFKPK(:%New,RAW_INGREDIENT," = "," AND") */
        :new.RawIngrID = RAW_INGREDIENT.RawIngrID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert RAW_INGR_SUPL because RAW_INGREDIENT does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_RAW_INGR_SUPL AFTER UPDATE ON RAW_INGR_SUPL for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on RAW_INGR_SUPL 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* SUPPLIER  RAW_INGR_SUPL on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="000203e2", PARENT_OWNER="", PARENT_TABLE="SUPPLIER"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
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
      'Cannot update RAW_INGR_SUPL because SUPPLIER does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* RAW_INGREDIENT  RAW_INGR_SUPL on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="RAW_INGREDIENT"
    CHILD_OWNER="", CHILD_TABLE="RAW_INGR_SUPL"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="RawIngrID" */
  SELECT count(*) INTO NUMROWS
    FROM RAW_INGREDIENT
    WHERE
      /* %JoinFKPK(:%New,RAW_INGREDIENT," = "," AND") */
      :new.RawIngrID = RAW_INGREDIENT.RawIngrID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update RAW_INGR_SUPL because RAW_INGREDIENT does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/

