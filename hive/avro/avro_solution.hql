#Download input Avro files from data folder
#Download avro reader tool at http://www.us.apache.org/dist/avro/stable/java/avro-tools-1.8.2.jar

hdfs dfs -mkdir -p /tmp/data/avro/
#Create a table contains only three columns: id bigint, name string and bday string.
create external table user_profile (id BIGINT, name STRING, bday STRING) 
stored as avro
location '/tmp/data/avro';

hive> DESCRIBE FORMATTED user_profile;
Load an Avro file into the table

#Load the 1st Avro file into the table location
java -jar avro-tools-1.8.2.jar tojson user1.avro
{"id":1,"name":"adam","bday":"1985-09-30"}

hdfs dfs -put user1.avro /tmp/data/avro/ 
select * from user_profile;
+-----+-------+-------------+--+
| id  | name  |    bday     |
+-----+-------+-------------+--+
| 1   | adam  | 1985-09-30  |
+-----+-------+-------------+--+

#Modify the schema by adding an extra column country string at the end
alter table user_profile add columns (country string); // https://issues.apache.org/jira/browse/SPARK-18893 this for now should be done in hive beeline
select * from user_profile;
+-----+-------+-------------+----------+--+
| id  | name  |    bday     | country  |
+-----+-------+-------------+----------+--+
| 1   | adam  | 1985-09-30  | NULL     |
+-----+-------+-------------+----------+--+
note: From now, the Hive table will use new schema that contains four columns when reading its data. Because our input file doesn’t contain the country column, we should see NULLs in its place.


#Load the second Avro file into the table
java -jar avro-tools-1.8.2.jar tojson user2.avro
{"id":2,"name":"natalia","bday":"1989-08-09","country":"Poland"}

hdfs dfs -put user2.avro /tmp/data/avro/ 
WSELECT * FROM user_profile;
1   adam    1985-09-30  NULL
2   natalia 1989-08-09  Poland

#Modify the schema by removing an existing column
drop table user_profile;
create external table user_profile (name string, bday string, country string) 
stored as avro
location '/tmp/data/avro';      
describe formatted user_profile;
Note: alter table does not work for avro table. so rebuild the table.

SELECT * FROM user_profile;
+--------------------+--------------------+-----------------------+--+
| user_profile.name  | user_profile.bday  | user_profile.country  |
+--------------------+--------------------+-----------------------+--+
| adam               | 1985-09-30         | NULL                  |
| natalia            | 1989-08-09         | Poland                |
+--------------------+--------------------+-----------------------+--+
2 rows selected (0.323 seconds)
Note:
If we now query the table, the ID column is ignored (not visible), while the values in the three other columns are shown:

#Load the third Avro file into the table which doesn’t contain the ID field:
$ java -jar avro-tools-1.8.2.jar tojson user3.avro
{"name":"tofi","bday":"2006-06-06","country":"Sweden"}

hdfs dfs -put user3.avro /tmp/data/avro/ 

SELECT * FROM user_profile;
adam    1985-09-30  NULL
natalia 1989-08-09  Poland
tofi    2006-06-06  Sweden

note:Our Hive query is processing data correctly and printing expected output:

#Modify the schema by renaming an existing column
Note, there is no easy way to rename column in Hive table. The way that I know is to re-create the whole table again and specify Avro schema as a part of its definition OR your table is directly create from avro schema

drop table user_profile;

create external table user_profile
stored as avro
location '/tmp/data/avro'
tblproperties (
   'avro.schema.literal'='{
    "type":"record",
    "name":"user",
    "fields":[ {"name":"name", "type":"string"}, 
                 {"name":"birthday", "type":"string", "aliases":["bday"]}, 
                 {"name":"country", "type":"string", "default":"null"}
             ]
}')
;

create external table user_profile_test
stored as avro
location '/tmp/data/avro'
TBLPROPERTIES ('avro.schema.url'='/tmp/schema/user_schema.avsc');


desc user_profile;
+-----------+------------+----------+--+
| col_name  | data_type  | comment  |
+-----------+------------+----------+--+
| name      | string     |          |
| birthday  | string     |          |
| country   | string     |          |
+-----------+------------+----------+--+

SELECT * FROM user_profile;
+--------------------+------------------------+-----------------------+--+
| user_profile.name  | user_profile.birthday  | user_profile.country  |
+--------------------+------------------------+-----------------------+--+
| adam               | 1985-09-30             | NULL                  |
| natalia            | 1989-08-09             | Poland                |
| tofi               | 2006-06-06             | Sweden                |
+--------------------+------------------------+-----------------------+--+

#Load fourth file that contains a field named birthday (not bday).

java -jar avro-tools-1.8.2.jar tojson user4.avro
{"name":"fox","birthday":"2013-03-22","country":"Poland"}

hdfs dfs -put user4.avro /tmp/data/avro/ 

SELECT * FROM user_profile;
SELECT * FROM user_profile;
+--------------------+------------------------+-----------------------+--+
| user_profile.name  | user_profile.birthday  | user_profile.country  |
+--------------------+------------------------+-----------------------+--+
| adam               | 1985-09-30             | null                  |
| natalia            | 1989-08-09             | Poland                |
| tofi               | 2006-06-06             | Sweden                |
| fox                | 2013-03-22             | Poland                |
+--------------------+------------------------+-----------------------+--+
4 rows selected (0.165 seconds)

As we can see, Hive is handling it well and printing both birthday and bday fields in the same column!
As you see the support for schema evolution with Hive and Avro is very good.


