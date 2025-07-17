-- Database Creation
CREATE DATABASE MovieRental;
USE MovieRental;

-- Table Creation

CREATE TABLE rental_data (
    MOVIE_ID INTEGER,
    CUSTOMER_ID INTEGER,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE DECIMAL(10,2)
);
-- Data Insertion
INSERT INTO rental_data VALUES
(1, 101, 'Action', '2025-01-01', '2025-01-03', 5.99),
(2, 102, 'Drama', '2025-01-15', '2025-01-17', 4.99),
(3, 103, 'Comedy', '2025-02-01', '2025-02-03', 4.99),
(4, 101, 'Action', '2025-02-15', '2025-02-17', 5.99),
(5, 104, 'Drama', '2025-03-01', '2025-03-03', 4.99),
(6, 105, 'Action', '2025-03-15', '2025-03-17', 5.99),
(7, 102, 'Comedy', '2025-04-01', '2025-04-03', 4.99),
(8, 103, 'Drama', '2025-04-15', '2025-04-17', 4.99),
(9, 106, 'Action', '2025-05-01', '2025-05-03', 5.99),
(10, 104, 'Comedy', '2025-05-15', '2025-05-17', 4.99),
(11, 107, 'Drama', '2025-05-20', '2025-05-22', 4.99),
(12, 108, 'Action', '2025-05-25', '2025-05-27', 5.99),
(13, 109, 'Comedy', '2025-05-30', '2025-06-01', 4.99);

-- OLAP Operations
 -- Drill Down (from genre to individual movie level):
 
-- Individual movies within genre
SELECT GENRE, MOVIE_ID, COUNT(*) as rental_count, SUM(RENTAL_FEE) as total_fee
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- Rollup 
SELECT GENRE, SUM(RENTAL_FEE) as total_fee
FROM rental_data
GROUP BY GENRE WITH ROLLUP;

-- cube
SELECT 
    GENRE,
    YEAR(RENTAL_DATE) as year,
    MONTH(RENTAL_DATE) as month,
    CUSTOMER_ID,
    SUM(RENTAL_FEE) as total_fee
FROM rental_data
GROUP BY GENRE, YEAR(RENTAL_DATE), MONTH(RENTAL_DATE), CUSTOMER_ID WITH ROLLUP;

-- SLICE
SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- Dice 

-- Assuming current date is 2025-05-15
SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= '2025-02-15'
AND RENTAL_DATE <= '2025-05-15'
ORDER BY RENTAL_DATE;