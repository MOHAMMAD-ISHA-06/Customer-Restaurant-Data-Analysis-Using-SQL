CREATE DATABASE PROJECT;
USE PROJECT;
/*CREATE TABLE CONSUMERS*/
CREATE TABLE CONSUMERS (
 CONSUMER_ID VARCHAR(10) PRIMARY KEY ,CITY VARCHAR(100),STATE VARCHAR(100),
 COUNTRY VARCHAR(100),LATITUDE DECIMAL(9,6),LONGITUDE DECIMAL(9,6),
 SMOKER VARCHAR(10),DRINK_LEVEL VARCHAR(20),TRANSPORTATION VARCHAR(20),
 MARITAL_STATUS VARCHAR(20),
 CHILDREN VARCHAR(20),AGE INT,OCCUPATION VARCHAR(50),BUDGET VARCHAR(20)
 );
 
 /*CREATE TABLE CONSUMER_PREFERENCES*/
 CREATE TABLE CONSUMER_PREFERENCES( CONSUMER_ID VARCHAR(10) ,
 PREFERRED_CUISINE VARCHAR(50),
 FOREIGN KEY (CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID)
 );
 
 /*CREATE TABLE RESTAURANTS*/
 CREATE TABLE RESTAURANTS(RESTAURANT_ID INT PRIMARY KEY,
 NAME VARCHAR(50),CITY VARCHAR(50),STATE VARCHAR(50),COUNTRY VARCHAR(50),
 ZIP_CODE INT ,LATITUDE DECIMAL(10,7),LONGITUDE DECIMAL(10,7),ALCOHOL_SERVICE VARCHAR(20),
 SMOKING_ALLOWED VARCHAR(50),PRICE VARCHAR(20),FRANCHISE VARCHAR(20),AREA VARCHAR(20),
 PARKING VARCHAR(20)
 );
 
  /*CREATE TABLE RESTAURANT_CUISINES*/
  CREATE TABLE RESTAURANT_CUISINES( RESTAURANT_ID INT 
,CUISINE VARCHAR(50),
FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
);
  
  /*CREATE TABLE RATINGS*/
  CREATE TABLE RATINGS(CONSUMER_ID VARCHAR(10),
  RESTAURANT_ID INT,
  OVERALL_RATING INT CHECK (OVERALL_RATING BETWEEN 0 AND 2),FOOD_RATING INT CHECK (FOOD_RATING BETWEEN 0 AND 2),
  SERVICE_RATING INT CHECK (SERVICE_RATING BETWEEN 0 AND 2),
  FOREIGN KEY (CONSUMER_ID) REFERENCES CONSUMERS(CONSUMER_ID),
  FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID)
  );
  
SELECT* FROM CONSUMERS;
SELECT* FROM CONSUMER_PREFERENCES;
SELECT*FROM RESTAURANTS;
SELECT*FROM RESTAURANT_CUISINES;
SELECT*FROM RATINGS;
  
/*Objective: 
Using the WHERE clause to filter data based on specific criteria.*/
-- 1.	List all details of consumers who live in the city of 'Cuernavaca'.
SELECT * FROM CONSUMERS WHERE CITY='CUERNAVACA';

-- 2.	Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.
SELECT CONSUMER_ID,AGE,OCCUPATION FROM CONSUMERS WHERE OCCUPATION ='STUDENT' AND SMOKER='YES';  

-- 3.List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level.
SELECT NAME,CITY,ALCOHOL_SERVICE,PRICE FROM RESTAURANTS WHERE ALCOHOL_SERVICE='WINE &BEER' AND PRICE='MEDIUM';

-- 4.	Find the names and cities of all restaurants that are part of a 'Franchise'.
SELECT NAME,CITY FROM RESTAURANTS WHERE FRANCHISE='YES';

 -- 5.	Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory'
 -- (which corresponds to a value of 2, according to the data dictionary).
 SELECT CONSUMER_ID,RESTAURANT_ID,OVERALL_RATING FROM RATINGS WHERE OVERALL_RATING=2;

 /*Questions JOINs with Subqueries*/
 -- 1.	List the names and cities of all restaurants that have an Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
SELECT DISTINCT r.Name, r.City
FROM Restaurants r
JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
WHERE ra.Overall_Rating = 2;
/*EXPLANATION : - SELECT DISTINCT r.Name, r.City → ensures you don’t get duplicate restaurant names if multiple consumers rated 
the same restaurant as 2.
- FROM Restaurants r → queries the Restaurants table.
- JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID → links restaurants with their ratings.
- WHERE ra.Overall_Rating = 2 → filters only those ratings marked Highly Satisfactory.*/

-- 2.	Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.
SELECT C.CONSUMER_ID,C.AGE FROM CONSUMERS C JOIN RATINGS R ON C.CONSUMER_ID=R.CONSUMER_ID JOIN RESTAURANTS RES
ON R.RESTAURANT_ID=RES.RESTAURANT_ID WHERE RES.CITY='SAN LUIS POTOSI';
/*Explanation:
- SELECT DISTINCT → ensures each consumer appears only once, even if they rated 
multiple restaurants in San Luis Potosi.
- Consumers c → provides consumer details (including Age).
- Ratings r → links consumers to restaurants they rated.
- Restaurants res → provides restaurant location details.
- WHERE res.City = 'San Luis Potosi' → filters only restaurants located in San Luis Potosi.
*/

-- 3.	List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
SELECT DISTINCT  RES.NAME FROM RESTAURANTS RES JOIN RESTAURANT_CUISINES RC ON
RES.RESTAURANT_ID=RC.RESTAURANT_ID JOIN RATINGS RA ON RES.RESTAURANT_ID=RA.RESTAURANT_ID
WHERE RC.CUISINE='MEXICAN' AND RA.CONSUMER_ID='U1001' ;
/* Explanation:
- JOIN Restaurant_Cuisines rc → links restaurants to their cuisines.
- JOIN Ratings ra → links restaurants to consumer ratings.
- WHERE rc.Cuisine = 'Mexican' AND 
ra.Consumer_ID = 'U1001' → filters only Mexican restaurants rated by consumer U1001.
- DISTINCT → ensures each restaurant name appears only once, even if multiple
 ratings exist.
*/
-- 4.	Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.

