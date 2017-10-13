Tutorial
Download data in the linux cml
rm -rf /tmp/spark_training/spark_sql_0
mkdir -p /tmp/spark_training/spark_sql_01
cd /tmp/spark_training/spark_sql_01
git clone https://github.com/datafibers/data_set.git
ls -al data_set

spark-shell
 
scala> val df = spark.read.json("file:///tmp/spark_training/spark_sql_01/data_set/*.json")
df: org.apache.spark.sql.DataFrame = [card_type: string, email: string ... 5 more fields]
 
scala> df.show
+--------------------+--------------------+----------+------+---+-----------+------+
|           card_type|               email|first_name|gender| id|  last_name| spend|
+--------------------+--------------------+----------+------+---+-----------+------+
|                 jcb|aarrundale0@uol.c...|     Alyda|Female|  1|  Arrundale| 99.11|
|                 jcb|     pure1@phpbb.com|     Perle|Female|  2|        Ure| 53.92|
|                 jcb|mwillavoys2@githu...|      Mose|  Male|  3|  Willavoys| 11.22|
|                 jcb|     hminero3@cbc.ca|     Haley|  Male|  4|     Minero|160.08|
|                solo|sdeblasiis4@mysql...|     Sande|Female|  5| De Blasiis|266.90|
|                 jcb|cmceniry5@tripadv...|      Chet|  Male|  6|    McEniry|178.46|
|                 jcb|dglastonbury6@cne...|   Durward|  Male|  7|Glastonbury|314.88|
|                 jcb|     byedy7@xrea.com|      Bebe|Female|  8|       Yedy|164.06|
|                 jcb|pfreathy8@list-ma...|     Paige|  Male|  9|    Freathy|368.31|
|                 jcb|jorry9@odnoklassn...|    Justis|  Male| 10|       Orry|437.24|
|                 jcb|  cmacharga@1688.com|    Carver|  Male| 11|    MacHarg|203.50|
|diners-club-inter...|fgatesmanb@discuz...|    Farlee|  Male| 12|   Gatesman| 69.84|
|            bankcard|bharversonc@nymag...|      Bird|Female| 13|  Harverson|235.97|
|                 jcb|kkuhned@elegantth...|   Krispin|  Male| 14|      Kuhne|199.99|
|                 jcb|qodempseye@columb...|    Quincy|  Male| 15|  O'Dempsey| 89.80|
|                 jcb|lstrangewaysf@yan...|   Lindsey|  Male| 16|Strangeways| 14.85|
|            bankcard|  ewhinneyg@ox.ac.uk|    Evania|Female| 17|    Whinney|310.83|
|                 jcb|pshivellh@123-reg...|   Pepillo|  Male| 18|    Shivell| 61.69|
|               laser|  bfleotei@vimeo.com|    Bobbee|Female| 19|     Fleote| 54.78|
|               laser|otweedlej@thetime...|       Ora|Female| 20|    Tweedle|328.55|
+--------------------+--------------------+----------+------+---+-----------+------+
only showing top 20 rows
 
scala> df.printSchema
root
|-- card_type: string (nullable = true)
|-- email: string (nullable = true)
|-- first_name: string (nullable = true)
|-- gender: string (nullable = true)
|-- id: long (nullable = true)
|-- last_name: string (nullable = true)
|-- spend: string (nullable = true)
 
 
scala> df.filter("card_type = 'jcb'").show
scala> df.select($"card_type", concat_ws(" ", $"first_name", $"last_name")).show
scala> df.groupBy("card_type").count().show()
 
scala> df.createOrReplaceTempView("shopping")
scala> val sqlDF = spark.sql("select * from shopping").show
## Note
Temporary views in Spark SQL are session-scoped and will disappear if the session that creates it terminates. If you want to have a temporary view that is shared among all sessions and keep alive until the Spark application terminates, you can create a global temporary view. Global temporary view is tied to a system preserved database global_temp, and we must use the qualified name to refer it, e.g. SELECT * FROM global_temp.view1.
 
### Questions find the lady who spent most momey with bankcard
scala> val sqlDF = spark.sql("select first_name, last_name, spend from shopping where gender = 'Female' and card_type = 'bankcard' order by spend desc limit 1 ").show
 
 
### Spark SQL Parquet
scala> val df = spark.read.format("parquet").load("file:///home/vagrant/df_data/shopping.parquet/part-00000-a3c7ed15-e890-4ddb-af63-ac9515863dca-c000.snappy.parquet").show

 
### Generic Load/Save Functions
scala> val sqlDF = spark.sql("select first_name, last_name, spend from shopping where gender = 'Female' and card_type = 'bankcard' order by spend desc limit 10 ").write.format("parquet").save("file:///home/vagrant/df_data/shopping.parquet") 
scala> val peopleDF = spark.read.format("json").load("file:///home/vagrant/df_data/*.json")
peopleDF.select("name", "age").write.format("parquet").save("shopping.parquet")
 

### Hive support demo
scala> spark.sql("show tables").show
scala> spark.sql("create table a as select 1").show;
scala> spark.sql("show tables").show
scala> df.write.saveAsTable("test") #Save to Hive table
scala> spark.sql("select * from test").show
scala> spark.sql("show tables").show