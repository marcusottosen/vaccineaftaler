#DROP DATABASE vaccineberedskabet;
#CREATE DATABASE vaccineberedskabet;
#USE vaccineberedskabet;

DROP TABLE IF EXISTS Certificate;
DROP TABLE IF EXISTS Stock;
DROP TABLE IF EXISTS emp_dept;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Occurs;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Vaccinetype;

CREATE TABLE Employee (
    emp_no          SMALLINT auto_increment,
    emp_CPR         BIGINT(11),
    emp_name	    TEXT(50),
    title		    ENUM('Manager', 'Nurse', 'Doctor'),
    hours		    TINYINT,
    salary          DECIMAL(5,2),
    email		    TEXT(30),
    phone		    INT(8),
    city		    VARCHAR(20),
    street		    VARCHAR(20),
    house_no	    SMALLINT,
    address		    VARCHAR(50) GENERATED ALWAYS AS (CONCAT(city, ' ', street, ' ', house_no)) VIRTUAL,
    date_of_birth   DATE,
    PRIMARY KEY (emp_no)
);

create TABLE Department(
	dept_no 	    SMALLINT auto_increment,
	dept_name 	    VARCHAR (25),
	city		    VARCHAR(20),
    street		    VARCHAR(20),
    house_no	    SMALLINT,
	dept_address    VARCHAR(50) GENERATED ALWAYS AS (CONCAT(city, ' ', street, ' ', house_no)) VIRTUAL,
PRIMARY KEY (dept_no, city)
);

CREATE TABLE Occurs (
	city		VARCHAR(20),
    dept_no		SMALLINT,
    PRIMARY KEY (city),
    FOREIGN KEY (dept_no) REFERENCES Department (dept_no)
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
	vaccine_type 	ENUM('covaxx','aspera','blast3000','divoc'),
PRIMARY KEY (vaccine_type)
);

CREATE TABLE Stock(
	dept_no 		SMALLINT,
	vaccine_type 	ENUM('covaxx','aspera','blast3000','divoc'),
	Amount 			SMALLINT,
PRIMARY KEY (dept_no, vaccine_type),
FOREIGN KEY (dept_no) 
	REFERENCES Department(dept_no),
FOREIGN KEY (vaccine_type) 
	REFERENCES Vaccinetype(vaccine_type)
);

CREATE TABLE Customer (
	CPR				BIGINT(11),
	customer_name	TEXT(30),
	city		    VARCHAR(20),
    street		    VARCHAR(20),
    house_no	    SMALLINT,
    address		    VARCHAR(50) GENERATED ALWAYS AS (CONCAT(city, ' ', street, ' ', house_no)) VIRTUAL,
PRIMARY KEY (CPR)
);

create table Certificate(
certificate_no          SMALLINT auto_increment,
Vaccine_type            ENUM('covaxx','aspera','blast3000','divoc'),
certified_date          DATE,
emp_no                  SMALLINT,
PRIMARY KEY (certificate_no),
FOREIGN KEY (emp_no) REFERENCES Employee (emp_no),
FOREIGN KEY (vaccine_type) REFERENCES Vaccinetype(vaccine_type)
);

CREATE TABLE Appointment (
	daily_appointment_ID	SMALLINT auto_increment,
	CPR				        BIGINT(11),
	appointment_name		TEXT(30),
	appointment_date		DATE,
	appointment_time	    TIME,
	vaccine_type	        ENUM('covaxx','aspera','blast3000','divoc'),
	emp_no                  SMALLINT,
	city		    	VARCHAR(20),
PRIMARY KEY(daily_appointment_ID),
FOREIGN KEY (CPR) REFERENCES Customer(CPR),
FOREIGN KEY (vaccine_type) REFERENCES Vaccinetype(vaccine_type),
FOREIGN KEY (emp_no) REFERENCES Employee(emp_no),
FOREIGN KEY (city) REFERENCES Occurs(city)
);

INSERT Employee VALUES
(NULL, 2447965342, 'marcus thomsen', 'Manager', 100, 210, 'marcus323@gmail.com' , 34256236, 'København', 'tøjmestervej', 16, NULL, '1999-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26');
#(NULL, 5647376536, 210, 'Doctor', 'tim352@gmail.com' , 27542754, 'Frørupvej 99, 1149 KøbenhavnK'),
#(NULL, 3637245453, 210, 'Doctor', 'bob123@gmail.com' , 56742234, 'Åledalen 35, 1902 Frederiksberg C'),
#(NULL, 5634876385, 200, 'Doctor', 'tim392@gmail.com' , 78987597, 'Christianslundsvej 50, 4532 Gislinge'),
#(NULL, 4457374565, 190, 'Doctor', 'thomas.thimsen@gmail.com' , 87957857, 'Blæsenborgvej 5, 1064 Svenderup '),
#(NULL, 5747356365, 200, 'Doctor', 'ole.wedel@gmail.com' , 69554766, 'Sibiriensvej 28, 4243 Rude'),
#(NULL, 6574856856, 210, 'Doctor', 'nick420@gmail.com' , 34527676, 'Ladbyvej 89, 6855 Outrup');
SELECT * FROM Employee;