SELECT DISTINCT C.* FROM CONSUMERS C JOIN CONSUMER_PREFERENCES CP ON C.CONSUMER_ID=CP.CONSUMER_ID
WHERE CP.PREFERRED_CUISINE='AMERICAN' AND C.BUDGET='MEDIUM';
/*EXPLANATION: Explanation:
- SELECT DISTINCT c.* → retrieves all consumer details (Consumer_ID, City, State, Country, Latitude, Longitude, Smoker, Drink_Level, Transportation_Method, Marital_Status, Children, Age, Occupation, Budget).
- JOIN Consumer_Preferences cp → links consumers with their cuisine preferences.
- WHERE cp.Preferred_Cuisine = 'American' AND c.Budget = 'Medium' → filters only those consumers who prefer American 
cuisine and have a medium budget.
*/
-- 5.	List restaurants (Name, City) that have received a Food_Rating lower than the average Food_Rating across all rated restaurants.
SELECT*FROM RESTAURANTS;
SELECT*FROM RATINGS;
SELECT  DISTINCT RES.NAME,RES.CITY FROM RESTAURANTS RES 
JOIN 
RATINGS R ON RES.RESTAURANT_ID=R.RESTAURANT_ID WHERE R.FOOD_RATING<
(SELECT AVG(FOOD_RATING) FROM RATINGS );
/* Explanation:
- SELECT DISTINCT r.Name, r.City → ensures each restaurant appears only once, even if multiple consumers rated it below average.
- JOIN Ratings ra → links restaurants with their ratings.
- WHERE ra.Food_Rating < (SELECT AVG(Food_Rating) FROM Ratings) → compares each 
restaurant’s food rating against the overall average food rating across all restaurants.
 What this query does:
- First calculates the average Food_Rating across all ratings in the Ratings table.
- Then finds restaurants that have at least one rating below this average.
- Returns their Name and City.
*/


-- 6.	Find consumers (Consumer_ID, Age, Occupation) who have rated at least one restaurant  
-- but have NOT rated any restaurant that serves 'Italian' cuisine.
SELECT DISTINCT C.CONSUMER_ID,C.AGE,C.OCCUPATION FROM CONSUMERS C
JOIN RATINGS R ON C.CONSUMER_ID=R.CONSUMER_ID
WHERE C.CONSUMER_ID NOT IN(SELECT DISTINCT R2.CONSUMER_ID FROM RATINGS R2 
JOIN RESTAURANT_CUISINES RC ON RC.RESTAURANT_ID=R2.RESTAURANT_ID
WHERE RC.CUISINE='ITALIAN');
/*Explanation:
- JOIN Ratings r → ensures we only consider consumers who have rated at least one restaurant.
- NOT IN (...) → excludes consumers who have rated any restaurant serving Italian cuisine.
- Inner query:
- Finds all consumers (Consumer_ID) who rated restaurants with cuisine = 'Italian'.
- Outer query:
- Selects all other consumers who rated restaurants but are not in that inner list.
- DISTINCT → ensures each consumer appears only once.
✅ What this query returns:
- A clean list of consumers (with their Consumer_ID, Age, Occupation) 
who have participated in rating restaurants but never rated an Italian restaurant.
*/
-- 7.	List restaurants (Name) that have received ratings from consumers older than 30.
SELECT DISTINCT R.NAME FROM RESTAURANTS R 
JOIN RATINGS RA ON R.RESTAURANT_ID=RA.RESTAURANT_ID
JOIN CONSUMERS C ON RA.CONSUMER_ID=C.CONSUMER_ID WHERE C.AGE>30;
/*Explanation:
- JOIN Ratings ra → links restaurants with ratings.
- JOIN Consumers c → links ratings back to consumer details.
- WHERE c.Age > 30 → filters only those ratings given by consumers older than 30.
- SELECT DISTINCT r.Name → ensures each restaurant name appears only once, even if multiple older consumers rated it.
✅ What this query returns:
- A list of restaurant names that have been rated by consumers above 30 years old.
*/
-- 8.	Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' 
-- and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).
SELECT DISTINCT C.CONSUMER_ID,C.OCCUPATION FROM CONSUMERS C JOIN CONSUMER_PREFERENCES CP ON
C.CONSUMER_ID=CP.CONSUMER_ID JOIN
RATINGS R ON C.CONSUMER_ID=R.CONSUMER_ID
 WHERE CP.PREFERRED_CUISINE='MEXICAN' AND R.OVERALL_RATING=0;
/*Explanation:
- JOIN Consumer_Preferences cp → links consumers to their cuisine preferences.
- JOIN Ratings r → links consumers to their ratings.
- WHERE cp.Preferred_Cuisine = 'Mexican' AND r.Overall_Rating = 0 → filters only those consumers who prefer Mexican cuisine and have rated at least one restaurant with an overall rating of 0 (Not Satisfactory).
- DISTINCT → ensures each consumer appears only once, even if they gave multiple 0 ratings.
*/

-- 9.	List the names and cities of restaurants that serve 'Pizzeria' cuisine and are 
-- located in a city where at least one 'Student' consumer lives.
SELECT DISTINCT RES.NAME,RES.CITY FROM RESTAURANTS RES JOIN RESTAURANT_CUISINES RCU ON RES.RESTAURANT_ID=RCU.RESTAURANT_ID
WHERE RCU.CUISINE='PIZZERIA' AND RES.CITY IN(SELECT DISTINCT C.CITY FROM CONSUMERS C WHERE C.OCCUPATION='STUDENT');
/*Explanation:
- JOIN Restaurant_Cuisines rc → links restaurants to their cuisines.
- WHERE rc.Cuisine = 'Pizzeria' → filters only restaurants serving Pizzeria cuisine.
- AND r.City IN (...) → ensures the restaurant is located in a city where at least one student consumer lives.
- Inner query:
- Finds all cities where consumers with occupation = 'Student' live.
- Outer query:
- Returns restaurant names and cities that match both conditions.
- DISTINCT → avoids duplicate rows if multiple students or cuisines overlap.
*/
-- 10.	Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
SELECT DISTINCT C.CONSUMER_ID,C.AGE FROM CONSUMERS C 
JOIN RATINGS R ON C.CONSUMER_ID=R.CONSUMER_ID
JOIN RESTAURANTS RES 
ON RES.RESTAURANT_ID=R.RESTAURANT_ID 
WHERE C.DRINK_LEVEL='SOCIAL DRINKERS' AND 
RES.PARKING='NONE';
/*🔍 Explanation:
- JOIN Ratings r → links consumers to the restaurants they rated.
- JOIN Restaurants res → links ratings to restaurant details.
- WHERE c.Drink_Level = 'Social Drinker' AND res.Parking = 'No' → filters only those consumers who
 are social drinkers and rated restaurants with no parking.
- DISTINCT → ensures each consumer appears only once, even if they rated multiple “No parking” restaurants.
*/



