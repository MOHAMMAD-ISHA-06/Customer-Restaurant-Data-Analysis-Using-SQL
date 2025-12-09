🍽️ Restaurant Ratings SQL Project
A Complete Consumer–Restaurant Analytics System Using SQL
📌 Project Overview

This SQL project analyzes consumer behavior, restaurant preferences, cuisine trends, and rating patterns using advanced SQL techniques.

The database consists of the following tables:

consumers — demographic attributes

restaurants — restaurant information

ratings — ratings given by consumers

restaurant_cuisines — cuisine categories for each restaurant

🧰 Technologies & SQL Features Used

MySQL

JOIN operations (INNER, LEFT)

Aggregations: COUNT, AVG, MAX, MIN

CTEs

Subqueries

Views

**Stored Procedures`

🔻 SQL Tasks & Queries

Below are the analytical SQL queries performed in the project.

🔍 1. Students Who Are Also Smokers
SELECT consumer_id, age, occupation
FROM consumers
WHERE occupation = 'Student' AND smoker = 'Yes';

⭐ 2. Highly Satisfactory Ratings (Overall Rating = 2)
SELECT consumer_id, restaurant_id, overall_rating
FROM ratings
WHERE overall_rating = 2;

🏙️ 3. Consumers Who Rated Restaurants in 'San Luis Potosi'
SELECT DISTINCT c.consumer_id, c.age
FROM consumers c
JOIN ratings rt ON c.consumer_id = rt.consumer_id
JOIN restaurants r ON rt.restaurant_id = r.restaurant_id
WHERE r.city = 'San Luis Potosi';

🌮 4. Mexican Restaurants Rated by Consumer 'U1001'
SELECT r.name
FROM restaurants r
JOIN restaurant_cuisines rc ON r.restaurant_id = rc.restaurant_id
JOIN ratings rt ON r.restaurant_id = rt.restaurant_id
WHERE rc.cuisine = 'Mexican' AND rt.consumer_id = 'U1001';

🚫 5. Consumers Who Rated Restaurants BUT Not Italian Cuisine
SELECT DISTINCT c.consumer_id, c.age, c.occupation
FROM consumers c
JOIN ratings rt ON c.consumer_id = rt.consumer_id
WHERE c.consumer_id NOT IN (
  SELECT rt1.consumer_id
  FROM ratings rt1
  JOIN restaurant_cuisines rc ON rc.restaurant_id = rt1.restaurant_id
  WHERE rc.cuisine = 'Italian'
);

🎓 6. Students Who Rated More Than 2 Restaurants
SELECT rt.consumer_id, COUNT(rt.restaurant_id) AS no_of_restaurants
FROM ratings rt
JOIN consumers c ON c.consumer_id = rt.consumer_id
WHERE c.occupation = 'Student'
GROUP BY rt.consumer_id
HAVING COUNT(rt.restaurant_id) > 2;

📌 7. CTE – Consumers in San Luis Potosí + Mexican Restaurants Rated Highly
WITH con_in_San AS (
    SELECT * FROM consumers WHERE city = 'San Luis Potosi'
)
SELECT DISTINCT con.consumer_id, con.age, r.name
FROM con_in_San con
JOIN ratings rt ON con.consumer_id = rt.consumer_id
JOIN restaurants r ON r.restaurant_id = rt.restaurant_id
JOIN restaurant_cuisines rc ON r.restaurant_id = rc.restaurant_id
WHERE rc.cuisine = 'Mexican' AND rt.overall_rating = 2;

📊 8. Average Age of Consumers by Occupation
SELECT c.occupation, AVG(age) AS avg_age
FROM consumers c
JOIN (
    SELECT DISTINCT consumer_id FROM ratings
) AS rated_consumers
ON c.consumer_id = rated_consumers.consumer_id
GROUP BY c.occupation;

🏆 9. View of Highly Rated Mexican Restaurants (Avg Rating > 1.5)
CREATE VIEW HighlyRatedMexicanRestaurants AS
SELECT r.restaurant_id, r.name, r.city
FROM restaurants r
JOIN restaurant_cuisines rc ON r.restaurant_id = rc.restaurant_id
JOIN ratings rt ON r.restaurant_id = rt.restaurant_id
WHERE rc.cuisine = 'Mexican'
GROUP BY r.restaurant_id, r.name, r.city
HAVING AVG(rt.overall_rating) > 1.5;

🛠️ 10. Stored Procedure: Get Ratings Above Threshold
DELIMITER $$
CREATE PROCEDURE GetRestaurantRatingsAboveThresholds (
    IN p_restaurant_id VARCHAR(20),
    IN p_min_overall_rating INT
)
BEGIN
    SELECT consumer_id, overall_rating, food_rating, service_rating
    FROM ratings
    WHERE restaurant_id = p_restaurant_id
      AND overall_rating >= p_min_overall_rating;
END $$
DELIMITER ;

🎯 Key Skills Demonstrated

✔ Data filtering and customer segmentation
✔ Multi-table JOIN operations
✔ Analytical SQL using CTEs
✔ Aggregations and business insights
✔ Creating reusable database objects (Views & Procedures)
✔ Consumer behavior & cuisine preference analysis
