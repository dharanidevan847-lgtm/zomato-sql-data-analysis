use zomato_s_a;
show tables;
desc zomato_s_a.zomato_dataset;

-- ( Data Analysis ) :

-- 1) contry distribution analysis:
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

-- 2) online delivery insights:
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

-- 3) Focus on Indian Restaurants:
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


-- 4) City Analysis - Popular Locations:


SELECT
    City,
    COUNT(*) AS Total_Restaurants
FROM zomato_s_a.zomato_dataset
GROUP BY City
ORDER BY Total_Restaurants DESC
LIMIT 3;

-- 5) Cuisine Insights:
SELECT
    Cuisines,
    COUNT(*) AS Restaurant_Count
FROM zomato_s_a.zomato_dataset
WHERE Locality LIKE '%Connaught Place%'
GROUP BY Cuisines
ORDER BY Restaurant_Count DESC
LIMIT 10;


-- 6)  Table Booking Impact Analysis:
SELECT
    Has_Table_booking AS Table_Booking,
    COUNT(*) AS Total_Restaurants,
    ROUND(AVG(Rating), 2) AS Average_Rating
FROM zomato_s_a.zomato_dataset
WHERE Locality LIKE '%Connaught Place%'
GROUP BY Has_Table_booking;

-- 7)  Restaurant Recommendations:

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

select * 
FROM zomato_s_a.zomato_dataset;

select count(*) as total_restaurant
from zomato_s_a.zomato_dataset;

