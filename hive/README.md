# Hive Excercise

## 1. Word Count
### Description
Explore a great novel ***Alice in Wonderland*** and find out the count for words.

### Purpose
* Table creation
* Problem solving
* Data Load
* Explore and Lateral View

### Steps
1. Download the data of the article is [here](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/wordcount/data/alice-in-wonderland.txt) (Right Click and Save)
2. Create an internal table called ***alice*** with column named ***row*** to hold the data
3. Load the data and explore the table to find the words having top 10 counts
4. Keep all word count result to another hive table
5. Keep all word count result to a file

## 2. Stock Analysis
### Description
Explore a stock market data file from Yahoo Finance.

### Purpose
* Problem solving
* CSV operation
* Data Load
* Query and UDF
* Static Partitions

### Steps
1. Download the data of the article is [here](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/stocks/data/stocks.csv) (Right Click and Save)
2. Create an internal table called ***stocks*** with column named ***ymd, price_open, price_high, price_low, price_close, volumn, price_adj_close*** with partition columns ***exchanger*** and ***symbol***
3. Load the data into partition with exchanger="NASDAQ", symbol="AAPL"
4. Load the data into partition with exchanger="NASDAQ", symbol="INTC"
5. Load the data into partition with exchanger="NYSE", symbol="GE"
6. Load the data into partition with exchanger="NYSE", symbol="IBM"
7. Count number of rows for each partition
8. Get max price_high for each partition
9. Drop data which is in partition with exchanger="NYSE"  
10. Drop partition which is in partition with exchanger="NYSE"  

## 3. Explore Movies
### Description
Explore a YouTube movie data to find out the most popular movie in the year.

### Purpose
* Aggregations functions
* Analytics functions
* TSV operation

### Steps
1. Download the data [here](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/movie/movies_data.tsv) (Right Click and Save)
2. Create an external table called ***movies*** with column named ***index:int, title:string, year:int, rating:double, duration:int*** on the tsv file on hdfs /tmp/data/movie
3. Explore the data find out movies with rating > 4 and give average ratings of all the movies in that subset for each year.
4. Explore the data find out the count of all movies as well as the count of movies with rating > 2
5. Explore the data find out the names of highest rated movie for each year. How about top 2?
6. Explore the data find out the number of days between movie release year and todays date for each movie

## 4. HR Management
### Description
Explore a sample human resource file to find out the employee information.

### Purpose
* Complex Data Type operation
* Problem solving
* CTAS, UNION, ORDER BY statement

### Steps
1. Download the data [here](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/employee/data/employee.txt) (Right Click and Save)
2. Create an external table called ***employee*** with column named ***name:string***, work_place:array<string>, sex_age:struct<sex:string,age:int>, skills_score:map<string,int>, depart_title:map<string,array<string>> *** on the piped file on hdfs /tmp/data/employee
3. Explore the table columns with complex data type.
4. Create a new table empoyee_export having columns, name, first_work_place, age
5. Export the data in empoyee_export to one piped flat file seperate columns by "|". Then, add header row as the 1st line with format HEADER|current timestamp|file_name and a trailer row as the last line with format TRAILER|current date|ROW COUNT. See below example,
```
HEADER|2017-10-15 18:34:62.345|employee_20171015.flat
Michael|Toronto|55
James|Beijing|34
Lily|Shenzhen|24
Robert|Montreal|32
TRAILER|2017-10-15|ROW COUNT: 4
```  
## 5. Yelp Review
### Description
Explore a place review file from Yelp.

### Purpose
* Partition insert
* Bucket tables, internal and external tables
* Joins and sampling

### Steps
1. Create review_db database and add comments, creator, and creation date.
2. Show above information once created
3. Create internal table called ***ratings*** with columns (userid INT,itemid INT, rating INT) and row seperate by tab.
4. Load the [ratings.tsv](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/reviews/data/ratings.tsv) into it.
5. Create external table called ***items*** with columns (itemid INT, category STRING) and row seperate by tab at hdfs location '/tmp/data/yelp'
6. Update [items.tsv](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/reviews/data/items.tsv) to the above folder
7. Join ***ratings*** and ***items*** table by column itemid, then show the first 30 rows.
8. Create table ***top_ratings*** (userid INT, itemid INT) and partitioned by column rating and row seperate by tab.
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
9. Load [top_ratings.tsv](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/reviews/data/top_ratings.tsv) to the ***top_ratings*** in partition rating = 5
10. Load [second_ratings.tsv](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/reviews/data/second_ratings.tsv) to the ***top_ratings*** in partition rating = 4
11. Create a bucket table called ***bucket_ratings*** with columns (userid int, itemid int,rating int) cluster by rating sorted by rating in normal order into 5 buckets and row seperate by tab.
12. Load [ratings.tsv](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/reviews/data/ratings.tsv)  into ***bucket_ratings***
13. Fetch sample record from ***bucket_ratings***

## 6. Restaurant Review
### Description
Explore a restaurant review file from Yelp.

### Purpose
* Problem solving
* Handling json with flexiable schema
* SQL query skills

### Steps
1. Create an external table called restaurants to refer the data retaurants.json [here](https://raw.githubusercontent.com/datafibers/spark_training/master/hive/retaurants/data/retaurants.json). Note, each the json file may have ***different*** keys
2. Write a query to show total number of restaurant which is in the borough Bronx.
3. Write a query to display the first 5 restaurant order by id which is in the borough Bronx, how about skip first 5 to show row 6 - 10?
4. Write a query to find the restaurants that achieved a score which is not smaller than 80 and no bigger than 100.
5. Write a query to find the restaurants that do not prepare any cuisine of 'American' and their grade score more than 70 
6. Write a query to find the restaurants which do not prepare any cuisine of 'American' and achieved a grade point 'A' not belongs to the borough Brooklyn.
7. Write a query to find the restaurants which belong to the borough Bronx and prepared either American or Chinese dish.

8. Write a query to find the restaurant Id, name, borough and cuisine for those restaurants which are not belonging to the borough Staten Island or Queens or Bronxor Brooklyn. 
9. Write a query to find the restaurant Id, name, borough and cuisine for those restaurants which prepared dish except 'American' and 'Chinees' or restaurant's name begins with letter 'Wil'.