/*Questions Emphasizing WHERE Clause and Order of Execution*/

-- 1.	List Consumer_IDs and the count of restaurants they've rated, but only for consumers who are 'Students'.
-- Show only students who have rated more than 2 restaurants.
SELECT c.Consumer_ID, COUNT(DISTINCT r.Restaurant_ID) AS Rated_Restaurants
FROM Consumers c
JOIN Ratings r 
    ON c.Consumer_ID = r.Consumer_ID
WHERE c.Occupation = 'Student'
GROUP BY c.Consumer_ID
HAVING COUNT(DISTINCT r.Restaurant_ID) > 2;
/*🔍 Explanation:
- JOIN Ratings r → links consumers to the restaurants they rated.
- WHERE c.Occupation = 'Student' → filters only student consumers.
- COUNT(DISTINCT r.Restaurant_ID) → counts the number of unique restaurants each student rated.
- GROUP BY c.Consumer_ID → groups results by each student.
- HAVING COUNT(...) > 2 → ensures only students who rated more than 2 restaurants are shown.
*/



-- 2.	We want to categorize consumers by an 'Engagement_Score' which is their Age divided by 10 (integer division). 
-- List the Consumer_ID, Age, and this calculated Engagement_Score, but only for consumers whose Engagement_Score would 
-- be exactly 2 and who use 'Public' transportation.
SELECT c.Consumer_ID, 
       c.Age, 
       (c.Age / 10) AS Engagement_Score
FROM Consumers c
WHERE (c.Age / 10) = 2
  AND c.Transportation_Method = 'Public';
/*Explanation:
- (c.Age / 10) → performs integer division in SQL (depending on DBMS, you may need FLOOR(c.Age/10) for strict integer division).
- WHERE (c.Age / 10) = 2 → filters consumers whose age is between 20–29 years (since 20 ÷ 10 = 2, 29 ÷ 10 = 2).
- AND c.Transportation_Method = 'Public' → ensures only those who use public transport are included.
- SELECT Consumer_ID, Age, Engagement_Score → returns the requested fields.
✅ What this query returns:
- All consumers aged 20–29 who use Public transportation, with their calculated Engagement_Score = 2.
- For example, from your dataset, consumers like U1006 (Age 23, Student, Public), U1029 (Age 22, Student, Public), U1052 (Age 22, Student, Public), U1068 (Age 24, Student, Public), U1099 (Age 23, Student, Public), U1104 (Age 21, Student, Public), U1111 (Age 21, Student, Public), U1115 (Age 22, Student, Public), U1131 (Age 22, Student, Public), U1136 (Age 22, Student, Public) would appear.
👉 This query neatly segments young, public-transport-using consumers into the Engagement_Score category 2.
Would you like me to also extend this query to show their Occupation (so you can see if most of them are students or working professionals)?
*/


-- 3.	For each restaurant, calculate its average Overall_Rating. Then, list the restaurant Name, City, and its 
-- calculated average Overall_Rating, but only for restaurants located in 'Cuernavaca' AND 
-- whose calculated average Overall_Rating is greater than 1.0.
SELECT r.Name, r.City, AVG(ra.Overall_Rating) AS Avg_Overall_Rating
FROM Restaurants r
JOIN Ratings ra 
    ON r.Restaurant_ID = ra.Restaurant_ID
WHERE r.City = 'Cuernavaca'
GROUP BY r.Name, r.City
HAVING AVG(ra.Overall_Rating) > 1.0;
/*🔍 Explanation:
- JOIN Ratings ra → links restaurants with their ratings.
- WHERE r.City = 'Cuernavaca' → filters only restaurants located in Cuernavaca.
- GROUP BY r.Name, r.City → groups ratings by restaurant so we can calculate averages.
- AVG(ra.Overall_Rating) → computes the average overall rating per restaurant.
- HAVING AVG(ra.Overall_Rating) > 1.0 → ensures only restaurants with an average rating greater than 1.0 are included.
✅ What this query returns:
- A list of restaurants in Cuernavaca with their average Overall_Rating, but only those above 1.0 (meaning they are at least “Satisfactory” or better on average).
- For example, from your dataset, restaurants like McDonalds Centro, Mikasa, Restaurant Familiar El Chino, Restaurant Las Mañanitas, Restaurant Teely, Restaurant And Bar Carlos N Charlies, El Cotorreo, El Oceano Dorado qualify because their average ratings are above 1.0.
👉 This query is excellent for identifying well-performing restaurants in Cuernavaca based on consumer satisfaction.
*/


-- 4.	Find consumers (Consumer_ID, Age) who are 'Married' and whose Food_Rating for any restaurant 
-- is equal to their Service_Rating for that same restaurant, but only consider ratings where the Overall_Rating was 2.
SELECT C.CONSUMER_ID,C.AGE FROM CONSUMERS C JOIN RATINGS R ON C.CONSUMER_ID=R.CONSUMER_ID WHERE C.MARITAL_STATUS='MARRIED'
AND R.OVERALL_RATING=2 AND R.FOOD_RATING=R.SERVICE_RATING;
/*Explanation:
- JOIN Ratings r → links consumers with their ratings.
- WHERE c.Marital_Status = 'Married' → filters only married consumers.
- AND r.Overall_Rating = 2 → considers only ratings marked Highly Satisfactory.
- AND r.Food_Rating = r.Service_Rating → ensures food and service ratings are equal for that restaurant.
- DISTINCT → avoids duplicates if a consumer has multiple qualifying ratings.
✅ What this query returns:
- A list of Consumer_IDs and Ages for married consumers who gave at least one restaurant a Highly 
Satisfactory overall rating and rated food and service equally.
👉 This query neatly isolates married consumers with consistent food vs. service ratings in highly satisfactory experiences.
*/

