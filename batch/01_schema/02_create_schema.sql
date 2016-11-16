CREATE TABLESPACE PosCook
DATAFILE 'C:\oracle\product\11.2.0\dbhome_1\database\oraslow_tablespace\PosCook.dbf'
SIZE 50M PERMANENT ONLINE;
 
CREATE TABLESPACE PosDefault
DATAFILE 'C:\oracle\product\11.2.0\dbhome_1\database\oraslow_tablespace\PosDefault.dbf'
SIZE 50M PERMANENT ONLINE;

CREATE TABLE POSITION
(
 	PositionID           INTEGER NOT NULL ,
 	Title                VARCHAR2(50) NULL ,
 	Salary               DECIMAL NULL ,
 	CONSTRAINT XPKPOSITION PRIMARY KEY (PositionID)
)
 PARTITION BY LIST(Title)
(
	PARTITION PosCook VALUES('Pantrycook', 'Soupandsaucecook', 'Broilercook')
 	TABLESPACE PosCook,
 	PARTITION PosDefault VALUES(DEFAULT)
 	TABLESPACE PosDefault
);

CREATE TABLE EMPLOYEE
(
	EmployeeID           INTEGER NOT NULL ,
	FirstName            VARCHAR(20) NULL ,
	LastName             VARCHAR2(20) NOT NULL ,
	DateContractFin      DATE NULL ,
	PositionID           INTEGER NOT NULL ,
	CONSTRAINT XPKEMPLOYEE PRIMARY KEY (EmployeeID) ,
 	CONSTRAINT R_19_P FOREIGN KEY (PositionID) REFERENCES POSITION (PositionID)
)
PARTITION BY REFERENCE(R_19_P);

CREATE TABLE SCHEDULE
(
	ScheduleID           INTEGER NOT NULL ,
	DayStart             INTEGER NULL ,
	EmployeeID           INTEGER NULL ,
	DateAccepted         DATE NULL ,
	DayFin               INTEGER NULL 
);

CREATE TABLE INGREDIENT_STOCK
(
	IngrStockID          INTEGER NOT NULL ,
	Title                VARCHAR(100) NOT NULL ,
	WeightAvail          DOUBLE PRECISION NOT NULL ,
	WeightMissing        DOUBLE PRECISION NOT NULL 
);

CREATE TABLE RECIPE
(
	RecipeID             INTEGER NOT NULL ,
	Title                VARCHAR2(50) NOT NULL ,
	RecipeFlow           VARCHAR2(500) NULL ,
	Price                DECIMAL NOT NULL ,
	DateCreated          DATE NOT NULL ,
	State                VARCHAR2(20) NULL 
);

CREATE TABLE RECIPE_DUTY
(
	EmployeeID           INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL ,
	DutyDescription      VARCHAR2(200) NULL 
);

CREATE TABLE INGREDIENT
(
	IngrStockID          INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL ,
	WeightRecp           DOUBLE PRECISION NOT NULL 
);

CREATE TABLE COOK_LOG
(
	CookLogID            INTEGER NOT NULL ,
	DateSold             DATE NOT NULL ,
	Amount               INTEGER NOT NULL ,
	RecipeID             INTEGER NOT NULL 
);

CREATE TABLESPACE ResIncome
DATAFILE 'C:\oracle\product\11.2.0\dbhome_1\database\oraslow_tablespace\ResIncome.dbf'
SIZE 50M PERMANENT ONLINE;

CREATE TABLESPACE ResOutcome
DATAFILE 'C:\oracle\product\11.2.0\dbhome_1\database\oraslow_tablespace\ResOutcome.dbf'
SIZE 50M PERMANENT ONLINE;

CREATE TABLE RESOURCES
(
	ResourceID           INTEGER NOT NULL ,
	DateReceived         DATE NULL ,
	Total                DECIMAL NULL ,
	Type                 VARCHAR2(20) NULL 
)
PARTITION BY LIST (Type)
(
	PARTITION ResIncome VALUES('PAYMENT', 'INVESTMENT')
	TABLESPACE ResIncome,
	PARTITION ResOutcome VALUES('TRANSFER')
	TABLESPACE ResOutcome
);

CREATE TABLE SUPPLIER
(
	SupplierID           INTEGER NOT NULL ,
	Title                VARCHAR2(100) NOT NULL ,
	Address              VARCHAR2(50) NULL ,
	Phone                VARCHAR2(20) NULL ,
	Reliability          INTEGER NOT NULL 
);

CREATE TABLE SUPPLIER_STOCK
(
	SupplierID           INTEGER NOT NULL ,
	Price                DECIMAL NOT NULL ,
	WeightAvail          DOUBLE PRECISION NOT NULL ,
	DateFreshSupply      DATE NULL ,
	IngrStockID          INTEGER NOT NULL 
);

CREATE TABLE SUPPLY_REQUEST
(
	RequestID            INTEGER NOT NULL ,
	DateRequest          DATE NOT NULL ,
	IngrStockID          INTEGER NOT NULL ,
	State                VARCHAR2(20) NOT NULL 
);