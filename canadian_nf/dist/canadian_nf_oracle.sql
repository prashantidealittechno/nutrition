-- ======================================================================
-- Canadian Nutrient File (CNF), 2015 (http://www.healthcanada.gc.ca/cnf)
-- This file was generated by http://github.com/m5n/nutriana
-- Run this SQL with an account that has admin priviledges, e.g.: sqlplus "/as sysdba" < canadian_nf_oracle.sql
-- ======================================================================

-- This script assumes you've already set up a database when you installed Oracle and that $ORACLE_HOME/bin is in your path.

-- Needed since Oracle 12c.
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

BEGIN EXECUTE IMMEDIATE 'CREATE USER food IDENTIFIED BY food'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -01920 THEN RAISE; END IF; END;
/

-- Needed since Oracle 12c.
ALTER USER food QUOTA UNLIMITED ON USERS;

-- Needed since Oracle 12c.
ALTER SESSION SET "_ORACLE_SCRIPT"=FALSE;

GRANT CONNECT, RESOURCE TO food;
CONNECT food/food;

-- This is a principal file. It stores information about each food in the database. It contains a description of each food in English and French as well as dates and comments.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FOOD_NAME CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE FOOD_NAME (
    FoodID NUMBER(8) NOT NULL,   -- Sequential number generated by the database identifying the food records. This is the primary key.
    FoodCode NUMBER(8) NOT NULL,   -- Identifier code for the foods. In the 2007b version this was the FD_C
    FoodGroupID NUMBER(15) NOT NULL,   -- Sequential number generated by the database for the food groups
    FoodSourceID NUMBER(15) NOT NULL,   -- Sequential number generated by the database for the food sources.
    FoodDescription VARCHAR2(255) NOT NULL,   -- Complete food name in English
    FoodDescriptionF VARCHAR2(255) NOT NULL,   -- Complete food name in French
    FoodDateOfEntry date NOT NULL,   -- Date the food name data was entered into the database
    FoodDateOfPublication date,   -- Date the food name data was originally published
    CountryCode NUMBER(20),   -- Corresponds to the USDA NDB code
    ScientificName VARCHAR2(100)   -- Scientific name of the food
);

-- This is the main file. It uses information (by linking) from the FOOD NAME table (among others) to identify which nutrients and amounts are recorded for that food.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTRIENT_AMOUNT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE NUTRIENT_AMOUNT (
    FoodID NUMBER(8) NOT NULL,   -- Sequential number generated by the database identifying the food records.
    NutrientID NUMBER(4) NOT NULL,   -- Sequential number generated by the database for the nutrient names
    NutrientValue NUMBER(12, 5) NOT NULL,   -- Mean value in 100g, edible portion. (The number of decimal places does not reflect the accuracy of the data.).
    StandardError NUMBER(8, 4),   -- Standard error of the mean
    NumberOfObservations NUMBER(6),   -- Number of samples
    NutrientSourceID NUMBER(15) NOT NULL,   -- Identifier code generated by the database for the nutrient source
    NutrientDateOfEntry date NOT NULL   -- Date the data was entered into the database
);

-- This is a principal file. This file contains portion size conversion factors. The conversion factors are food specific multipliers by which the nutrient values for each food may be multiplied to give the nutrients in described portions.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CONVERSION_FACTOR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE CONVERSION_FACTOR (
    FoodID NUMBER(8) NOT NULL,   -- Sequential number generated by the database identifying the food records.
    MeasureID NUMBER(10) NOT NULL,   -- Sequential number generated by the database for the measure descriptions
    ConversionFactorValue NUMBER(10) NOT NULL,   -- The factor by which one would multiply the nutrient per 100g to obtain nutrient amounts per the measure described (the weight of that food in the measure described divided by 100)
    ConvFactorDateOfEntry date NOT NULL   -- Date the data was entered into the database
);

-- This is a principal file. This file contains the percent of refuse, or inedible portion, for each food.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE REFUSE_AMOUNT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE REFUSE_AMOUNT (
    FoodID NUMBER(8) NOT NULL,   -- Sequential number generated by the database identifying the food records.
    RefuseID NUMBER(10) NOT NULL,   -- Sequential number generated by the database for the refuse descriptions
    RefuseAmount NUMBER(9, 5) NOT NULL,   -- Percent refuse
    RefuseDateOfEntry date NOT NULL   -- Date the data was entered into the database
);

-- This is a principal file. This file contains the yield from refuse and/or cooking losses assigned to certain foods. These yields are most often used for food inventory purposes.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE YIELD_AMOUNT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE YIELD_AMOUNT (
    FoodID NUMBER(8) NOT NULL,   -- Sequential number generated by the database identifying the food records.
    YieldID NUMBER(10) NOT NULL,   -- Sequential number generated by the database for the yield descriptions
    YieldAmount NUMBER(9, 5) NOT NULL,   -- Yield from refuse and/or cooking losses
    YieldDateOfEntry date NOT NULL   -- Date the data was entered into the database
);

-- This file is a support or "list" table that is used to link to the FOOD NAME table. It contains a list of 23 different group headings (in English and French) based on similar characteristics of the foods.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FOOD_GROUP CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE FOOD_GROUP (
    FoodGroupID NUMBER(15) NOT NULL,   -- Sequential number generated by the database for the food groups
    FoodGroupCode NUMBER(15) NOT NULL,   -- Identifier code for the Canadian Nutrient File food groups. There are 23 different CNF food groups
    FoodGroupName VARCHAR2(200) NOT NULL,   -- Food group name in English
    FoodGroupNameF VARCHAR2(200) NOT NULL   -- Food group name in French
);

-- This file is a support or "list" table that is used to link to the FOOD NAME table. It contains a list of several food sources (in English and French) that foods can be grouped on.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FOOD_SOURCE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE FOOD_SOURCE (
    FoodSourceID NUMBER(15) NOT NULL,   -- Sequential number generated by the database for the food sources
    FoodSourceCode NUMBER(15) NOT NULL,   -- Identifier code for the food sources. Food sources give an indication as to Canadian content
    FoodSourceDescription VARCHAR2(200) NOT NULL,   -- Food Source description in English
    FoodSourceDescriptionF VARCHAR2(200) NOT NULL   -- Food Source description in French
);

-- This file is a support or "list" table that contains the list of nutrients (in English and French) used in the NT_AMT file, with which it is linked.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTRIENT_NAME CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE NUTRIENT_NAME (
    NutrientID NUMBER(4) NOT NULL,   -- Sequential number generated by the database for the nutrient names
    NutrientCode NUMBER(15) NOT NULL,   -- Identifier code for nutrient name descriptions
    NutrientSymbol VARCHAR2(10) NOT NULL,   -- Nutrient symbol or abbreviation of the nutrients. They may differ from international nomenclature.
    NutrientUnit VARCHAR2(8) NOT NULL,   -- Unit of measure (e.g., mg, g, mcg)
    NutrientName VARCHAR2(200) NOT NULL,   -- Nutrient name in English
    NutrientNameF VARCHAR2(200) NOT NULL,   -- Nutrient name in French
    Tagname VARCHAR2(20),   -- International Network of Food Data Systems (INFOODS) Tagnames. A unique Abbreviation for a food component developed by INFOODS to aid in the interchange of data.
    NutrientDecimals NUMBER(15) NOT NULL   -- Number of decimal places used in the rounding of the nutrient value
);

-- This file is a support or "list" table that is used to link to the NUTRIENT AMOUNT file. It contains a list of several sources and/or types of nutrient data (in English and French).
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NUTRIENT_SOURCE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE NUTRIENT_SOURCE (
    NutrientSourceID NUMBER(15) NOT NULL,   -- Sequential number generated by the database for the nutrient sources
    NutrientSourceCode NUMBER(15) NOT NULL,   -- Identifier code for nutrient source descriptions.
    NutrientSourceDescription VARCHAR2(200) NOT NULL,   -- Nutrient source description in English
    NutrientSourceDescriptionF VARCHAR2(200) NOT NULL   -- Nutrient source description in French
);

-- This file is a support or "list" table that is used to link to the CONV FAC table. It contains a list of measures (in English and French).
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MEASURE_NAME CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE MEASURE_NAME (
    MeasureID NUMBER(10) NOT NULL,   -- Sequential number generated by the database for the measure descriptions
    MeasureName VARCHAR2(200) NOT NULL,   -- Measure description in English
    MeasureNameF VARCHAR2(200) NOT NULL   -- Measure description in French
);

-- This file is a support or "list" table that is used to link to the REFUSE table. It contains a list of refuse types.
BEGIN EXECUTE IMMEDIATE 'DROP TABLE REFUSE_NAME CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE REFUSE_NAME (
    RefuseID NUMBER(10) NOT NULL,   -- Sequential number generated by the database for the refuse descriptions
    RefuseName VARCHAR2(200) NOT NULL,   -- Refuse description in English
    RefuseNameF VARCHAR2(200) NOT NULL   -- Refuse description in French
);