SELECT*FROM RATINGS;
-- 5.	List Consumer_ID, Age, and the Name of any restaurant they rated, 
-- but only for consumers who are 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.
SELECT DISTINCT C.CONSUMER_ID,C.AGE,RES.NAME FROM CONSUMERS C JOIN RATINGS R ON R.CONSUMER_ID=C.CONSUMER_ID 
JOIN RESTAURANTS RES ON RES.RESTAURANT_ID=R.RESTAURANT_ID
WHERE C.OCCUPATION='EMPLOYED' AND R.FOOD_RATING=0
AND RES.CITY='CIUDAD VICTORIA';
/* Explanation:
- JOIN Ratings ra → links consumers to the restaurants they rated.
- JOIN Restaurants r → links ratings to restaurant details.
- WHERE c.Occupation = 'Employed' → filters only employed consumers.
- AND ra.Food_Rating = 0 → ensures they gave at least one restaurant a food rating of 0 (Not Satisfactory).
- AND r.City = 'Ciudad Victoria' → restricts to restaurants located in Ciudad Victoria.
- DISTINCT → avoids duplicates if the same consumer rated multiple restaurants in Ciudad Victoria with Food_Rating = 0.
✅ What this query returns:
- A list of Consumer_IDs, Ages, and Restaurant Names for employed consumers who gave a food rating of 
0 to at least one restaurant in Ciudad Victoria.
- For example, from your dataset, consumers like U1049 (Age 28, Employed) and U1053 (Age 35, Employed) 
qualify because they rated Ciudad Victoria restaurants (e.g., Carnitas Mata, Hamburguesas La Perica) with Food_Rating = 0.
👉 This query neatly isolates employed consumers dissatisfied with food quality in Ciudad Victoria restaurants.
*/

/*Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures*/

/* 1.	Using a CTE, find all consumers who live in 'San Luis Potosi'. Then, list their Consumer_ID, Age, 
 and the Name of any Mexican restaurant they have rated with an Overall_Rating of 2.*/
WITH SanLuisConsumers AS (
    SELECT Consumer_ID, Age
    FROM Consumers
    WHERE City = 'San Luis Potosi'
),
MexicanRatings AS (
    SELECT r.Restaurant_ID, ra.Consumer_ID, ra.Overall_Rating
    FROM Restaurants r
    JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
    JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
    WHERE rc.Cuisine = 'Mexican'
      AND ra.Overall_Rating = 2
)
SELECT DISTINCT slc.Consumer_ID, slc.Age, r.Name AS Restaurant_Name
FROM SanLuisConsumers slc
JOIN MexicanRatings mr ON slc.Consumer_ID = mr.Consumer_ID
JOIN Restaurants r ON mr.Restaurant_ID = r.Restaurant_ID;
/*- This Common Table Expression (CTE) selects all consumers who live in San Luis Potosi.
- It keeps only their Consumer_ID and Age.
mexicanratings:- This CTE finds all ratings where:
- The restaurant serves Mexican cuisine.
- The consumer gave an Overall_Rating = 2 (Highly Satisfactory).
- It outputs the Restaurant_ID, Consumer_ID, and the rating.
- Joins the two CTEs:
- SanLuisConsumers → consumers living in San Luis Potosi.
- MexicanRatings → Mexican restaurants rated 2.
- Ensures we only get consumers who satisfy both conditions.
- Adds the restaurant name for clarity.
- DISTINCT removes duplicates if a consumer rated multiple Mexican restaurants with Overall_Rating = 2.
 In short:
This query segments consumers living in San Luis Potosi, checks if they rated Mexican restaurants with a
 perfect Overall_Rating of 2, and then lists their IDs, ages, and the restaurant names.

*/

/* 2.	For each Occupation, find the average age of consumers. Only consider consumers who 
 have made at least one rating. (Use a derived table to get consumers who have rated).*/
 SELECT c.Occupation, AVG(c.Age) AS Avg_Age
FROM Consumers c
JOIN (
    SELECT DISTINCT Consumer_ID
    FROM Ratings
) rated ON c.Consumer_ID = rated.Consumer_ID
GROUP BY c.Occupation;
/* Average age by occupation (only consumers who have made at least one rating)
- Derived table: Filters to consumers with at least one rating.
- Output: Occupation with average age.
1.- inner Derived Table (rated)
SELECT DISTINCT Consumer_ID
FROM Ratings
- This pulls out all unique Consumer_IDs from the Ratings table.
- Purpose: identify only those consumers who have actually rated at least one restaurant.
- Without this, we might include consumers who exist in the Consumers table but never rated anything.
- Join Consumers with Rated Consumers
FROM Consumers c
JOIN ( ... ) rated ON c.Consumer_ID = rated.Consumer_ID
- This ensures we only keep consumers who appear in both:
- The Consumers table (with their details like Age, Occupation).
- The rated derived table (meaning they have ratings).
- Result: a filtered set of consumers who have rated at least one restaurant.
- Group by Occupation
GROUP BY c.Occupation
- Groups all qualifying consumers by their Occupation (e.g., Student, Employed, Self-employed, etc.).
- Calculate Average Age
SELECT c.Occupation, AVG(c.Age) AS Avg_Age
- For each occupation group, computes the average age of consumers who have rated at least one restaurant.
- AVG() is an aggregate function that calculates the mean.
 In short:
This query filters consumers to only those who have rated, then groups them by occupation, and finally calculates 
the average age per occupation.
Would you like me to also show you a version using a CTE instead of a derived table, so you can compare both approaches?
*/

