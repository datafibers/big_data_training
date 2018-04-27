create database if not exists demo;
use demo;

drop table if exists emp_basic; 
create table if not exists emp_basic (
emp_id int, emp_name string, job_title string, company string, start_date date, quit_date date
)
row format delimited
fields terminated by ','
tblproperties ("skip.header.line.count"="1");

drop table if exists emp_psn; 
create table if not exists emp_psn (
emp_id int, address string, city string, phone string, email string, gender string, age int
)
row format delimited
fields terminated by ','
tblproperties ("skip.header.line.count"="1");

drop table if exists emp_bef; 
create table if not exists emp_bef (
emp_id int, sin string, salary decimal(10,2), payroll string, level string
)
row format delimited
fields terminated by ','
tblproperties ("skip.header.line.count"="1");

load data inpath '/tmp/hivedemo/data/emp_basic.csv' overwrite table emp_basic;
load data inpath '/tmp/hivedemo/data/emp_psn.csv' overwrite table emp_psn;
load data inpath '/tmp/hivedemo/data/emp_bef.csv' overwrite table emp_bef;

drop table if exists employee; 
create table if not exists employee (
name string, work_place array<string>, sex_age struct<sex:string,age:int>, skills_score map<string,int>, depart_title map<string,array<string>>
)
comment 'this is an internal table'
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':';

load data inpath '/tmp/hivedemo/data/employee.txt' overwrite table employee;

--create external table and load the data
drop table if exists employee_external; 
create external table if not exists employee_external(
name string, work_place array<string>, sex_age struct<sex:string,age:int>, skills_score map<string,int>, depart_title map<string,array<string>>
)
comment 'this is an external table'
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':'
location '/tmp/employee';

load data inpath '/tmp/hivedemo/data/employee.txt' overwrite table employee_external;

drop table if exists employee_hr;
create table if not exists employee_hr(name string, employee_id int, sin_number string, start_date date
)
row format delimited
fields terminated by '|';

load data inpath '/tmp/hivedemo/data/employee_hr.txt' overwrite table employee_hr;

drop table if exists employee_id;
create table if not exists employee_id(
name string, work_place array<string>, sex_age struct<sex:string,age:int>, skills_score map<string,int>, depart_title map<string,array<string>>
)
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':';

load data inpath '/tmp/hivedemo/data/employee_id.txt' overwrite table employee_id;

drop table if exists employee_contract;
create table if not exists employee_contract(
name string,dept_num int,employee_id int,salary int,type string,start_date date
)
row format delimited
fields terminated by '|'
stored as textfile;

load data inpath '/tmp/hivedemo/data/employee_contract.txt' overwrite into table employee_contract;

drop table if exists employee_partitioned;
create table if not exists employee_partitioned(
name string, work_place array<string>, sex_age struct<sex:string,age:int>, skills_score map<string,int>, depart_title map<string,array<string>>
)
partitioned by (year int, month int)
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':';

drop table if exists employee_id_buckets;
create table if not exists employee_id_buckets(
name string, employee_id int, work_place array<string>, sex_age struct<sex:string,age:int>, skills_score map<string,int>, depart_title map<string,array<string>>
)
clustered by (employee_id) into 2 buckets
row format delimited
fields terminated by '|'
collection items terminated by ','
map keys terminated by ':';

drop table if exists shopping;
create table if not exists shopping (
first_name string, last_name string, email_address string, country string, gender string, age int, preferred_color string, monthly_spending decimal(10,3), credit_cards string
)
row format
delimited fields terminated by ','
lines terminated by '\n'
tblproperties ("skip.header.line.count"="1");

load data inpath '/tmp/hivedemo/data/customer_shopping_data.csv' overwrite table shopping;