-- This file is a support or "list" table that is used to link to the YIELD table. It contains a list of yield types or yield descriptions (in English and French).
BEGIN EXECUTE IMMEDIATE 'DROP TABLE YIELD_NAME CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -00942 THEN RAISE; END IF; END;
/
CREATE TABLE YIELD_NAME (
    YieldID NUMBER(10) NOT NULL,   -- Sequential number generated by the database for the yield descriptions
    YieldName VARCHAR2(200) NOT NULL,   -- Yield description in English
    YieldNameF VARCHAR2(200) NOT NULL   -- Yield description in French
);

-- Load data into FOOD_NAME
HOST sqlldr food/food CONTROL=./sqlldr/FOOD_NAME.ctl LOG=./sqlldr/FOOD_NAME.log;
-- Assert all 5690 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM FOOD_NAME);
DELETE FROM tmp WHERE c = 5690;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into NUTRIENT_AMOUNT
HOST sqlldr food/food CONTROL=./sqlldr/NUTRIENT_AMOUNT.ctl LOG=./sqlldr/NUTRIENT_AMOUNT.log;
-- Assert all 524674 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM NUTRIENT_AMOUNT);
DELETE FROM tmp WHERE c = 524674;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into CONVERSION_FACTOR
HOST sqlldr food/food CONTROL=./sqlldr/CONVERSION_FACTOR.ctl LOG=./sqlldr/CONVERSION_FACTOR.log;
-- Assert all 19505 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM CONVERSION_FACTOR);
DELETE FROM tmp WHERE c = 19505;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into REFUSE_AMOUNT
HOST sqlldr food/food CONTROL=./sqlldr/REFUSE_AMOUNT.ctl LOG=./sqlldr/REFUSE_AMOUNT.log;
-- Assert all 6897 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM REFUSE_AMOUNT);
DELETE FROM tmp WHERE c = 6897;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into YIELD_AMOUNT
HOST sqlldr food/food CONTROL=./sqlldr/YIELD_AMOUNT.ctl LOG=./sqlldr/YIELD_AMOUNT.log;
-- Assert all 1426 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM YIELD_AMOUNT);
DELETE FROM tmp WHERE c = 1426;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into FOOD_GROUP
HOST sqlldr food/food CONTROL=./sqlldr/FOOD_GROUP.ctl LOG=./sqlldr/FOOD_GROUP.log;
-- Assert all 23 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM FOOD_GROUP);
DELETE FROM tmp WHERE c = 23;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into FOOD_SOURCE
HOST sqlldr food/food CONTROL=./sqlldr/FOOD_SOURCE.ctl LOG=./sqlldr/FOOD_SOURCE.log;
-- Assert all 16 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM FOOD_SOURCE);
DELETE FROM tmp WHERE c = 16;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into NUTRIENT_NAME
HOST sqlldr food/food CONTROL=./sqlldr/NUTRIENT_NAME.ctl LOG=./sqlldr/NUTRIENT_NAME.log;
-- Assert all 152 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM NUTRIENT_NAME);
DELETE FROM tmp WHERE c = 152;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into NUTRIENT_SOURCE
HOST sqlldr food/food CONTROL=./sqlldr/NUTRIENT_SOURCE.ctl LOG=./sqlldr/NUTRIENT_SOURCE.log;
-- Assert all 20 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM NUTRIENT_SOURCE);
DELETE FROM tmp WHERE c = 20;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into MEASURE_NAME
HOST sqlldr food/food CONTROL=./sqlldr/MEASURE_NAME.ctl LOG=./sqlldr/MEASURE_NAME.log;
-- Assert all 1177 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM MEASURE_NAME);
DELETE FROM tmp WHERE c = 1177;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into REFUSE_NAME
HOST sqlldr food/food CONTROL=./sqlldr/REFUSE_NAME.ctl LOG=./sqlldr/REFUSE_NAME.log;
-- Assert all 150 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM REFUSE_NAME);
DELETE FROM tmp WHERE c = 150;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Load data into YIELD_NAME
HOST sqlldr food/food CONTROL=./sqlldr/YIELD_NAME.ctl LOG=./sqlldr/YIELD_NAME.log;
-- Assert all 79 records were loaded
CREATE TABLE tmp (c NUMBER PRIMARY KEY);
INSERT INTO tmp (c) VALUES (2);
INSERT INTO tmp (SELECT COUNT(*) FROM YIELD_NAME);
DELETE FROM tmp WHERE c = 79;
INSERT INTO tmp (SELECT COUNT(*) FROM tmp);
DROP TABLE tmp;

