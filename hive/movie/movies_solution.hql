--Load the data file into table movie
*/
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
;

/*
To filter movies with rating > 4 and give average ratings of all the movies in that subset.
*/

filtered_Movies = FILTER Movies_Reviews  BY rating > 4.0;
Group_Movies = GROUP filtered_Movies BY year;
Averge_rating = FOREACH Group_Movies GENERATE group,AVG(filtered_Movies.rating);
STORE Averge_rating INTO 'Average_Rating.txt' USING PigStorage(',');


/*
To Provide a count of all movies as well as the count of movies with rating > 2
*/

filtered_Movies1 = FILTER Movies_Reviews  BY rating > 2.0;
Group_Movies = GROUP filtered_Movies1 BY index;
Count_Movies = FOREACH Group_Movies GENERATE group,COUNT(filtered_Movies1.index);
STORE Count_Movies INTO 'Output_Count.txt' USING PigStorage(',');


filtered_Movies2 = FILTER Movies_Reviews  BY index > 0;
Group_Movies = GROUP filtered_Movies2 BY index;
Total_Count = FOREACH Group_Movies GENERATE group,COUNT(filtered_Movies2.index);
STORE Total_Count INTO 'Total_Count.txt' USING PigStorage(',');


/* 
By each year,output the names of highest rated movie 
*/

Group_Movies = GROUP Movies_Reviews BY year;
maxYearRating = FOREACH Group_Movies GENERATE MAX(Movies_Reviews.year) AS YEAR ,MAX(Movies_Reviews.rating) AS  Max_Rating;
JoinData = JOIN Movies_Reviews BY (year,rating),maxYearRating BY (YEAR,Max_Rating);
YearHighestRatedMovie = FOREACH JoinData GENERATE Movies_Reviews::year,Movies_Reviews::rating,Movies_Reviews::title;
STORE YearHighestRatedMovie INTO 'ByYearHighestRatedMovie.txt' USING PigStorage(',');

/*
For Each movie compute the number of Days between movie Release and todays date
*/

DifferenceDate = FOREACH Movies_Reviews GENERATE index..duration,DaysBetween(CurrentTime(),ToDate((chararray)year,'yyyy')) as Difference;
STORE DifferenceDate INTO 'DifferenceBetweenDates.txt' USING PigStorage(',');