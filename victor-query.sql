

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
	('covaxx'), 
    ('divoc'),
    ('blast3000'),
    ('aspera');

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

#XXXXXXXXXXXXXXXXXXXXXXXXXX TRIGGER XXXXXXXXXXXXXXXXXXXXXXXXXXX
#Registrer appointment og opret customer hvis ikke eksisterer. 
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


#XXXXXXXXXXXXXXXXXXXXXXXXXXXX Fjerne vaccine fra lageret ved brug til kunde(Vaccination). XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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


#XXXXXXXXXXXXXX FORESPØRGSEL: Tæl mængden af certificerede medarbejdere på alle lokation. ORDER BY dept_no
CREATE OR REPLACE VIEW available_certificates AS
SELECT dept_no, emp_no, vaccine_type, certificate_no
FROM emp_dept 
NATURAL JOIN Certificate 
GROUP BY certificate_no, dept_no
ORDER BY dept_no;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Hvor mange doser af hver vaccine er nødvendig hver dag XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
CREATE OR REPLACE VIEW needed_vaccine_doses AS
SELECT city, vaccine_type, COUNT(vaccine_type) AS 'needed doses'
FROM Appointment
WHERE appointment_date=CURDATE()
GROUP BY vaccine_type, city;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX CREATE ROLE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP ROLE Doctor;
CREATE ROLE Doctor;
GRANT SELECT ON Vaccination TO Doctor;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX CREATE USER AND PRIVILIGES XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP USER 'Anton'@'localhost';
CREATE USER 'Anton'@'localhost' IDENTIFIED BY '0808';
GRANT SELECT ON Employee TO 'Anton'@'localhost';


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX OPRET EMPLOYEE OG GIV HAM CERTIFIKATER MED DET SAMME XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
START TRANSACTION;
INSERT INTO Employee VALUES
(NULL, '3104984556', 'Michael Hansen', 'Doctor', 0, 210, 'michaeljensen@gmail.com', 45420201, 'København', 'holsteinsgade', 12, NULL, '1978-06-02');

INSERT INTO Certificate (certificate_no, vaccine_type, emp_no, certified_date) VALUES 
    (NULL, 'blast3000', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now()),
	(NULL, 'aspera', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now()),
    (NULL, 'divoc', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Michael Hansen'), now());
COMMIT;

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Find den totale mængde appointments på en dag på en bestemt lokation XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX SQL PROGRAMMERING: Hvis employee ikke har certifikat XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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