-- Correct data inconsistencies, if any

-- Add primary keys
ALTER TABLE FOOD_NAME ADD PRIMARY KEY (FoodID);
ALTER TABLE FOOD_GROUP ADD PRIMARY KEY (FoodGroupID);
ALTER TABLE FOOD_SOURCE ADD PRIMARY KEY (FoodSourceID);
ALTER TABLE NUTRIENT_NAME ADD PRIMARY KEY (NutrientID);
ALTER TABLE NUTRIENT_SOURCE ADD PRIMARY KEY (NutrientSourceID);
ALTER TABLE MEASURE_NAME ADD PRIMARY KEY (MeasureID);
ALTER TABLE REFUSE_NAME ADD PRIMARY KEY (RefuseID);
ALTER TABLE YIELD_NAME ADD PRIMARY KEY (YieldID);

-- Add foreign keys
ALTER TABLE FOOD_NAME ADD FOREIGN KEY (FoodGroupID) REFERENCES FOOD_GROUP(FoodGroupID);
ALTER TABLE FOOD_NAME ADD FOREIGN KEY (FoodSourceID) REFERENCES FOOD_SOURCE(FoodSourceID);
ALTER TABLE NUTRIENT_AMOUNT ADD FOREIGN KEY (FoodID) REFERENCES FOOD_NAME(FoodID);
ALTER TABLE NUTRIENT_AMOUNT ADD FOREIGN KEY (NutrientID) REFERENCES NUTRIENT_NAME(NutrientID);
ALTER TABLE NUTRIENT_AMOUNT ADD FOREIGN KEY (NutrientSourceID) REFERENCES NUTRIENT_SOURCE(NutrientSourceID);
ALTER TABLE CONVERSION_FACTOR ADD FOREIGN KEY (FoodID) REFERENCES FOOD_NAME(FoodID);
ALTER TABLE CONVERSION_FACTOR ADD FOREIGN KEY (MeasureID) REFERENCES MEASURE_NAME(MeasureID);
ALTER TABLE REFUSE_AMOUNT ADD FOREIGN KEY (FoodID) REFERENCES FOOD_NAME(FoodID);
ALTER TABLE REFUSE_AMOUNT ADD FOREIGN KEY (RefuseID) REFERENCES REFUSE_NAME(RefuseID);
ALTER TABLE YIELD_AMOUNT ADD FOREIGN KEY (FoodID) REFERENCES FOOD_NAME(FoodID);
ALTER TABLE YIELD_AMOUNT ADD FOREIGN KEY (YieldID) REFERENCES YIELD_NAME(YieldID);
