# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `liberary_management`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## Objectives 

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

- **Database Creation**: Created a database named 'liberary_management`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE liberary_management;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(10) NOT NULL PRIMARY KEY,
    manager_id VARCHAR(10) NOT NULL,
    branch_address VARCHAR(100),
    contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) NOT NULL PRIMARY KEY,
    emp_name VARCHAR(25) NOT NULL,
    position VARCHAR(20) NOT NULL,
    salary INT NOT NULL,
    branch_id VARCHAR(15) NOT NULL
);



-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(20) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(75),
    reg_date DATE
);




-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(85),
    category VARCHAR(50),
    rental_price FLOAT,
    status VARCHAR(15),
    author VARCHAR(35),
    publisher VARCHAR(55)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issue_id VARCHAR(20) PRIMARY KEY,
    issue_member_id VARCHAR(20),
    issue_book_name VARCHAR(100),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(25)
);


-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
    return_id VARCHAR(25),
    issued_id VARCHAR(25),
    return_book_name VARCHAR(50),
    return_date VARCHAR(50),
    return_book_isbn VARCHAR(50)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT 
    issue_member_id, COUNT(*) AS number_of_books
FROM
    issued_status
GROUP BY issue_member_id
HAVING COUNT(*) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_cnt AS (SELECT b.isbn,
    b.book_title,
    COUNT(issue_member_id) AS book_issued_count FROM
    issued_status AS ist
        JOIN
    books AS b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn , b.book_title);

```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books with their Category**:

```sql
SELECT 
    (b.category) AS category, ist.issue_book_name AS book_name
FROM
    books AS b
        JOIN
    issued_status AS ist ON b.isbn = ist.issued_book_isbn
ORDER BY category;
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
    b.category AS category,
    SUM(b.rental_price) AS rent_of_each_cat,
    COUNT(ist.issue_book_name) AS total_issue_books,
    (SUM(b.rental_price) * COUNT(ist.issue_book_name)) AS rental_price
FROM
    books AS b
        JOIN
    issued_status AS ist ON b.isbn = ist.issued_book_isbn
GROUP BY category;
```

9. **List Members Who Registered in the Last 365 Days**:
```sql
SELECT 
    *
FROM
    members
WHERE
    reg_date >= CURRENT_DATE - INTERVAL 365 DAY;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name AS manager
FROM
    employees AS e1
        JOIN
    branch AS b ON e1.branch_id = b.branch_id
        JOIN
    employees AS e2 ON e2.emp_id = b.manager_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold like rent price is 6**:
```sql
CREATE TABLE books_with_rentprice (SELECT * FROM
    books
WHERE
    rental_price > 6.0);
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
    *
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS r ON r.issued_id = ist.issued_id
WHERE
    r.return_id IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
    ist.issue_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF(CURRENT_DATE, ist.issued_date) AS over_dues_days
FROM
    issued_status AS ist
        JOIN
    members AS m ON m.member_id = ist.issue_member_id
        JOIN
    books AS bk ON bk.isbn = ist.issued_book_isbn
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
WHERE
    rs.return_date IS NULL
        AND DATEDIFF(CURRENT_DATE, ist.issued_date) > 30
ORDER BY 1;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

DELIMITER $$
-- creating a procedure 
CREATE PROCEDURE auto_return_status(p_return_id VARCHAR(25) , p_issued_id VARCHAR(25))
BEGIN 
-- declaring a variables  
DECLARE v_isbn VARCHAR(50);
DECLARE v_book_name VARCHAR(100);
-- inserting values to result_status 
INSERT INTO return_status(return_id , issued_id , return_date)
VALUES (p_return_id , p_issued_id , CURRENT_DATE);
--  selct data from issued status into those declare variables
SELECT 
    issued_book_isbn, issue_book_name
INTO v_isbn , v_book_name FROM
    issued_status
WHERE
    issued_id = p_issued_id;
-- update books table 
UPDATE books 
SET 
    status = 'yes'
WHERE
    isbn = v_isbn;
-- showing output mesage to all 
SELECT 
    CONCAT('THANK YOU FOR RETURNING THE BOOK :',
            v_book_name) AS Message;
END $$

DELIMITER ;
-- call that procedure function 
CALL auto_return_status('RS045', 'IS134');
   

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

```