/* 3.	Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings 
within each restaurant based on Overall_Rating (highest first). Display Restaurant_ID, Consumer_ID, Overall_Rating, and the 
RatingRank.*/
WITH CuernavacaRatings AS (
    SELECT r.Restaurant_ID, ra.Consumer_ID, ra.Overall_Rating
    FROM Restaurants r
    JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
SELECT Restaurant_ID,
       Consumer_ID,
       Overall_Rating,
       RANK() OVER (PARTITION BY Restaurant_ID ORDER BY Overall_Rating DESC) AS RatingRank
FROM CuernavacaRatings
ORDER BY Restaurant_ID, RatingRank, Consumer_ID;
/*EXPLANATION: - Partition: Per restaurant.
- Order: Highest Overall_Rating first
- CTE: CuernavacaRatings
WITH CuernavacaRatings AS (
    SELECT r.Restaurant_ID, ra.Consumer_ID, ra.Overall_Rating
    FROM Restaurants r
    JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
- This Common Table Expression (CTE) filters ratings to only those restaurants located in Cuernavaca.
- It outputs three columns:
- Restaurant_ID
- Consumer_ID
- Overall_Rating
- Main Query
SELECT Restaurant_ID,
       Consumer_ID,
       Overall_Rating,
       RANK() OVER (PARTITION BY Restaurant_ID ORDER BY Overall_Rating DESC) AS RatingRank
FROM CuernavacaRatings
- For each restaurant, we want to rank its ratings.
- RANK() OVER (...) is a window function:
- PARTITION BY Restaurant_ID → restart the ranking for each restaurant.
- ORDER BY Overall_Rating DESC → highest ratings get rank 1, then 2, etc.
- This means within each restaurant, ratings are ordered from best to worst.
- Final Ordering
ORDER BY Restaurant_ID, RatingRank, Consumer_ID;
- Ensures the output is neatly grouped by restaurant.
- Within each restaurant, ratings are sorted by rank, then by consumer.
 In short:
This query focuses only on Cuernavaca restaurants, pulls their ratings, and then ranks each rating
 per restaurant so you can see which consumers gave the highest vs. lowest ratings.
*/


/* 4.	For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, and also display the average 
Overall_Rating given by that specific consumer across all their ratings.*/
SELECT r.Consumer_ID,
       r.Restaurant_ID,
       r.Overall_Rating,
       AVG(r.Overall_Rating) OVER (PARTITION BY r.Consumer_ID) AS Consumer_Avg_Overall
FROM Ratings r
ORDER BY r.Consumer_ID, r.Restaurant_ID;
/*EXPLANATION
- Window function: Average per consumer across all their ratings.
- Output: Per-rating row enriched with consumer’s average.
Step-by-Step Explanation
- Base Table
FROM Ratings r
- We start with the Ratings table, which contains all ratings given by consumers to restaurants.
- Columns Selected
SELECT r.Consumer_ID,
       r.Restaurant_ID,
       r.Overall_Rating,
- For each rating, we want to see:
- The Consumer_ID (who gave the rating).
- The Restaurant_ID (which restaurant was rated).
- The Overall_Rating (the score given).
- Window Function: Average per Consumer
AVG(r.Overall_Rating) OVER (PARTITION BY r.Consumer_ID) AS Consumer_Avg_Overall
- AVG() is an aggregate function, but here it’s used as a window function.
- OVER (PARTITION BY r.Consumer_ID) means:
- For each consumer, calculate the average of all their overall ratings.
- This average is then displayed alongside each individual rating row.
- So every rating row shows both:
- The specific rating.
- The consumer’s overall average rating across all restaurants.
- Ordering
ORDER BY r.Consumer_ID, r.Restaurant_ID;
- Results are sorted first by consumer, then by restaurant.
- Makes it easier to see each consumer’s ratings grouped together.
In short:
This query shows each rating row but also adds a column with the consumer’s average overall rating across all 
their ratings. That way you can compare whether a particular rating was above, below, or equal to their personal average.
*/



/* 5.	Using a CTE, identify students who have a 'Low' budget. Then, for each of these students, 
 list their top 3 most preferred cuisines based on the order they appear in the Consumer_Preferences table 
 (assuming no explicit preference order, use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).*/
WITH LowBudgetStudents AS (
    SELECT Consumer_ID
    FROM Consumers
    WHERE Occupation = 'Student' AND Budget = 'Low'
),
PrefRank AS (
    SELECT cp.Consumer_ID,
           cp.Preferred_Cuisine,
           ROW_NUMBER() OVER (
               PARTITION BY cp.Consumer_ID
               ORDER BY cp.Consumer_ID, cp.Preferred_Cuisine
           ) AS rn
    FROM Consumer_Preferences cp
    JOIN LowBudgetStudents s ON s.Consumer_ID = cp.Consumer_ID
)
SELECT Consumer_ID, Preferred_Cuisine
FROM PrefRank
WHERE rn <= 3
ORDER BY Consumer_ID, rn;
/*EXPLANATION:- CTE #1: LowBudgetStudents
WITH LowBudgetStudents AS (
    SELECT Consumer_ID
    FROM Consumers
    WHERE Occupation = 'Student' AND Budget = 'Low'
)
- Filters the Consumers table to only those who are:
- Occupation = Student
- Budget = Low
- Produces a list of Consumer_IDs who qualify.
- CTE #2: PrefRank
PrefRank AS (
    SELECT cp.Consumer_ID,
           cp.Preferred_Cuisine,
           ROW_NUMBER() OVER (
               PARTITION BY cp.Consumer_ID
               ORDER BY cp.Consumer_ID, cp.Preferred_Cuisine
           ) AS rn
    FROM Consumer_Preferences cp
    JOIN LowBudgetStudents s ON s.Consumer_ID = cp.Consumer_ID
)
- Joins the filtered students with their cuisine preferences.
- Uses ROW_NUMBER() window function:
- PARTITION BY cp.Consumer_ID → restart numbering for each student.
- ORDER BY cp.Consumer_ID, cp.Preferred_Cuisine → assigns a sequential number to each cuisine for that student.
- Result: each student’s cuisines are numbered (rn = 1, 2, 3, …).
- Final SELECT
SELECT Consumer_ID, Preferred_Cuisine
FROM PrefRank
WHERE rn <= 3
ORDER BY Consumer_ID, rn;
- Filters to only the top 3 cuisines per student (rn ≤ 3).
- Orders output by Consumer_ID and the assigned row number.
This query finds students with a low budget, then uses a row numbering 
technique to pick their top 3 preferred cuisines from the Consumer_Preferences table.
*/

/*6.	Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, 
 and the Overall_Rating of the next restaurant they rated (if any), ordered 
 by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first.*/
SELECT t.Restaurant_ID,
       t.Overall_Rating,
       LEAD(t.Overall_Rating) OVER (ORDER BY t.Restaurant_ID) AS Next_Overall_Rating
FROM (
    SELECT ra.Restaurant_ID, ra.Overall_Rating
    FROM Ratings ra
    WHERE ra.Consumer_ID = 'U1008'
) AS t
ORDER BY t.Restaurant_ID;
/*EXPLANATION:- Derived Table (t)
FROM (
    SELECT ra.Restaurant_ID, ra.Overall_Rating
    FROM Ratings ra
    WHERE ra.Consumer_ID = 'U1008'
) AS t
- Filters the Ratings table to only include rows for Consumer_ID = 'U1008'.
- Keeps only the Restaurant_ID and the Overall_Rating.
- This derived table (t) is the foundation for the next step.
- Main SELECT
SELECT t.Restaurant_ID,
       t.Overall_Rating,
       LEAD(t.Overall_Rating) OVER (ORDER BY t.Restaurant_ID) AS Next_Overall_Rating
- For each rating row:
- Show the Restaurant_ID.
- Show the Overall_Rating given by U1008.
- Use the LEAD() window function to look ahead to the next row (ordered by Restaurant_ID).
- LEAD(t.Overall_Rating) → fetches the next restaurant’s rating value.
- OVER (ORDER BY t.Restaurant_ID) → defines the order (Restaurant_ID acts as a proxy for time since rating timestamps aren’t available).
- Ordering
ORDER BY t.Restaurant_ID;
- Ensures the results are sorted by Restaurant_ID.
- This makes the "next rating" logic consistent.
In short:
This query:
- Filters ratings to Consumer U1008.
- Lists each restaurant they rated.
- Uses LEAD() to show the next rating’s Overall_Rating (based on Restaurant_ID order).
- Helps analyze rating progression across restaurants.
*/


/* 7.	Create a VIEW named HighlyRatedMexicanRestaurants that shows the Restaurant_ID, Name, and City of all Mexican 
 restaurants that have an average Overall_Rating greater than 1.5.*/
CREATE  VIEW  HighlyRatedMexicanRestaurants AS
SELECT r.Restaurant_ID,
       r.Name,
       r.City
FROM Restaurants r
JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY r.Restaurant_ID, r.Name, r.City
HAVING AVG(ra.Overall_Rating) > 1.5;

SELECT* FROM HighlyRatedMexicanRestaurants;
/* EXPLANATION: - Creating a View
CREATE OR REPLACE VIEW HighlyRatedMexicanRestaurants AS
- A view is a saved query that acts like a virtual table.
- Here, we’re creating a view named HighlyRatedMexicanRestaurants.
- OR REPLACE ensures if the view already exists, it will be updated.
- Selecting Columns
SELECT r.Restaurant_ID,
       r.Name,
       r.City
- We want to store the restaurant’s ID, Name, and City in the view.
- Joining Tables
FROM Restaurants r
JOIN Restaurant_Cuisines rc ON r.Restaurant_ID = rc.Restaurant_ID
JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
- Restaurants → gives us restaurant details.
- Restaurant_Cuisines → tells us which cuisine(s) each restaurant serves.
- Ratings → provides consumer ratings for restaurants.
- Joins ensure we can filter by cuisine and calculate average ratings.
- Filtering for Mexican Cuisine
WHERE rc.Cuisine = 'Mexican'
- Only restaurants serving Mexican cuisine are considered.
- Grouping and Aggregating
GROUP BY r.Restaurant_ID, r.Name, r.City
- Groups ratings by restaurant so we can calculate averages.
- Applying the Rating Threshold
HAVING AVG(ra.Overall_Rating) > 1.5;
- HAVING is used with aggregates.
- Only restaurants whose average Overall_Rating > 1.5 are included.
- This means only Mexican restaurants that are consistently rated above “Satisfactory” make it into the view.
In short:
This query creates a reusable view that lists all Mexican restaurants with an average rating above 1.5. 
You can now query this view directly instead of rewriting the logic each time.
*/


/*8.	First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. 
Then, using a CTE to find consumers who prefer 'Mexican' cuisine, list those consumers (Consumer_ID) who 
have not rated any restaurant listed in the HighlyRatedMexicanRestaurants view.*/
WITH MexicanConsumers AS (
    SELECT DISTINCT cp.Consumer_ID
    FROM Consumer_Preferences cp
    WHERE cp.Preferred_Cuisine = 'Mexican'
)
SELECT mc.Consumer_ID
FROM MexicanConsumers mc
WHERE NOT EXISTS (
    SELECT 1
    FROM Ratings ra
    JOIN HighlyRatedMexicanRestaurants h
      ON ra.Restaurant_ID = h.Restaurant_ID
    WHERE ra.Consumer_ID = mc.Consumer_ID
);
/*EXPLANATION:
- CTE: MexicanConsumers
WITH MexicanConsumers AS (
    SELECT DISTINCT cp.Consumer_ID
    FROM Consumer_Preferences cp
    WHERE cp.Preferred_Cuisine = 'Mexican'
)
- This Common Table Expression (CTE) finds all consumers who have Mexican listed as one of their preferred cuisines.
- DISTINCT ensures each consumer appears only once.
- Main Query
SELECT mc.Consumer_ID
FROM MexicanConsumers mc
- Starts with the list of Mexican-preferring consumers from the CTE.
- NOT EXISTS Subquery
WHERE NOT EXISTS (
    SELECT 1
    FROM Ratings ra
    JOIN HighlyRatedMexicanRestaurants h
      ON ra.Restaurant_ID = h.Restaurant_ID
    WHERE ra.Consumer_ID = mc.Consumer_ID
);
- For each consumer, checks if they have rated any restaurant that appears in the HighlyRatedMexicanRestaurants view (created in Q7).
- If such a rating exists, the consumer is excluded.
- If no rating exists, the consumer is included in the final result.
🎯 What the Query Produces
- A list of Consumer_IDs who:
- Prefer Mexican cuisine.
- Have not rated any Mexican restaurant with an average Overall_Rating > 1.5 (i.e., those in the view).
👉 In short:
This query identifies Mexican-preferring consumers who haven’t engaged with the top-rated Mexican restaurants. 
It’s useful for spotting potential marketing targets — people who like Mexican food but haven’t yet rated the best-performing 
Mexican restaurants.
*/


/* 9.	Create a stored procedure GetRestaurantRatingsAboveThreshold that accepts a Restaurant_ID and a minimum Overall_Rating as input.
 It should return the Consumer_ID, Overall_Rating, Food_Rating, and Service_Rating for that restaurant 
 where the Overall_Rating meets or exceeds the threshold.*/

DROP PROCEDURE IF EXISTS GetRestaurantRatingsAboveThreshold;
USE PROJECT;
DELIMITER //

CREATE PROCEDURE GetRestaurantRatingsAboveThreshold (
    IN p_Restaurant_ID INT,
    IN p_MinOverallRating DECIMAL(3,2)
)
BEGIN
    SELECT ra.Consumer_ID,
           ra.Overall_Rating,
           ra.Food_Rating,
           ra.Service_Rating
    FROM Ratings AS ra
    WHERE ra.Restaurant_ID = p_Restaurant_ID
      AND ra.Overall_Rating >= p_MinOverallRating
    ORDER BY ra.Overall_Rating DESC, ra.Consumer_ID;
END //

DELIMITER ;
CALL GetRestaurantRatingsAboveThreshold(132583, 1.0);

/*10.	Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type.
 If there are ties in rating, include all tied restaurants. Display Cuisine, Restaurant_Name, City, and Overall_Rating.*/
 WITH RestaurantAverages AS (
    SELECT r.Restaurant_ID,
           r.Name AS Restaurant_Name,
           r.City,
           AVG(ra.Overall_Rating) AS Avg_Overall
    FROM Restaurants r
    JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
    GROUP BY r.Restaurant_ID, r.Name, r.City
),
CuisineAverages AS (
    SELECT rc.Cuisine,
           ra.Restaurant_ID,
           ra.Restaurant_Name,
           ra.City,
           ra.Avg_Overall,
           DENSE_RANK() OVER (
               PARTITION BY rc.Cuisine
               ORDER BY ra.Avg_Overall DESC
           ) AS dr
    FROM Restaurant_Cuisines rc
    JOIN RestaurantAverages ra ON rc.Restaurant_ID = ra.Restaurant_ID
)
SELECT Cuisine,
       Restaurant_Name,
       City,
       Avg_Overall AS Overall_Rating
FROM CuisineAverages
WHERE dr <= 2
ORDER BY Cuisine, Avg_Overall DESC, Restaurant_Name;
 /*EXPLANATION:- CTE #1: RestaurantAverages
WITH RestaurantAverages AS (
    SELECT r.Restaurant_ID,
           r.Name AS Restaurant_Name,
           r.City,
           AVG(ra.Overall_Rating) AS Avg_Overall
    FROM Restaurants r
    JOIN Ratings ra ON r.Restaurant_ID = ra.Restaurant_ID
    GROUP BY r.Restaurant_ID, r.Name, r.City
)
- Calculates the average Overall_Rating for each restaurant.
- Groups by restaurant ID, name, and city.
- Produces one row per restaurant with its average rating.
- CTE #2: CuisineAverages
CuisineAverages AS (
    SELECT rc.Cuisine,
           ra.Restaurant_ID,
           ra.Restaurant_Name,
           ra.City,
           ra.Avg_Overall,
           DENSE_RANK() OVER (
               PARTITION BY rc.Cuisine
               ORDER BY ra.Avg_Overall DESC
           ) AS dr
    FROM Restaurant_Cuisines rc
    JOIN RestaurantAverages ra ON rc.Restaurant_ID = ra.Restaurant_ID
)
- Joins each restaurant to its cuisine(s).
- Uses DENSE_RANK() window function:
- PARTITION BY rc.Cuisine → restart ranking for each cuisine type.
- ORDER BY ra.Avg_Overall DESC → highest average ratings get rank 1, then 2, etc.
- DENSE_RANK ensures ties are handled correctly (if two restaurants tie for rank 1, both are included, and the next rank is 2).
- Final SELECT
SELECT Cuisine,
       Restaurant_Name,
       City,
       Avg_Overall AS Overall_Rating
FROM CuisineAverages
WHERE dr <= 2
ORDER BY Cuisine, Avg_Overall DESC, Restaurant_Name;
- Filters to only the top 2 ranks per cuisine (including ties).
- Displays cuisine, restaurant name, city, and average rating.
- Orders results by cuisine, then by rating (highest first).
👉 In short:
This query finds the top 2 highest-rated restaurants per cuisine type, using average overall rating and including ties.
It’s perfect for identifying the best-performing restaurants in each cuisine category.
*/

/*11.	First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. 
Then, using this view and a CTE, find the top 5 consumers by their average overall rating. For these top 5 consumers, 
list their Consumer_ID, their average rating, and the number of 'Mexican' restaurants they have rated.*/
--  Step 1: Create the View
CREATE  VIEW ConsumerAverageRatings AS
SELECT r.Consumer_ID,
       AVG(r.Overall_Rating) AS Avg_Overall
FROM Ratings r
GROUP BY r.Consumer_ID;
-- Step 2: Use the View + CTE to Find Top 5 Consumers
WITH TopConsumers AS (
    SELECT Consumer_ID,
           Avg_Overall,
           DENSE_RANK() OVER (ORDER BY Avg_Overall DESC) AS dr
    FROM ConsumerAverageRatings
)
, MexicanCounts AS (
    SELECT ra.Consumer_ID,
           COUNT(DISTINCT ra.Restaurant_ID) AS Mexican_Restaurants_Rated
    FROM Ratings ra
    JOIN Restaurant_Cuisines rc ON ra.Restaurant_ID = rc.Restaurant_ID
    WHERE rc.Cuisine = 'Mexican'
    GROUP BY ra.Consumer_ID
)
SELECT tc.Consumer_ID,
       tc.Avg_Overall,
       COALESCE(mc.Mexican_Restaurants_Rated, 0) AS Mexican_Restaurants_Rated
FROM TopConsumers tc
LEFT JOIN MexicanCounts mc ON tc.Consumer_ID = mc.Consumer_ID
WHERE tc.dr <= 5
ORDER BY tc.Avg_Overall DESC, tc.Consumer_ID;
/* Step-by-Step Explanation
- CTE: TopConsumers
WITH TopConsumers AS (
    SELECT Consumer_ID,
           Avg_Overall,
           DENSE_RANK() OVER (ORDER BY Avg_Overall DESC) AS dr
    FROM ConsumerAverageRatings
)
- Uses the view to rank consumers by their average rating.
- DENSE_RANK() ensures ties are handled correctly (if two consumers tie for rank 1, both are included, and the next rank is 2).
- Produces: Consumer_ID, Avg_Overall, rank.
- CTE: MexicanCounts
, MexicanCounts AS (
    SELECT ra.Consumer_ID,
           COUNT(DISTINCT ra.Restaurant_ID) AS Mexican_Restaurants_Rated
    FROM Ratings ra
    JOIN Restaurant_Cuisines rc ON ra.Restaurant_ID = rc.Restaurant_ID
    WHERE rc.Cuisine = 'Mexican'
    GROUP BY ra.Consumer_ID
)
- Counts how many distinct Mexican restaurants each consumer has rated.
- Produces: Consumer_ID, count of Mexican restaurants rated.
- Final SELECT
SELECT tc.Consumer_ID,
       tc.Avg_Overall,
       COALESCE(mc.Mexican_Restaurants_Rated, 0) AS Mexican_Restaurants_Rated
FROM TopConsumers tc
LEFT JOIN MexicanCounts mc ON tc.Consumer_ID = mc.Consumer_ID
WHERE tc.dr <= 5
ORDER BY tc.Avg_Overall DESC, tc.Consumer_ID;
- Joins the top consumers with their Mexican restaurant counts.
- COALESCE(..., 0) ensures consumers who haven’t rated any Mexican restaurants show 0 instead of NULL.
- Filters to only the top 5 consumers.
- Orders by highest average rating first.
👉 In short:
This query first creates a view of consumer average ratings, then uses a CTE to rank consumers, 
and finally counts how many Mexican restaurants those top 5 consumers have rated.
*/

/*12.	Create a stored procedure named GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.
The procedure should:
1.	Determine the consumer's "Spending Segment" based on their Budget:
○	'Low' -> 'Budget Conscious'
○	'Medium' -> 'Moderate Spender'
○	'High' -> 'Premium Spender'
○	NULL or other -> 'Unknown Budget'
*/

USE project;  -- replace with your schema name


DELIMITER //

CREATE PROCEDURE GetConsumerSpendingSegment (
    IN p_Consumer_ID VARCHAR(20)
)
BEGIN
    SELECT c.Consumer_ID,
           c.Budget,
           CASE
               WHEN c.Budget = 'Low' THEN 'Budget Conscious'
               WHEN c.Budget = 'Medium' THEN 'Moderate Spender'
               WHEN c.Budget = 'High' THEN 'Premium Spender'
               ELSE 'Unknown Budget'
           END AS Spending_Segment
    FROM Consumers c
    WHERE c.Consumer_ID = p_Consumer_ID;
END //

DELIMITER ;
CALL GetConsumerSpendingSegment();
/* Step-by-Step Explanation
- Procedure Definition
CREATE PROCEDURE GetConsumerSpendingSegment (
    IN p_Consumer_ID VARCHAR(20)
)
- Creates a stored procedure named GetConsumerSpendingSegment.
- It accepts one input parameter: p_Consumer_ID (the consumer’s ID).
- Main Query
SELECT c.Consumer_ID,
       c.Budget,
       CASE
           WHEN c.Budget = 'Low' THEN 'Budget Conscious'
           WHEN c.Budget = 'Medium' THEN 'Moderate Spender'
           WHEN c.Budget = 'High' THEN 'Premium Spender'
           ELSE 'Unknown Budget'
       END AS Spending_Segment
FROM Consumers c
WHERE c.Consumer_ID = p_Consumer_ID;
- Looks up the consumer in the Consumers table.
- Retrieves their Consumer_ID and Budget.
- Uses a CASE statement to map the budget value into a Spending Segment:
- Low → Budget Conscious
- Medium → Moderate Spender
- High → Premium Spender
- Anything else (NULL or unexpected) → Unknown Budget
- Filtering
WHERE c.Consumer_ID = p_Consumer_ID;
- Ensures the query only returns data for the specific consumer you pass in.
🎯 Example Call
CALL GetConsumerSpendingSegment('U1008');
Part 1 of the procedure is all about classifying a consumer into a spending segment 
based on their budget. It’s a simple mapping using a CASE statement, and you call it with the consumer’s ID to see their segment.



*/

/*
2.	For all restaurants rated by this consumer:
○	List the Restaurant_Name.
○	The Overall_Rating given by this consumer.
○	The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
○	A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 'At Average',
 or 'Below Average' compared to the restaurant's overall average rating.
○	Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).*/

USE project;  -- replace with your schema name

DELIMITER //

CREATE PROCEDURE GetConsumerRestaurantPerformance (
    IN p_Consumer_ID VARCHAR(20)
)
BEGIN
    SELECT r.Name AS Restaurant_Name,
           ra.Overall_Rating AS Consumer_Overall_Rating,
           avg_table.Avg_Overall AS Restaurant_Average_Overall,
           CASE
               WHEN ra.Overall_Rating > avg_table.Avg_Overall THEN 'Above Average'
               WHEN ra.Overall_Rating = avg_table.Avg_Overall THEN 'At Average'
               ELSE 'Below Average'
           END AS Performance_Flag,
           RANK() OVER (ORDER BY ra.Overall_Rating DESC, r.Name) AS Consumer_Rating_Rank
    FROM Ratings ra
    JOIN Restaurants r 
         ON ra.Restaurant_ID = r.Restaurant_ID
    JOIN (
        SELECT r2.Restaurant_ID, AVG(rat.Overall_Rating) AS Avg_Overall
        FROM Restaurants r2
        JOIN Ratings rat ON r2.Restaurant_ID = rat.Restaurant_ID
        GROUP BY r2.Restaurant_ID
    ) avg_table 
         ON ra.Restaurant_ID = avg_table.Restaurant_ID
    WHERE ra.Consumer_ID = p_Consumer_ID
    ORDER BY Consumer_Rating_Rank, r.Name;
END //

DELIMITER ;
CALL GetConsumerRestaurantPerformance('U1008');

/* Step-by-Step Explanation
- Procedure Definition
CREATE PROCEDURE GetConsumerRestaurantPerformance (
    IN p_Consumer_ID VARCHAR(20)
)
- Creates a procedure named GetConsumerRestaurantPerformance.
- Accepts one input parameter: the consumer’s ID.
- Ratings Table (ra)
- Filters ratings to only those given by the input consumer:
WHERE ra.Consumer_ID = p_Consumer_ID
- Restaurants Table (r)
- Joins to get the restaurant’s name (and city if needed).
- Subquery (avg_table)
SELECT r2.Restaurant_ID, AVG(rat.Overall_Rating) AS Avg_Overall
FROM Restaurants r2
JOIN Ratings rat ON r2.Restaurant_ID = rat.Restaurant_ID
GROUP BY r2.Restaurant_ID
- Calculates the average overall rating for each restaurant across all consumers.
- This gives the benchmark to compare against.
- Performance_Flag
CASE
    WHEN ra.Overall_Rating > avg_table.Avg_Overall THEN 'Above Average'
    WHEN ra.Overall_Rating = avg_table.Avg_Overall THEN 'At Average'
    ELSE 'Below Average'
END AS Performance_Flag
- Compares the consumer’s rating against the restaurant’s average.
- Flags whether their rating is Above, At, or Below the average.
- Ranking
RANK() OVER (ORDER BY ra.Overall_Rating DESC, r.Name) AS Consumer_Rating_Rank
- Ranks restaurants for this consumer based on their rating (highest = rank 1).
- If two restaurants have the same rating, they share the same rank.
- Final Output
- Lists:
- Restaurant name
- Consumer’s rating
- Restaurant’s average rating
- Performance flag
- Rank for this consumer
👉 In short:
Part 2 of the procedure analyzes all restaurants rated by a consumer, compares their rating to the restaurant’s 
overall average, flags it as above/at/below average, and ranks the restaurants by the consumer’s rating.
*/












