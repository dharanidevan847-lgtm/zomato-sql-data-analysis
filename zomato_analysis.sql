use zomato_s_a;
show tables;
desc zomato_s_a.zomato_dataset;

select *
from zomato_s_a.zomato_dataset
limit 10;

-- count total rows
select count(*) as total_zomato_dataset
from zomato_s_a.zomato_dataset;

-- check duplicates
select RestaurantID, count(*) as id_count
from zomato_s_a.zomato_dataset
group by RestaurantID 
having count(*) >1;
desc zomato_s_a.zomato_dataset;

select switch_to_order_menu,
count(*)  as total
from zomato_s_a.zomato_dataset
group by Switch_to_order_menu;


-- identify and remove unnecessary column, count columns 
SELECT
    COUNT(*) AS total_rows,
    COUNT(Locality) AS locality_count,
    COUNT(LocalityVerbose) AS locality_verbose_count,
    COUNT(DISTINCT Locality) AS unique_localities,
    COUNT(DISTINCT LocalityVerbose) AS unique_verbose_localities
FROM zomato_s_a.zomato_dataset;

-- backup table:
CREATE TABLE zomato_dataset_backup AS
SELECT *
FROM zomato_s_a.zomato_dataset;

SELECT COUNT(*)
FROM zomato_dataset_backup;

-- remove column, drop column switch_to_order_menu:
ALTER TABLE zomato_dataset
  DROP COLUMN Address,
  DROP COLUMN LocalityVerbose,
  DROP COLUMN Is_delivering_now;
alter table zomato_s_a.zomato_dataset
drop column switch_to_order_menu;
desc zomato_s_a.zomato_dataset;

select *
from zomato_s_a.zomato_dataset
limit 10;
show tables from zomato_s_a;

-- unique country code remove duplicate values:
SELECT DISTINCT CountryCode
FROM zomato_s_a.zomato_dataset
ORDER BY CountryCode;

-- create country table:
create table country(
countrycode int primary key,
country_name varchar(100));

-- insert values country table:
INSERT INTO country VALUES
 (1,'India'), (14,'Australia'), (30,'Brazil'), (37,'Canada'),
 (94,'Indonesia'), (148,'New Zealand'), (162,'Philippines'),
 (166,'Qatar'), (184,'Singapore'), (189,'South Africa'),
 (191,'Sri Lanka'), (208,'Turkey'), (214,'United Arab Emirates'),
 (215,'United Kingdom'), (216,'United States');
 
select *
from country;
select count(*) from country;

-- merging two tables, join twice columns zomato_s_a.zomato_dataset and country:
select 
a.RestaurantName, 
a.countrycode, 
b.country_name 
from zomato_s_a.zomato_dataset a 
join country b 
on a.countrycode=b.countrycode;

-- add column zomato_dataset
alter table zomato_s_a.zomato_dataset
add column country_name varchar(100);

-- update values from country table to zomato_dataset 
UPDATE zomato_s_a.zomato_dataset AS A
JOIN zomato_s_a.country AS B
    ON A.CountryCode = B.CountryCode
SET A.Country_Name = B.Country_Name;

SELECT RestaurantName, CountryCode, Country_Name
FROM zomato_s_a.zomato_dataset;

#find null values in country_name
select count(*)
from zomato_s_a.zomato_dataset
where country_Name is Null;

# group by city and order by city
select city,
count(*) 
from zomato_s_a.zomato_dataset
group by city
order by city;

select distinct city
from zomato_s_a.zomato_dataset
order by city;

# correcting misspelling city names                                          
select distinct city 
from zomato_s_a.zomato_dataset
where city like '%?%';

# find spelling mistakes                                                       
SELECT City, COUNT(*) AS restaurants
FROM zomato_dataset
GROUP BY City
ORDER BY City;

select distinct city
from zomato_dataset
where city <> trim(city);

SELECT DISTINCT City
FROM zomato_dataset
WHERE CONVERT(City USING ascii) LIKE '%?%';

SELECT a.City AS name_1, b.City AS name_2
FROM (SELECT DISTINCT City FROM zomato_dataset) a
JOIN (SELECT DISTINCT City FROM zomato_dataset) b
  ON SOUNDEX(a.City) = SOUNDEX(b.City)
 AND a.City < b.City;
 
 SELECT DISTINCT City, CountryCode
FROM zomato_dataset
WHERE City IN ('Pasay City', 'Pasig City', 'Panchkula', 'Pensacola');

select *
from zomato_s_a.zomato_dataset;

-- rolling count by city
SELECT City, COUNT(*) AS restaurants
FROM zomato_dataset
GROUP BY City
ORDER BY City;

SELECT City,
       COUNT(*) AS restaurants,
       SUM(COUNT(*)) OVER ( ORDER BY City
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
       ) AS rolling_count
FROM zomato_dataset
GROUP BY City;

desc zomato_s_a.zomato_dataset;

--  statistical summary,aggregate function find min max avg for votes, rating

select votes, rating, currency
from zomato_s_a.zomato_dataset
limit 10;

select 
min(votes) as Min_votes,
max(votes) as max_votes,
Round(avg(votes), 2) as avg_votes,
min(rating) as Min_rating,
max(rating) as Max_rating,
round(avg(rating), 2) as avg_rating
from zomato_s_a.zomato_dataset;

