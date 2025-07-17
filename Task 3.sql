-- Create the database

CREATE DATABASE OnlineStore;

-- Use the database
USE OnlineStore;

-- Create Customers table
CREATE TABLE Customers (
    CUSTOMER_ID INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    PHONE VARCHAR(20),
    ADDRESS TEXT
);

-- Create Products table
CREATE TABLE Products (
    PRODUCT_ID INT AUTO_INCREMENT PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100),
    CATEGORY VARCHAR(50),
    PRICE DECIMAL(10, 2),
    STOCK INT
);

-- Create Orders table
CREATE TABLE Orders (
    ORDER_ID INT AUTO_INCREMENT PRIMARY KEY,
    CUSTOMER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT,
    ORDER_DATE DATE,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);
-- Insert sample customers
INSERT INTO Customers (NAME, EMAIL, PHONE, ADDRESS) VALUES
('Aarav Sharma', 'aarav@email.com', '9876540001', 'Mumbai, Maharashtra'),
('Zara Patel', 'zara@email.com', '9876540002', 'Delhi, NCR'),
('Vihaan Singh', 'vihaan@email.com', '9876540003', 'Bangalore, Karnataka'),
('Anaya Reddy', 'anaya@email.com', '9876540004', 'Hyderabad, Telangana'),
('Advait Kapoor', 'advait@email.com', '9876540005', 'Chennai, Tamil Nadu'),
('Ishaan Mehra', 'ishaan@email.com', '9876540006', 'Pune, Maharashtra'),
('Myra Joshi', 'myra@email.com', '9876540007', 'Kolkata, West Bengal'),
('Arjun Kumar', 'arjun@email.com', '9876540008', 'Ahmedabad, Gujarat'),
('Aanya Malhotra', 'aanya@email.com', '9876540009', 'Jaipur, Rajasthan'),
('Reyansh Verma', 'reyansh@email.com', '9876540010', 'Lucknow, UP');

-- Insert sample products
INSERT INTO Products (PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
('Smart Watch Pro', 'Electronics', 15000.00, 50),
('Premium Yoga Mat', 'Fitness', 1200.00, 100),
('Wireless Earbuds Plus', 'Electronics', 8000.00, 75),
('Whey Protein 1kg', 'Fitness', 2500.00, 200),
('4K Smart LED TV', 'Electronics', 35000.00, 25),
('Gaming Laptop', 'Electronics', 85000.00, 30),
('Running Shoes', 'Fitness', 4500.00, 150),
('Bluetooth Speaker', 'Electronics', 3000.00, 80),
('Fitness Band', 'Electronics', 2800.00, 120),
('Gym Bag', 'Fitness', 1500.00, 90);

-- Insert sample orders 
INSERT INTO Orders (CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1, 1, 2, '2025-01-15'),
(2, 3, 1, '2025-02-02'),
(3, 2, 3, '2025-02-10'),
(4, 5, 1, '2025-03-22'),
(5, 4, 2, '2025-03-08'),
(6, 6, 1, '2025-04-19'),
(7, 8, 2, '2025-04-05'),
(8, 7, 1, '2025-05-12'),
(9, 9, 3, '2025-05-28'),
(10, 10, 1, '2025-06-15'),
(1, 3, 1, '2025-06-20'),
(2, 5, 2, '2025-07-01');

-- Order Management Queries:
-- Retrieve all orders placed by a specific customer:

SELECT 
    c.NAME AS Customer_Name,
    p.PRODUCT_NAME,
    o.QUANTITY,
    p.PRICE,
    (o.QUANTITY * p.PRICE) AS Total_Amount,
    o.ORDER_DATE
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
WHERE c.CUSTOMER_ID = 2  -- Change this number to search for different customers
ORDER BY o.ORDER_DATE;

-- Products that are OOS
SELECT 
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    PRICE,
    STOCK
FROM Products
WHERE STOCK = 0
ORDER BY PRODUCT_NAME;

-- Calculate the total revenue generated per product:
SELECT 
    p.PRODUCT_NAME,
    p.CATEGORY,
    SUM(o.QUANTITY) AS Total_Units_Sold,
    p.PRICE AS Unit_Price,
    SUM(o.QUANTITY * p.PRICE) AS Total_Revenue
FROM Products p
LEFT JOIN Orders o ON p.PRODUCT_ID = o.PRODUCT_ID
GROUP BY p.PRODUCT_ID, p.PRODUCT_NAME, p.CATEGORY, p.PRICE
ORDER BY Total_Revenue DESC;


-- Retrieve the top 5 customers by total purchase amount:
SELECT 
    c.NAME AS Customer_Name,
    COUNT(o.ORDER_ID) AS Total_Orders,
    SUM(o.QUANTITY) AS Total_Items_Purchased,
    ROUND(SUM(o.QUANTITY * p.PRICE), 2) AS Total_Purchase_Amount
FROM Customers c
JOIN Orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID, c.NAME
ORDER BY Total_Purchase_Amount DESC
LIMIT 5;

-- Find customers who placed orders in at least two different product categories:
SELECT 
    c.NAME AS Customer_Name,
    COUNT(DISTINCT p.CATEGORY) AS Different_Categories_Ordered
FROM Customers c
JOIN Orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID, c.NAME
HAVING COUNT(DISTINCT p.CATEGORY) >= 2
ORDER BY Different_Categories_Ordered DESC;

-- Analytics
-- month with the highest total sales

SELECT 
    MONTHNAME(ORDER_DATE) AS Month,
    YEAR(ORDER_DATE) AS Year,
    COUNT(ORDER_ID) AS Total_Orders,
    SUM(o.QUANTITY) AS Total_Items_Sold,
    ROUND(SUM(o.QUANTITY * p.PRICE), 2) AS Total_Sales
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY YEAR(ORDER_DATE), MONTH(ORDER_DATE), MONTHNAME(ORDER_DATE)
ORDER BY Total_Sales DESC
LIMIT 1;

-- Identify products with no orders in the last 6 months:
SELECT 
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.CATEGORY,
    p.STOCK,
    p.PRICE,
    MAX(o.ORDER_DATE) AS Last_Order_Date
FROM Products p
LEFT JOIN Orders o ON p.PRODUCT_ID = o.PRODUCT_ID
WHERE o.ORDER_DATE IS NULL 
   OR o.ORDER_DATE < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
GROUP BY p.PRODUCT_ID, p.PRODUCT_NAME, p.CATEGORY, p.STOCK, p.PRICE
ORDER BY p.CATEGORY, p.PRODUCT_NAME;


c) Retrieve customers who have never placed an order:

    
-- Retrieve customers who have never placed an order:
SELECT 
    c.CUSTOMER_ID,
    c.NAME,
    c.EMAIL,
    c.PHONE,
    c.ADDRESS
FROM Customers c
LEFT JOIN Orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.ORDER_ID IS NULL;

-- Calculate the average order value across all orders:

SELECT 
    ROUND(AVG(order_total), 2) AS Average_Order_Value
FROM (
    SELECT 
        o.ORDER_ID,
        SUM(o.QUANTITY * p.PRICE) as order_total
    FROM Orders o
    JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
    GROUP BY o.ORDER_ID
) AS order_totals;



