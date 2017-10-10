#stocks表创建
CREATE TABLE if not EXISTS stocks(
ymd date,
price_open FLOAT ,
price_high FLOAT ,
price_low FLOAT ,
price_close float,
volume int,
price_adj_close FLOAT
)partitioned by (exchanger string,symbol string)
row format delimited fields terminated by ',';

#加载数据
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NASDAQ",symbol="AAPL");

#查询partition stocks
show partitions stocks;
+-------------------------------+--+
|           partition           |
+-------------------------------+--+
| exchanger=NASDAQ/symbol=AAPL  |
+-------------------------------+--+

#建立多个分区加载不同的数据
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NASDAQ",symbol="INTC");
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NYSE",symbol="GE");
LOAD DATA LOCAL INPATH '/home/mfz/apache-hive-2.1.1-bin/hivedata/stocks.csv' OVERWRITE INTO TABLE stocks partition(exchanger="NYSE",symbol="IBM");

#分页查询stocks分区是exchanger='NASDAQ' and symbol='AAPL'的数据
select * from stocks where exchanger='NASDAQ' and symbol='AAPL' limit 10 ;
+-------------+--------------------+--------------------+-------------------+---------------------+----------------+-----------------
--------+-------------------+----------------+--+
| stocks.ymd  | stocks.price_open  | stocks.price_high  | stocks.price_low  | stocks.price_close  | stocks.volume  | stocks.price_adj
_close  | stocks.exchanger  | stocks.symbol  |
+-------------+--------------------+--------------------+-------------------+---------------------+----------------+-----------------
--------+-------------------+----------------+--+
| 2010-02-08  | 195.69             | 197.88             | 194.0             | 194.12              | 17036300       | 194.12
        | NASDAQ            | AAPL           |
| 2010-02-05  | 192.63             | 196.0              | 190.85            | 195.46              | 30344200       | 195.46
        | NASDAQ            | AAPL           |
| 2010-02-04  | 196.73             | 198.37             | 191.57            | 192.05              | 27022300       | 192.05
        | NASDAQ            | AAPL           |
| 2010-02-03  | 195.17             | 200.2              | 194.42            | 199.23              | 21951800       | 199.23
        | NASDAQ            | AAPL           |
| 2010-02-02  | 195.91             | 196.32             | 193.38            | 195.86              | 24928900       | 195.86
        | NASDAQ            | AAPL           |
| 2010-02-01  | 192.37             | 196.0              | 191.3             | 194.73              | 26717800       | 194.73
        | NASDAQ            | AAPL           |
| 2010-01-29  | 201.08             | 202.2              | 190.25            | 192.06              | 44448700       | 192.06
        | NASDAQ            | AAPL           |
| 2010-01-28  | 204.93             | 205.5              | 198.7             | 199.29              | 41874400       | 199.29
        | NASDAQ            | AAPL           |
| 2010-01-27  | 206.85             | 210.58             | 199.53            | 207.88              | 61478400       | 207.88
        | NASDAQ            | AAPL           |
| 2010-01-26  | 205.95             | 213.71             | 202.58            | 205.94              | 66605200       | 205.94
        | NASDAQ            | AAPL           |
+-------------+--------------------+--------------------+-------------------+---------------------+----------------+-----------------
--------+-------------------+----------------+--+


#统计各分区中总数
select exchanger,symbol,count(*) from stocks group by exchanger,symbol;
+------------+---------+-------+--+
| exchanger  | symbol  |  c2   |
+------------+---------+-------+--+
| NASDAQ     | AAPL    | 6412  |
| NASDAQ     | INTC    | 6412  |
| NYSE       | GE      | 6412  |
| NYSE       | IBM     | 6412  |
+------------+---------+-------+--+

#统计各分区中最大的最大消费金额
select exchanger,symbol,max(price_high) from stocks group by exchanger,symbol;
+------------+---------+---------+--+
| exchanger  | symbol  |   c2    |
+------------+---------+---------+--+
| NASDAQ     | AAPL    | 215.59  |
| NASDAQ     | INTC    | 215.59  |
| NYSE       | GE      | 215.59  |
| NYSE       | IBM     | 215.59  |
+------------+---------+---------+--+