DROP DATABASE IF EXISTS Sale_Management;
CREATE DATABASE Sale_Management;
USE Sale_Management;

CREATE TABLE Customers (
	Customer_id				INT,
	First_name				VARCHAR(50),
	Last_name				VARCHAR(50),
	Email_address 			VARCHAR(100),
	Number_of_complaints	INT
);

CREATE TABLE Sale (
	Purchase_number		INT,
    Date_of_purchase	DATE,
    Customer_id			INT,
    Item_code			VARCHAR(50)
);

CREATE TABLE Items (
	Item_code 		VARCHAR(50),
    Item			VARCHAR(50),
    Unit_price_usd 	INT,
    Company_id		INT,
    Company			VARCHAR(50),
    Phone_number	VARCHAR(100)
);

