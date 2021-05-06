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
    price			INT,
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
FOREIGN KEY (city) REFERENCES Occurs(city),
unique index(CPR, appointment_date)
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


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX DATABASE INSTANS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT Employee VALUES
	(NULL, 2447965342, 'Marcus Thomsen', 'Manager', 100, 210, 'marcus323@gmail.com' , 34256236, 'København', 'tøjmestervej', 16, NULL, '1999-04-26'),
	(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1993-04-26'),
	(NULL, 2303990756, 'Mille Fabiano', 'Nurse',90, 160, 'millepigen@gmail.com' , 56768789, 'København', 'Aarhusgade', 12, NULL, '1995-06-26'),
	(NULL, 0305985612, 'Maj Mikkelsen', 'Nurse',90, 160, 'mikkelsen01@gmail.com' , 34540923, 'Odense', 'Odensevej', 128, NULL, '1998-03-12'),
	(NULL, 0312973445, 'Signe Koch', 'Nurse',90, 160, 'signekoch@gmail.com' , 12233445, 'Aarhus', 'Aarhusvej', 2, NULL, '1997-04-26'),
	(NULL, 1204985645, 'Linn Mogensen', 'Doctor',90, 250, 'linnmogensen@gmail.com' , 98563412, 'Holte', 'Vængestien', 2, NULL, '1998-12-26'),
	(NULL, 1212954565, 'Laura Claudius', 'Nurse',90, 160, 'claudius95@gmail.com' , 54782398, 'Virum', 'Virumvej', 15, NULL, '2000-04-03'),
	(NULL, 1207980534, 'Mikkel Rahbek', 'Doctor',90, 250, 'mikkelrahbek@gmail.com' , 16276512, 'Nakskov', 'Overhærupvej', 128, NULL, '1990-08-05');

INSERT Vaccinetype VALUES 
	('covaxx', 700), 
    ('divoc', 500),
    ('blast3000', 400),
    ('aspera', 700);

INSERT INTO Certificate (certificate_no, vaccine_type, emp_no, certified_date) VALUES 
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now()),
    (NULL, 'divoc', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Thomas Marcussen'), now()),
    (NULL, 'aspera', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Thomas Marcussen'), now()),
    (NULL, 'aspera', (SELECT emp_no FROM Employee WHERE emp_name='Mille Fabiano'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Signe Koch'), now()),
    (NULL, 'blast3000', (SELECT emp_no FROM Employee WHERE emp_name='Linn Mogensen'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Laura Claudius'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Mikkel Rahbek'), now()),
    (NULL, 'blast3000', (SELECT emp_no FROM Employee WHERE emp_name='Thomas Marcussen'), now());

INSERT Department VALUES
	(NULL, 'Københavnslægehus', 'kbh', 'manøgade', 12, NULL),
	(NULL, 'Hillerødlægehus', 'hill', 'Hillerødvej', 2, NULL),
	(NULL, 'Aarhuslægerne', 'aarhus', 'Aarhus alle', 10, NULL),
	(NULL, 'Koldinglægerne', 'kolding', 'Koldingvej', 2, NULL),
	(NULL, 'Odenselægehus', 'odense', 'Odensevej', 25, NULL),
	(NULL, 'Nakskovlægerne', 'nakskov', 'Nakskov alle', 6, NULL);

INSERT Occurs VALUES
	('kbh', (SELECT dept_no FROM Department WHERE city='kbh')),
	('hill', (SELECT dept_no FROM Department WHERE city='hill')),
	('aarhus', (SELECT dept_no FROM Department WHERE city='aarhus')),
	('kolding', (SELECT dept_no FROM Department WHERE city='kolding')),
	('odense', (SELECT dept_no FROM Department WHERE city='odense')),
	('nakskov', (SELECT dept_no FROM Department WHERE city='nakskov'));

INSERT Stock VALUES
    (1, 'covaxx', 200),
	(1, 'divoc', 300),
	(1, 'aspera', 200),
    (1, 'blast3000', 400),
    (2, 'covaxx', 400),
    (2, 'aspera', 100),
    (2, 'divoc', 200),
    (2, 'blast3000', 300),
    (3, 'covaxx', 200),
    (3, 'aspera', 250),
    (3, 'divoc', 200),
    (3, 'blast3000', 200),
    (4, 'covaxx', 350),
    (4, 'aspera', 200),
    (4, 'divoc', 400),
    (4, 'blast3000', 200),
    (5, 'covaxx', 300),
    (5, 'aspera', 500),
    (5, 'divoc', 200),
    (5, 'blast3000', 200),
    (6, 'covaxx', 200),
    (6, 'aspera', 50),
    (6, 'divoc', 10),
    (6, 'blast3000', 100);

INSERT emp_dept VALUES
	(1, 1),
	(6, 2),
	(1, 3),
	(5, 4),
	(3, 5),
	(1, 6),
	(2, 6),
	(1, 7),
	(2, 7),
	(6, 8);



#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX DATABASE QUERY XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#Alle opgaverne er nummereret efter rapporten, så de enkelte metoder kan findes nemmere.

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SQL Tabelmodifikationer XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXX 6.1 - Tilføj en ny medarbejder (Employee) XXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT Employee VALUES (NULL, 1207980534, 'jens Erik', 'Doctor',90, 150, 'jenserik1999@gmail.com' , 45569812, 'København Ø', 'Holsteinsgade', 19, NULL, '1990-08-05');


#XXXXXXXXXXXXXXXXXXXXXXXXXX 6.2 - Tilføj nyvaccineret person (Vaccination) XXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT Vaccination VALUES(NULL, now(),NULL,NULL,NULL,NULL);
#Der er modsat rapporten her indsat NULL-værdier, da de alle er foreign keys.


#XXXXXXXXXXXXXXXXXXXXXXXXXX 6.3 - Giv en specifik ansat et certifikat XXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT INTO Certificate (certificate_no, vaccine_type,emp_no, certified_date) 
VALUES (NULL,'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now());


#XXXXXXXXXXXXXXXXXXXXXXXXXX 6.4 - Ændre telefonnummeret ved en ansat XXXXXXXXXXXXXXXXXXXXXXXXXXX
UPDATE Employee SET phone='45768723' WHERE emp_no='2';


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6.5 - Tilføj ekstra vacciner til et lager ved en bestemt department XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
UPDATE Stock SET amount=amount+1000 WHERE vaccine_type='covaxx' AND dept_no = 1;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6.6 - Ved alle ansatte over 30 år, tilføj 50 kr. i løn. 5\% ved alle andre XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#Dette er rykket ned efter 8.1.1 da funktionen den tager brug af ikke er oprettet her endnu.

#XXXXXXXXXXXXXXXXXXXXXXXXXX 6.7 - Slette en appointment XXXXXXXXXXXXXXXXXXXXXXXXXXX
DELETE FROM Appointment WHERE daily_appointment_ID = 1;


#XXXXXXXXXXXXXXXXXXXXXXXXXX 6.8 - Giv medarbejdere mere i løn, hvis de har arbejdet overtid XXXXXXXXXXXXXXXXXXXXXXXXXXX
UPDATE Employee SET hours = hours+((hours-148)*0.5) WHERE hours>148;




#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SQL Forespørgsler XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXX 7.1 - Vis mængden af certificerede medarbejdere på alle lokation XXXXXXXXXXXXXXXXXXXXXXXXXXX
CREATE OR REPLACE VIEW available_certificates AS
SELECT dept_no, emp_no, vaccine_type, certificate_no
FROM emp_dept 
NATURAL JOIN Certificate 
GROUP BY certificate_no, dept_no
ORDER BY dept_no;

SELECT * FROM available_certificates;


#XXXXXXXXXXXXXXXXXXXXXXXXXX 7.2 - Hvor mange doser af hver vaccine der er nødvendig hver dag XXXXXXXXXXXXXXXXXXXXXXXXXXX
CREATE OR REPLACE VIEW needed_vaccine_doses AS
SELECT city, vaccine_type, COUNT(vaccine_type) AS 'needed doses'
FROM Appointment
WHERE appointment_date=CURDATE()
GROUP BY vaccine_type, city;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.3 - Opret forskellige roller XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP ROLE IF EXISTS Manager;
DROP ROLE IF EXISTS Nurse;
DROP ROLE IF EXISTS Doctor;

CREATE ROLE Manager;
CREATE ROLE Nurse;
CREATE ROLE Doctor;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.4 - Giv en rolle privilegier XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
GRANT SELECT ON Vaccination TO Doctor;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.5 - Opret en bruger og giv brugeren privilegier XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP USER IF EXISTS 'Anton'@'localhost';
CREATE USER 'Anton'@'localhost' IDENTIFIED BY '0808';
GRANT SELECT ON Employee TO 'Anton'@'localhost';


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.6 - Find for hver type vaccine antallet af medarbejdere der har certificat til denne XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(SELECT 
    Vaccine_type, COUNT(emp_no) AS NumberOfEmployees FROM Certificate 
    WHERE Vaccine_type = 'covaxx') 
UNION 
    (SELECT Vaccine_type, COUNT(emp_no) FROM Certificate 
    WHERE Vaccine_type = 'aspera') 
UNION 
	(SELECT Vaccine_type, COUNT(emp_no) FROM Certificate
	WHERE Vaccine_type = 'blast3000') 
UNION 
	(SELECT Vaccine_type, COUNT(emp_no) FROM Certificate
	WHERE Vaccine_type = 'divoc') 
ORDER BY NumberOfEmployees * - 1;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.7 - Find medarbejdere der arbejder mellem 30 og 40 timer om ugen og har et navn der starter med T XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SELECT emp_no, emp_name, hours FROM Employee WHERE hours/4 BETWEEN 20 AND 30 AND emp_name LIKE 'T%';


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.8 - Find hvor mange kunder, der dagligt er på enhver lokation XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SELECT city, COUNT(*) AS Amount FROM Vaccination WHERE DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination), "%Y%c%e") = DATE_FORMAT(NOW(), "%Y%c%e");


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.9 -  Tjek om et lager har under 20 vacciner, og vis navnet på stedet XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SELECT dept_no, dept_name, vaccine_type, amount FROM Stock NATURAL JOIN Department Where amount < 20 OR amount IS NULL;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.10 - Lav en daglig rapport ved VIEW XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP VIEW IF EXISTS DailyReport;
CREATE VIEW DailyReport (City, Vaccination_date, Vaccine_type, Employee, Customer_CPR, Customer_name, Appointment_date, Appointment_time) AS
SELECT city, DATE_FORMAT(vaccinated_dateTime, "%d" "/" "%m" "/" "%Y"), vaccine_type, emp_no, CPR, customer_name, appointment_date, appointment_time
	FROM Vaccination NATURAL RIGHT OUTER JOIN Customer NATURAL RIGHT OUTER JOIN Appointment WHERE date_format(vaccinated_dateTime, "%d %m %Y") = date_format(20210429, "%d %m %Y");
SELECT * FROM DailyReport;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 7.11 - Månedlige rapport XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
(SELECT COUNT(vaccination_ID) as Amount, vaccine_Type, COUNT(vaccination_ID)*price as total_Price  
	FROM Vaccination NATURAL RIGHT OUTER JOIN VaccineType WHERE vaccine_Type = "covaxx" 
	AND DATE_FORMAT(vaccinated_dateTime, "%M - %Y") LIKE "April - 2021")
UNION
(SELECT COUNT(vaccination_ID) as Amount, vaccine_Type, COUNT(vaccination_ID)*price as total_Price 
	FROM Vaccination NATURAL RIGHT OUTER JOIN VaccineType WHERE vaccine_Type = "aspera" 
	AND DATE_FORMAT(vaccinated_dateTime, "%M - %Y") LIKE "April - 2021")
UNION
(SELECT COUNT(vaccination_ID) as Amount, vaccine_Type, COUNT(vaccination_ID)*price as total_Price 
	FROM Vaccination NATURAL RIGHT OUTER JOIN VaccineType WHERE vaccine_Type = "blast3000" 
	AND DATE_FORMAT(vaccinated_dateTime, "%M - %Y") LIKE "April - 2021")
UNION
(SELECT COUNT(vaccination_ID) as Amount, vaccine_Type, COUNT(vaccination_ID)*price as total_Price 
	FROM Vaccination NATURAL RIGHT OUTER JOIN VaccineType WHERE vaccine_Type = "divoc" 
	AND DATE_FORMAT(vaccinated_dateTime, "%M - %Y") LIKE "April - 2021")
ORDER BY Amount * -1;




#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SQL PROGRAMMERING XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX FUNKTIONER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.1.1 - Age Difference XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP FUNCTION IF EXISTS ageDifference;
DELIMITER //
CREATE FUNCTION ageDifference(dateInput DATE)
	RETURNS INT
BEGIN
DECLARE age INT;
    SET age = DATE_FORMAT(NOW(), "%Y") - DATE_FORMAT(dateInput, "%Y") - 
		(CASE WHEN DATE_FORMAT(dateInput, "%c") > DATE_FORMAT(NOW(), "%c") OR
		(DATE_FORMAT(dateInput, "%c") = DATE_FORMAT(NOW(), "%c") AND DATE_FORMAT(dateInput, "%e") > DATE_FORMAT(NOW(), "%e"))
		THEN 1
		ELSE 0
	END);
	RETURN age;
END//
DELIMITER ;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 6.6 - Ved alle ansatte over 30 år, tilføj 50 kr. i løn. 5\% ved alle andre XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
UPDATE Employee SET salary=salary+50 WHERE ageDifference(date_of_birth)>=30;
UPDATE Employee SET Salary=salary*1.05 WHERE ageDifference(date_of_birth)<30;
select emp_name, salary FROM Employee;
#ageDifference funktionen skal være oprettet før den kan kaldes til, hvilket er derfor at 6.6 står her.

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.1.2 - Find den totale mængde appointments på en dag på en bestemt lokation XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP FUNCTION IF EXISTS totalAppointments;
DELIMITER //
CREATE FUNCTION totalAppointments(appointmentDate DATE, location VARCHAR(20)) RETURNS SMALLINT
BEGIN
	DECLARE vtotalApp SMALLINT;
    SELECT COUNT(*) INTO vtotalApp FROM Appointment
    WHERE city = location 
    AND appointment_date = appointmentDate;
    RETURN vtotalApp;
END//
DELIMITER ;
SELECT totalAppointments('2021-04-05', 'kbh');


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX PROCEDURER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.2.1 - Daglige rapport ved PROCEDURE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP PROCEDURE IF EXISTS GetDailyReport;
DELIMITER //
CREATE PROCEDURE GetDailyReport(IN dateInput DATE)
    BEGIN
		SELECT vaccinated_dateTime as Time_of_vaccination, city as city_of_vaccination, vaccine_type, emp_no as Employee_Number, CPR as Customer_CPR, customer_name, appointment_date, appointment_time
		FROM Vaccination NATURAL RIGHT OUTER JOIN Customer NATURAL RIGHT OUTER JOIN Appointment 
		WHERE DATE_FORMAT(dateInput, "%d%m%Y") = DATE_FORMAT(vaccinated_dateTime, "%d%m%Y");
END //
DELIMITER ;
CALL GetDailyReport("2021-04-29");


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.2.2 - Månedlige rapport ved loop XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP PROCEDURE IF EXISTS GetMonthlyReport;
DELIMITER //
CREATE PROCEDURE GetMonthlyReport(IN monthInput varchar(9), IN yearInput int(4))
	BEGIN
    DECLARE i INT DEFAULT 0;
	DECLARE vacType VARCHAR(10);

		allVaccineTypes: LOOP
			CASE i
            WHEN 0 THEN SET vacType = "covaxx";
            WHEN 1 THEN SET vacType = "aspera";
            WHEN 2 THEN SET vacType = "blast3000";
            WHEN 3 THEN SET vacType = "divoc";
            ELSE SET vacType=NULL;
            END CASE;
            
            SELECT COUNT(vaccination_ID) as Amount, vaccine_Type, COUNT(vaccination_ID)*price as Total_Price 
			FROM Vaccination NATURAL RIGHT OUTER JOIN VaccineType WHERE vaccine_Type = vacType AND
            DATE_FORMAT(vaccinated_dateTime, "%Y") LIKE yearInput AND 
            DATE_FORMAT(vaccinated_dateTime, "%M") LIKE monthInput;
			SET i = i + 1;
            
            IF i<(SELECT COUNT(vaccine_Type) FROM VaccineType) THEN ITERATE allVaccineTypes;
            ELSE LEAVE allVaccineTypes;
            END IF;
            
        END LOOP allVaccineTypes;
	END //
DELIMITER ;
CALL GetMonthlyReport("April", 2021);


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX TRANSAKTIONER XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.3.1 - Opret employee og giv ham alle certifikater XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
START TRANSACTION;
INSERT INTO Employee VALUES
(NULL, '3104984556', 'Michael Hansen', 'Doctor', 0, 210, 'michaeljensen@gmail.com', 45420201, 'København', 'holsteinsgade', 12, NULL, '1978-06-02');

INSERT INTO Certificate (certificate_no, vaccine_type, emp_no, certified_date) VALUES 
    (NULL, 'blast3000', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now()),
	(NULL, 'aspera', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now()),
    (NULL, 'divoc', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now());
COMMIT;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX TRIGGERS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#XXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.4.1 - Fjern en vaccine fra lageret, når en kunde modtager en XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DELIMITER //
CREATE TRIGGER Correct_Stock_After_Vaccine
AFTER INSERT ON Vaccination FOR EACH ROW
BEGIN
	UPDATE Stock
    SET amount=amount-1
    WHERE
    (SELECT dept_no FROM Occurs
	WHERE city = NEW.city)
    = dept_no
    AND
    vaccine_type = NEW.vaccine_type;
END//
DELIMITER ;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.4.2 -  Ved  oprettelse  af  en  appointment,  skal  der  oprettes  en  Customer,  så-fremt det er en ny kunde. XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#Registrer appointment og opret customer hvis ikke allerede oprettet. 
DELIMITER //
CREATE TRIGGER Register_Customer
BEFORE INSERT ON Appointment FOR EACH ROW
BEGIN
	INSERT INTO Customer
    SELECT NEW.CPR, NEW.appointment_name
	WHERE NOT EXISTS(
		SELECT CPR
        FROM 
			Customer
		WHERE
			Customer.CPR = NEW.CPR
	);
END//
DELIMITER ;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 8.4.3 - Vaccinecheck XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DELIMITER //
CREATE TRIGGER change_employee
BEFORE INSERT ON Vaccination FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Certificate WHERE vaccine_type=NEW.vaccine_type AND emp_no=NEW.emp_no)=0
    THEN SET NEW.emp_no = 
    (SELECT emp_no
    FROM Certificate
    NATURAL JOIN emp_dept
	NATURAL JOIN Occurs
    WHERE vaccine_type = NEW.vaccine_type
    AND city = NEW.city
    GROUP BY emp_no
    ORDER BY RAND()
    LIMIT 1
    );
    END IF;
END//
DELIMITER ;
