--Load the data file into table movies
create table movies ( 
index:int,
title:string,
year:int,
rating:double,
duration:int)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = "\t",
   "quoteChar"     = "'",
   "escapeChar"    = "\\"
)
location '/tmp/data/movie' 
;

--To filter movies with rating > 4 and give average ratings of all the movies in that subset for each year.
select avg(rating) from movies group by year having rating > 4

--To Provide a count of all movies as well as the count of movies with rating > 2
select count(*), count(case when rating > 2 then 1 else 0 end) from movies

--By each year,output the names of highest rated movie
select title from (
select row_number() over(partition by year order by rating desc) as rn, title from movies
) a where rn = 1;

--For Each movie compute the number of Days between movie Release year and todays date
*/
select datediff(cast(current_date as string), concat(cast(year as string), '-01-01')) from movies;