# Prepare file
hdfs dfs -mkdir -p /tmp/data/restaurants
hdfs dfs -put restaurants.json /tmp/data/restaurants

#Create a external table called restaurant to refer the data retaurants.json

create external table restaurants (value string)
location '/tmp/data/restaurants';

create view v_rest
as
select
root.*,
addr.*
from restaurants
lateral view json_tuple (restaurants.value, 'restaurant_id', 'name', 'address', 'borough', 'cuisine', 'grades') root 
as id, name, address, place, cuisine, grades
lateral view json_tuple (root.address, 'building', 'coord', 'street', 'zipcode') addr
as building, coord, street, zipcode;

#Write a query to display total number of restaurant which is in the borough Bronx.
select count(*) from v_rest where place = 'Bronx';

＃Write a query to display the first 5 restaurant order by id which is in the borough Bronx, how about skip first 5?
select id, name from v_rest 
where place = 'Bronx' and id not in (
select id from v_rest where place = 'Bronx' order by id limit 5) order by id 
limit 5;

with base as (
select
id,
name,
row_number() over(order by id) as rn
from v_rest where place = 'Bronx' 
)
select id, name from base where rn between 6 and 10;

#Write a query to find the restaurants that achieved a score which is not smaller than 80 and no bigger than 100.
with base as (
select id, name, explode(split(grades, ',')) as trans 
from v_rest
),
score_base as (
select id, name, cast(split(regexp_replace(trans, '}|]', ''), ':')[1] as int) as score 
from base where trans like '%score%'
)
select id, name, sum(score) as total_score from score_base group by id, name having sum(score) between 80 and 100 order by total_score;

#Write a query to find the restaurants that do not prepare any cuisine of 'American' and their grade score more than 70 
with base as (
select id, name, explode(split(grades, ',')) as trans 
from v_rest
where cuisine <> 'American'
),
score_base as (
select id, name, cast(split(regexp_replace(trans, '}|]', ''), ':')[1] as int) as score 
from base where trans like '%score%'
)
select id, name, sum(score) as total_score from score_base group by id, name having sum(score) > 70;

#Write a query to find the restaurants which do not prepare any cuisine of 'American' and achieved a grade point 'A' not belongs to the borough Brooklyn.
with base as (
select id, name, explode(split(grades, ',')) as trans 
from v_rest
where cuisine <> 'American' and place <> 'Brooklyn'
),
score_base as (
select id, name, split(regexp_replace(trans, '}|]', ''), ':')[1] as grade_value 
from base where trans like '%grade%'
)
select id, name, grade_value from score_base where grade_value = '"A"';

#Write a query to find the restaurants which belong to the borough Bronx and prepared either American or Chinese dish.
select id, name 
from v_rest
where (cuisine = 'American' or cuisine = 'Chinese') and place = 'Brooklyn'

#Write a query to find the restaurant Id, name, borough and cuisine for those restaurants which not belong to the borough Staten Island or Queens or Bronxor Brooklyn.
select id, name, place, cuisine
from v_rest
where place not in ('Staten Island', 'Queens', 'Bronxor Brooklyn');

#Write a query to find the restaurant Id, name, borough and cuisine for those restaurants which prepared dish except 'American' and 'Chinese' or restaurant's name begins with letter 'Wil'.
select id, name, place, cuisine
from v_rest
where trim(cuisine) not in ('American', 'Chinese') or (name like 'Wil%');
