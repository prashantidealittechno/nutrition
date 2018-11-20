OPTIONS (DIRECT=TRUE, PARALLEL=TRUE, SKIP=1)
LOAD DATA
    INFILE './data.processed/MEASURE_NAME.csv.trimmed'
    APPEND
    INTO TABLE MEASURE_NAME
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    TRAILING NULLCOLS
    (MeasureID INTEGER EXTERNAL, MeasureName CHAR, MeasureNameF CHAR)