# Big Data Training Repository

## Setup Tables
```
hdfs dfs -mkdir -p /tmp/hivedemo/
cd big_data_training
hdfs dfs -put -f data /tmp/hivedemo/
beeline -u "jdbc:hive2://localhost:10000" -f data/setup_tables.sql
```

## Exercises
* [Hive/Spark SQL](https://github.com/datafibers/big_data_training/tree/master/hive): spark/hive sql
* [Hive UDF](https://github.com/datafibers/hiveudf): How to write hive udf by Java or Python
* [HBase Java API](https://github.com/datafibers/hbase_java_api)
* Spark API: spark scala/shell
* Zeppelin: notebook
* Data: more sample data

## Other
* [Lab enviroment vagrant](https://github.com/datafibers/lab_env)
* [Data Generation](http://www.mockaroo.com/)
* [Dataset API](https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.Dataset)
* [Spark CSV to Avro Tool](https://github.com/datafibers/spark_avro)
* [Simple Stream](https://github.com/datafibers/simple_stream)
