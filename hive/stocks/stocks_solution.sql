# Create table stock
CREATE TABLE if not EXISTS stocks(
ymd date,
price_open FLOAT ,
price_high FLOAT ,
price_low FLOAT ,
price_close float,
volume int,
price_adj_close FLOAT
)partitioned by (exchanger string, symbol string)
row format delimited fields terminated by ',';

# Load the data
LOAD DATA LOCAL INPATH 'data/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NASDAQ",symbol="AAPL");

# Check the partition tables
show partitions stocks;
+-------------------------------+--+
|           partition           |
+-------------------------------+--+
| exchanger=NASDAQ/symbol=AAPL  |
+-------------------------------+--+

# Spoof more data
LOAD DATA LOCAL INPATH 'data/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NASDAQ",symbol="INTC");
LOAD DATA LOCAL INPATH 'data/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NYSE",symbol="GE");
LOAD DATA LOCAL INPATH 'data/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NYSE",symbol="IBM");

# Explore partition table
select * from stocks where exchanger='NASDAQ' and symbol='AAPL' limit 10 ;

# Count number of rows for each partition
select exchanger,symbol,count(*) from stocks group by exchanger,symbol;

# Get max price_high for each partition
select exchanger,symbol,max(price_high) from stocks group by exchanger,symbol;

# Drop record in partition
TRUNCATE TABLE stocks PARTITION (exchanger='NYSE');

# Drop the partition
ALTER TABLE stocks DROP PARTITION (exchanger='NYSE');