--  group currency and order by total currency
select currency,
count(*) as total_currency 
from zomato_s_a.zomato_dataset
group by currency
order by total_currency desc;

#add column
alter table zomato_s_a.zomato_dataset
add column rating_category varchar(20);

desc zomato_s_a.zomato_dataset;
select *
from zomato_s_a.zomato_dataset
limit 10;

-- case when
update zomato_s_a.zomato_dataset
set rating_category = 
case
    when rating is null Then 'Not Rated'
    when rating >= 4.5 then 'excellent'
    when rating >= 4.0 then 'very good'
    when rating >=3.5 then 'good'
    when rating >=2.5 then 'average'
    else 'poor'
    end;
    
    
select rating, rating_category,
count(*) as total_restaurants
from zomato_s_a.zomato_dataset
group by rating, rating_category
order by rating desc;

#rating_category wise total count
select rating_category, count(*) as total_restaurants
from zomato_s_a.zomato_dataset
group by rating_category
order by total_restaurants desc;

# filter rating 
select 
rating,
rating_category,
count(*) as total
from zomato_s_a.zomato_dataset
where rating = 1
group by rating, rating_category;
----------------------------------------------------------------------------------------------------------------------------------------------------
-- DataAnalysis
-- contry distribution analysis
select * 
from zomato_s_a.zomato_dataset;
SELECT
    Country_Name,
    COUNT(*) AS Total_Restaurants,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*)
		FROM zomato_s_a.zomato_dataset),
        2
    ) AS Country_Percentage
FROM zomato_s_a.zomato_dataset
GROUP BY Country_Name
ORDER BY Country_Percentage DESC;

select country_name, count(*)
from zomato_s_a.zomato_dataset;

select *
from zomato_s_a.zomato_dataset;
desc zomato_s_a.zomato_dataset;

-- online delivery insights
SELECT
    Country_Name,
    COUNT(*) AS Total_Restaurants,
    SUM(
        CASE
            WHEN Has_Online_delivery = 'Yes' THEN 1
            ELSE 0
        END
    ) AS Online_Delivery_Restaurants,
    ROUND(
        SUM(
            CASE
                WHEN has_online_delivery = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Online_Delivery_Percentage
FROM zomato_s_a.zomato_dataset
GROUP BY Country_Name
ORDER BY Online_Delivery_Percentage DESC;

select *
from zomato_s_a.zomato_dataset;

-- Focus on Indian Restaurants:
-- find india total restaurants
select country_name, count(*) as total_restaurants
from zomato_s_a.zomato_dataset
where country_name = 'india'
group by country_name;


SELECT
    COUNT(*) AS Total_Restaurants,
    ROUND(AVG(Rating), 2) AS Average_Rating,
    MAX(Rating) AS Highest_Rating,
    MIN(Rating) AS Lowest_Rating,
    SUM(Votes) AS Total_Votes
FROM zomato_s_a.zomato_dataset
WHERE Country_Name = 'India';


-- City-wise restaurant count:

SELECT
    City,
    COUNT(*) AS Total_Restaurants
FROM zomato_s_a.zomato_dataset
GROUP BY City
ORDER BY Total_Restaurants DESC
LIMIT 3;

-- Most popular cuisines find pannuvom:
SELECT
    Cuisines,
    COUNT(*) AS Restaurant_Count
FROM zomato_s_a.zomato_dataset
WHERE Locality LIKE '%Connaught Place%'
GROUP BY Cuisines
ORDER BY Restaurant_Count DESC
LIMIT 10;


-- Table Booking Impact Analysis
SELECT
    Has_Table_booking AS Table_Booking,
    COUNT(*) AS Total_Restaurants,
    ROUND(AVG(Rating), 2) AS Average_Rating
FROM zomato_s_a.zomato_dataset
WHERE Locality LIKE '%Connaught Place%'
GROUP BY Has_Table_booking;



-- Restaurant Recommendations
-- 1

SELECT
    RestaurantName,
    City,
    Average_Cost_for_two,
    Rating,
    Votes,
    Has_Table_booking,
      Has_Online_delivery
FROM zomato_s_a.zomato_dataset
WHERE Price_range = 2
  AND Rating >= 4.0
  AND Votes >= 100
  AND (
       Has_Table_booking = 'Yes'
      OR  Has_Online_delivery = 'Yes'
  )
ORDER BY Rating DESC, Votes DESC,
         Average_Cost_for_two ASC
LIMIT 10;

-- 2

SELECT
    RestaurantName,
    City,
    Average_Cost_for_two,
    Rating,
    Votes,
    Has_Table_booking,
    Has_Online_delivery
FROM zomato_s_a.zomato_dataset
WHERE City = 'Kolkata'
  AND Price_range = 2
  AND Rating >= 4.0
  AND Votes >= 100
  AND (
      Has_Table_booking = 'Yes'
      OR Has_Online_delivery = 'Yes'
  )
ORDER BY Rating DESC, Votes DESC,
         Average_Cost_for_two ASC
         limit 1;


SELECT COUNT(*) AS Total_Rows
FROM zomato_s_a.zomato_dataset;
 




