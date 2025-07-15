CREATE DATABASE LibraryManagement;

USE LibraryManagement;

-- Create Books table
CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100) NOT NULL,
    AUTHOR VARCHAR(100) NOT NULL,
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT DEFAULT 1
);

-- Create Members table
CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    PHONE_NO VARCHAR(15),
    ADDRESS VARCHAR(200),
    MEMBERSHIP_DATE DATE
);

-- Create BorrowingRecords table
CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

-- Insert sample books
INSERT INTO Books VALUES
(1, 'The Guide', 'R.K. Narayan', 'Fiction', 1958, 3),
(2, 'Train to Pakistan', 'Khushwant Singh', 'Historical Fiction', 1956, 2),
(3, 'The God of Small Things', 'Arundhati Roy', 'Literary Fiction', 1997, 4),
(4, 'Wings of Fire', 'A.P.J. Abdul Kalam', 'Autobiography', 1999, 5),
(5, 'Midnight''s Children', 'Salman Rushdie', 'Magical Realism', 1981, 2),
(6, 'The Immortals of Meluha', 'Amish Tripathi', 'Mythology', 2010, 3),
(7, 'Sacred Games', 'Vikram Chandra', 'Crime Fiction', 2006, 2),
(8, '2 States', 'Chetan Bhagat', 'Romance', 2009, 4);

-- Insert sample members
INSERT INTO Members VALUES
(101, 'Priya Sharma', 'priya@email.com', '9876543210', 'Mumbai', '2023-01-15'),
(102, 'Rahul Kumar', 'rahul@email.com', '8765432109', 'Delhi', '2023-02-20'),
(103, 'Anjali Desai', 'anjali@email.com', '7654321098', 'Bangalore', '2023-03-10'),
(104, 'Amit Patel', 'amit@email.com', '6543210987', 'Ahmedabad', '2023-04-05'),
(105, 'Deepika Singh', 'deepika@email.com', '5432109876', 'Chennai', '2023-05-01');

-- Insert sample borrowing records
INSERT INTO BorrowingRecords VALUES
(1, 101, 1, '2023-06-01', '2023-06-15'),
(2, 102, 3, '2023-06-05', NULL),
(3, 103, 2, '2023-06-10', '2023-06-25'),
(4, 101, 4, '2023-07-01', NULL),
(5, 104, 5, '2023-07-05', '2023-07-20'),
(6, 102, 6, '2023-07-10', NULL),
(7, 103, 7, '2023-07-15', NULL),
(8, 105, 8, '2023-07-20', '2023-08-05');

-- Information Retrieval Queries

-- a) Books borrowed by specific member
SELECT b.TITLE, b.AUTHOR, br.BORROW_DATE, br.RETURN_DATE
FROM Books b
JOIN BorrowingRecords br ON b.BOOK_ID = br.BOOK_ID
WHERE br.MEMBER_ID = 101;

-- b) Members with overdue books
SELECT m.NAME, b.TITLE, br.BORROW_DATE
FROM Members m
JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
WHERE br.RETURN_DATE IS NULL 
AND DATEDIFF(CURRENT_DATE, br.BORROW_DATE) > 30;

-- c) Books by genre with available copies
SELECT GENRE, COUNT(*) as TOTAL_BOOKS, SUM(AVAILABLE_COPIES) as TOTAL_COPIES
FROM Books
GROUP BY GENRE;

-- d) Most borrowed books
SELECT b.TITLE, COUNT(*) as BORROW_COUNT
FROM Books b
JOIN BorrowingRecords br ON b.BOOK_ID = br.BOOK_ID
GROUP BY b.TITLE
ORDER BY BORROW_COUNT DESC
LIMIT 1;

-- e) Members who borrowed from 3+ genres
SELECT m.NAME, COUNT(DISTINCT b.GENRE) as GENRES_BORROWED
FROM Members m
JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY m.NAME
HAVING GENRES_BORROWED >= 3;

-- Calculate total books borrowed per month:
SELECT 
    YEAR(BORROW_DATE) as Year,
    MONTH(BORROW_DATE) as Month,
    COUNT(*) as Total_Books_Borrowed
FROM BorrowingRecords
GROUP BY YEAR(BORROW_DATE), MONTH(BORROW_DATE)
ORDER BY Year, Month;

-- Top three most active members:
SELECT 
    m.NAME,
    COUNT(br.BORROW_ID) as Books_Borrowed
FROM Members m
JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
GROUP BY m.MEMBER_ID, m.NAME
ORDER BY Books_Borrowed DESC
LIMIT 3;

-- Authors whose books were borrowed at least 10 times:
SELECT 
    b.AUTHOR,
    COUNT(br.BORROW_ID) as Times_Borrowed
FROM Books b
JOIN BorrowingRecords br ON b.BOOK_ID = br.BOOK_ID
GROUP BY b.AUTHOR
HAVING COUNT(br.BORROW_ID) >= 10
ORDER BY Times_Borrowed DESC;

-- Members who have never borrowed a book:
SELECT 
    m.NAME,
    m.EMAIL
FROM Members m
LEFT JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
WHERE br.BORROW_ID IS NULL;
