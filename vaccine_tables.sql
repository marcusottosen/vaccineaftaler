DROP DATABASE vaccineberedskabet;
CREATE DATABASE vaccineberedskabet;
USE vaccineberedskabet;

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

CREATE TABLE shift_plan (
	time_slot_ID		SMALLINT auto_increment,
    day					DATE,
    start_time			TIME,
    end_time			TIME,
    emp_no				SMALLINT,
    PRIMARY KEY (time_slot_ID, day, start_time),
    FOREIGN KEY (emp_no)
		REFERENCES emp_dept(emp_no)
);

create table Vaccinetype(
	vaccine_type 	ENUM('covaxx','aspera','blast3000','divoc'),
PRIMARY KEY (vaccine_type)
);

CREATE TABLE Stock(
	dept_no 		SMALLINT,
	vaccine_type 	ENUM('covaxx','aspera','blast3000','divoc'),
	Amount 			INT,
PRIMARY KEY (dept_no, vaccine_type),
FOREIGN KEY (dept_no) 
	REFERENCES Department(dept_no),
FOREIGN KEY (vaccine_type) 
	REFERENCES Vaccinetype(vaccine_type)
);

CREATE TABLE Customer (
	CPR				BIGINT(11),
	customer_name	TEXT(30),
PRIMARY KEY (CPR)
);

create table Certificate(
certificate_no          SMALLINT auto_increment,
vaccine_type            ENUM('covaxx','aspera','blast3000','divoc'),
emp_no                  SMALLINT,
certified_date          DATE,
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
	city		    	VARCHAR(20),
PRIMARY KEY(daily_appointment_ID),
FOREIGN KEY (CPR) REFERENCES Customer(CPR),
FOREIGN KEY (vaccine_type) REFERENCES Vaccinetype(vaccine_type),
FOREIGN KEY (city) REFERENCES Occurs(city)
);

CREATE TABLE Vaccination (
vaccination_ID		SMALLINT auto_increment,
vaccinated_dateTime DATETIME,
CPR					BIGINT(11),
vaccine_type		ENUM('covaxx','aspera','blast3000','divoc'),
city				VARCHAR(20),
emp_no				SMALLINT,
PRIMARY KEY (vaccination_ID),
FOREIGN KEY (CPR)
	REFERENCES Customer(CPR),
FOREIGN KEY (vaccine_type)
	REFERENCES Vaccinetype(vaccine_type),
FOREIGN KEY (city)
	REFERENCES Occurs(city),
FOREIGN KEY (emp_no)
	REFERENCES Employee(emp_no)
);






