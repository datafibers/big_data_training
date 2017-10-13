--Create an external table employee
CREATE EXTERNAL TABLE IF NOT EXISTS employee (
  name string,
  work_place ARRAY<string>,
  sex_age STRUCT<sex:string,age:int>,
  skills_score MAP<string,int>,
  depart_title MAP<STRING,ARRAY<STRING>>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
COLLECTION ITEMS TERMINATED BY ','
MAP KEYS TERMINATED BY ':'
LOCATION '/tmp/data/employee'
;

--Query the whole table
SELECT * FROM employee

--Query the ARRAY in the table
SELECT work_place FROM employee
SELECT work_place[0] AS col_1, work_place[1] AS col_2, work_place[2] AS col_3 FROM employee;

--Query the STRUCT in the table
SELECT sex_age FROM employee;
SELECT sex_age.sex, sex_age.age FROM employee;

--Query the MAP in the table
SELECT skills_score FROM employee;

SELECT name, skills_score['DB'] AS DB,
skills_score['Perl'] AS Perl, skills_score['Python'] AS Python,
skills_score['Sales'] as Sales, skills_score['HR'] as HR FROM employee;

SELECT depart_title FROM employee;

SELECT name, depart_title['Product'] AS Product, depart_title['Test'] AS Test,
depart_title['COE'] AS COE, depart_title['Sales'] AS Sales
FROM employee;

SELECT name,
depart_title['Product'][0] AS product_col0,
depart_title['Test'][0] AS test_col0
FROM employee;

--Create a new table empoyee_export having columns, name, first_work_place, age
create table empoyee_export as select name, work_place[0] as first_work_place, sex_age.age as age from employee;

Export the data in empoyee_export to one piped flat file seperate columns by “|”
Add header row as the 1st line with format HEADER|current timestamp|file_name with datetime, such as HEADER|2017-10-15 18:34:62.345|employee_20171015.flat
Add trailer row as the last line with format TRAILER|current date|Row Count for details, such as TRAILER|2017-10-15|ROW COUNT: 4

insert overwrite local directory '/tmp/output'
select line
from
(select no, line
from
(select 1 as no, concat_ws('|','HEADER',cast(current_timestamp as string), concat('employee_',cast(current_date as string),'.flat')) as line
union all
select 2 as no, concat_ws('|', name, first_work_place, age) as line from empoyee_export
union all
select 3 as no, concat_ws('|','TRAILER', cast(current_date as string), 'ROW COUNT: ', cast(count(*) as string)) as line from empoyee_export
) c order by no
) d