-- Liberary Management Project -3
create database liberary_management;
use liberary_management;
-- create first table name branch
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(10) NOT NULL PRIMARY KEY,
    manager_id VARCHAR(10) NOT NULL,
    branch_address VARCHAR(100),
    contact_num VARCHAR(15)
);
-- CREATING SECOND TABLE EMPLOYEE 
CREATE TABLE employeeS (
emp_id VARCHAR(10) NOT NULL PRIMARY KEY , 
emp_name VARCHAR(25) NOT NULL ,
position VARCHAR(20) NOT NULL ,
salary INT NOT NULL ,
branch_id VARCHAR(15) NOT NULL
);
-- CREATING THIRD TABLE BOOKS 
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(85),
    category VARCHAR(15),
    rental_price FLOAT,
    status VARCHAR(15),
    author VARCHAR(35),
    publisher VARCHAR(55)
);
-- CREATING NEXT TABLE MEMBER
CREATE TABLE members (
member_id VARCHAR(20) PRIMARY KEY,
member_name VARCHAR(25),
member_address VARCHAR(75),
reg_date DATE
);