**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_reports AS SELECT b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS total_issued_books,
    COUNT(r.return_id) AS total_books_returns,
    SUM(bk.rental_price) AS total_rentals FROM
    branch AS b
        JOIN
    employees AS e ON b.branch_id = e.branch_id
        JOIN
    issued_status AS ist ON ist.issued_emp_id = e.emp_id
        JOIN
    books AS bk ON ist.issued_book_isbn = bk.isbn
        LEFT JOIN
    return_status AS r ON ist.issued_id = r.issued_id
GROUP BY b.branch_id
ORDER BY b.branch_id;

SELECT * FROM branch_reports;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members AS SELECT DISTINCT m.member_id, m.member_name FROM
    members AS m
        JOIN
    issued_status AS ist ON m.member_id = ist.issue_member_id
WHERE
    DATEDIFF(CURRENT_DATE, ist.issued_date) <= 270;

SELECT 
    *
FROM
    active_members;

SELECT * FROM active_members;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
    e.emp_id,
    e.emp_name,
    e.branch_id,
    COUNT(issued_emp_id) AS number_of_issue
FROM
    employees AS e
        JOIN
    issued_status AS ist ON e.emp_id = ist.issued_emp_id
GROUP BY e.emp_id
ORDER BY COUNT(issued_emp_id) DESC
LIMIT 3;
```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    


**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

DELIMITER $$
DROP PROCEDURE IF EXISTS book_available;

CREATE PROCEDURE book_available(
    p_issued_id VARCHAR(50),
    p_issue_member_id VARCHAR(20),
    p_issued_book_isbn VARCHAR(50),
    p_issued_emp_id VARCHAR(25)
)
BEGIN 
    DECLARE v_status VARCHAR(15);

    -- Retrieve book status
    SELECT status

        INTO v_status 
    FROM books 
    WHERE isbn = p_issued_book_isbn;
  
    -- Check if the book is available
    IF v_status = 'yes' THEN
        -- Insert issuance record
        INSERT INTO issued_status(
            issued_id, issue_member_id, issued_date, issued_book_isbn, issued_emp_id
        )
        VALUES (
            p_issued_id, p_issue_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id
        );
  UPDATE books 
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        -- Success message
        SELECT CONCAT('This book is issued successfully: ', p_issued_book_isbn) AS Message;

    ELSE 
        -- Failure message
        SELECT 'SORRY THIS BOOK IS NOT AVAILABLE RIGHT NOW' AS Message;
    END IF;
END $$

DELIMITER ;

CALL book_available('IS176', 'C101', '978-0-14-143951-8', 'E108');

```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines.
    
```sql
CREATE TABLE total_fines
         AS    
(SELECT 
    ist.issue_member_id,
    COUNT(ist.issue_book_name) AS no_of_issued_books,
    COUNT(CASE
        WHEN
            DATEDIFF(CURRENT_DATE, ist.issued_date) > 30
                AND r.return_date IS NULL
        THEN
            1
        ELSE NULL
    END) AS overdue_books_count,
    SUM(CASE
        WHEN
            DATEDIFF(CURRENT_DATE, ist.issued_date) > 30
                AND r.return_date IS NULL
        THEN
            (0.50 * (DATEDIFF(CURRENT_DATE, issued_date) - 30))
        ELSE 0
    END) AS total_fines
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS r ON ist.issued_id = r.issued_id
GROUP BY ist.issue_member_id
ORDER BY ist.issue_member_id) ;
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


## Author - Sahil Rawat

Thank you for your interest in this project!
