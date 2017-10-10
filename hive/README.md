# Hive Excercise

## 1. Word Count 
### Purpose
* Table creation
* Problem solving
* Data Load
* Explore and Lateral View

### Steps
1. Download the data of the article is [here](https://github.com/datafibers/spark_training/blob/master/hive/wordcount/data/alice-in-wonderland.txt) (Right Click and Save)
2. Create an internal table called ***alice*** with column named ***row*** to hold the data
3. Load the data and explore the table to find the words having top 10 counts
4. Keep all word count result to another hive table
5. Keep all word count result to a file

## 2. Stock Analysis
### Purpose
* Problem solving
* CSV operation
* Data Load
* Query and UDF
* Static Partitions

### Steps
1. Download the data of the article is [here](https://github.com/datafibers/spark_training/blob/master/hive/stock/data/stocks.csv.txt) (Right Click and Save)
2. Create an internal table called ***stocks*** with column named ***ymd, price_open, price_high, price_low, price_close, volumn, price_adj_close*** with partition columns ***exchanger*** and ***symbol***
3. Load the data into partition with exchanger="NASDAQ", symbol="AAPL"
4. Load the data into partition with exchanger="NASDAQ", symbol="INTC"
5. Load the data into partition with exchanger="NYSE", symbol="GE"
6. Load the data into partition with exchanger="NYSE", symbol="IBM"
7. Count number of rows for each partition
8. Get max price_high for each partition
9. Drop data which is in partition with exchanger="NYSE"  
10. Drop partition which is in partition with exchanger="NYSE"  
