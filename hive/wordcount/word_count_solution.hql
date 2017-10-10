-- Create the table and load data
CREATE TABLE alice(row STRING);
LOAD DATA LOCAL INPATH "../../alice/*.txt" OVERWRITE INTO TABLE alice;

-- Explore data
SELECT
    EXPLODE(SPLIT(row,' ')) AS word 
FROM alice
LIMIT 10; 

-- Perform by the nest query 
SELECT
    TRIM(w.word) AS word,
    SUM(1) AS cnt 
FROM (
    SELECT 
        EXPLODE(SPLIT(row,' ')) AS word 
    FROM alice) as w 
WHERE
    word <> ''
GROUP BY w.word
ORDER BY cnt DESC 
LIMIT 10;


-- Perform by the LATERAL VIEW
SELECT
    TRIM(w.word) AS word,
    SUM(1) AS cnt 
FROM
    alice 
LATERAL VIEW
    EXPLODE(SPLIT(row,' ')) w AS word 
WHERE
    word <> ''
GROUP BY w.word
ORDER BY cnt DESC 
LIMIT 10;

-- Store Results in new Table
CREATE TABLE alice_wordcount
STORED AS TEXTFILE 
AS SELECT 
    TRIM(w.word) AS word,
    SUM(1) AS cnt 
FROM (
    SELECT 
        EXPLODE(SPLIT(row,' ')) AS word 
    FROM alice) as w 
WHERE
    word <> ''
GROUP BY w.word;

-- Store Results into File
INSERT OVERWRITE LOCAL DIRECTORY 'alice_wordcount'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
SELECT 
    TRIM(w.word) AS word,
    SUM(1) AS cnt 
FROM (
    SELECT 
        EXPLODE(SPLIT(row,' ')) AS word 
    FROM alice) as w 
WHERE
    word <> ''
GROUP BY w.word
ORDER BY cnt;
