DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Certificate;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS emp_dept;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Vaccinetype;

CREATE TABLE Employee (
    emp_no      SMALLINT auto_increment,
    emp_CPR     BIGINT(11),
    salary      DECIMAL(5,2),
    title		VARCHAR(15),
    email		TEXT(30),
    phone		INT(8),
    address		TEXT(100),
    PRIMARY KEY (emp_no)
);

create table Department(
	dept_no 	SMALLINT auto_increment,
	dept_name 	VARCHAR (25),
	city 		VARCHAR (15),
PRIMARY KEY (dept_no)
);

CREATE TABLE emp_dept (
    dept_no         SMALLINT,
    emp_no          SMALLINT,
PRIMARY KEY (dept_no , emp_no),
FOREIGN KEY (dept_no)
	REFERENCES Department (dept_no)
	ON DELETE CASCADE,
FOREIGN KEY (emp_no) REFERENCES Employee (emp_no)
	ON DELETE CASCADE
);

create table Vaccinetype(
	vaccine_type 	VARCHAR(10),
PRIMARY KEY (vaccine_type)
);

CREATE TABLE Stock(
	dept_no 		SMALLINT,
	vaccine_type 	VARCHAR (10),
	Amount 			SMALLINT,
PRIMARY KEY (dept_no, vaccine_type),
FOREIGN KEY (dept_no) 
	REFERENCES Department(dept_no),
FOREIGN KEY (vaccine_type) 
	REFERENCES Vaccinetype(vaccine_type)
);

CREATE TABLE Appointments (
	daily_appointment_ID	DATE,
	CPR				        INT(11),
	customer_name			VARCHAR(15),
	appointment_date		DATE,
	appointment_time	    DATE,
	vaccine_type	        VARCHAR(10),
	city			        VARCHAR(20),
PRIMARY KEY(CPR, daily_appointment_ID),
FOREIGN KEY (vaccine_type) 
	REFERENCES Vaccinetype(vaccine_type)
);

CREATE TABLE Customer (
	CPR				INT(11),
	emp_no			SMALLINT auto_increment,
PRIMARY KEY (CPR),
FOREIGN KEY (emp_no) 
	REFERENCES Employee(emp_no),
FOREIGN KEY (CPR)
	REFERENCES Appointments(CPR)
);

CREATE TABLE Person (
	CPR			INT(11),
    first_name	VARCHAR(15),
    surname		VARCHAR(20),
PRIMARY KEY (CPR, first_name, surname),
FOREIGN KEY (CPR)
	REFERENCES Appointments(CPR)
);

create table Certificate(
certificate_no          SMALLINT auto_increment,
Vaccine_type            VARCHAR(10),
certified_date          DATE,
emp_no                  SMALLINT,
PRIMARY KEY (certificate_no),
FOREIGN KEY (emp_no) REFERENCES Employee (emp_no),
FOREIGN KEY (vaccine_type) REFERENCES Vaccinetype(vaccine_type)
);


INSERT Employee VALUES
(NULL, 2447965342, 160, 'manager', 'marcus@gmail.com' , 34256236, 'tøjmestervej 16 3tv'),
(NULL, 2443933442, 160, 'manager', 'marcus@gmail.com' , 34256236, 'tøjmestervej 16 3tv');
SELECT * FROM Employee;