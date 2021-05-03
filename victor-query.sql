
INSERT Employee VALUES
(NULL, 2447965342, 'Marcus Thomsen', 'Manager', 100, 210, 'marcus323@gmail.com' , 34256236, 'København', 'tøjmestervej', 16, NULL, '1999-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26'),
(NULL, 2303990756, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26');
SELECT * FROM Employee;


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
    (NULL, 'blast3000', (SELECT emp_no FROM Employee WHERE emp_name='Thomas Marcussen'), now());
SELECT * FROM Certificate;




INSERT Department VALUES
(NULL, 'Københavnslægehus', 'kbh', 'manøgade', 12, NULL),
(NULL, 'Hillerødlægehus', 'hill', 'Hillerødvej', 2, NULL),
(NULL, 'Aarhuslægerne', 'aarhus', 'Aarhus alle', 10, NULL),
(NULL, 'Koldinglægerne', 'kolding', 'Koldingvej', 2, NULL),
(NULL, 'Odenselægehus', 'odense', 'Odensevej', 25, NULL),
(NULL, 'Nakskovlægerne', 'nakskov', 'Nakskov alle', 6, NULL);
SELECT * FROM Department;


INSERT Occurs VALUES
('kbh', (SELECT dept_no FROM Department WHERE city='kbh')),
('hill', (SELECT dept_no FROM Department WHERE city='hill')),
('aarhus', (SELECT dept_no FROM Department WHERE city='aarhus')),
('kolding', (SELECT dept_no FROM Department WHERE city='kolding')),
('odense', (SELECT dept_no FROM Department WHERE city='odense')),
('nakskov', (SELECT dept_no FROM Department WHERE city='nakskov'));
SELECT * FROM Occurs;




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

##Insert appointments XXXXXXXXX DETTE BØR FJERNES, NÅR VI KAN LÆSE CSV FILEN MED APPOINTMENTS
INSERT Appointment VALUES 
	(NULL, '3101990981', 'Victor Kongsbak', '2021-04-05', '11:30', 'covaxx', 'kbh'),
	(NULL, '1212562345', 'Jakob Svensson', '2021-04-05', '09:30', 'covaxx', 'kbh'),
	(NULL, '0405993487', 'Torben Jakobsen', '2021-04-05', '11:00', 'covaxx', 'kbh'),
	(NULL, '3101990981', 'Victor Kongsbak', '2021-06-05', '12:00', 'covaxx', 'kbh'),
	(NULL, '2403778789', 'Anton Bloch', '2021-04-05', '11:00', 'covaxx', 'kbh'),
    (NULL, '2312965612', 'Anders Andersen', '2021-07-05', '11:30', 'divoc', 'kbh'),
	(NULL, '0411980677', 'Vincent von Dreyer', '2021-06-05', '11:30', 'divoc', 'kbh'),
	(NULL, '1204994576', 'Thomas Bohl', '2021-06-05', '10:30', 'aspera', 'kbh'),
	(NULL, '0612882354', 'Patrick Meyer', '2021-06-05', '11:30', 'divoc', 'hill'),
	(NULL, '0412964565', 'Mathias Berger', '2021-04-30', '11:30', 'divoc', 'kbh'),
	(NULL, '1206984565', 'Troels Frederiksen', '2021-04-30', '11:30', 'covaxx', 'kbh'),
	(NULL, '1206984565', 'Laura Kruse', '2021-04-30', '11:30', 'covaxx', 'kbh'),
	(NULL, '1206984565', 'Markus Jakobsen', '2021-04-30', '11:30', 'covaxx', 'kbh'),
	(NULL, '2003980454', 'Mathias Orsted', '2021-04-05', '11:30', 'divoc', 'hill'),
    (NULL, '0412873454', 'Thomas Modvig', '2021-04-30', '11:30', 'divoc', 'hill'),
    (NULL, '0304084565', 'Vilhelm Alfred', '2021-04-30', '11:30', 'blast3000', 'kbh');
SELECT * FROM Appointment;
SELECT * FROM Customer;




#XXXXXXXXXXXXXXXXXXXXXXXXXXXX Fjerne vaccine fra lageret ved brug til kunde(Vaccination). XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT Stock VALUES #DETTE BØR SLETTES NÅR DATABASE INSTANS LAVES
(1, 'covaxx', 200),
(1, 'divoc', 200),
(2, 'covaxx', 200);

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

INSERT Vaccination VALUES
(NULL, '2021-04-29 12:30', '3101990981', 'covaxx', 'kbh', '1');




#XXXXXXXXXXXXXX FORESPØRGSEL: Tæl mængden af certificerede medarbejdere på alle lokation. ORDER BY dept_no
INSERT emp_dept VALUES
(1, 1),
(2, 1),
(1, 2),
(2, 2);
SELECT * FROM emp_dept;

CREATE OR REPLACE VIEW available_certificates AS
SELECT dept_no, emp_no, vaccine_type, certificate_no
FROM emp_dept 
NATURAL JOIN Certificate 
GROUP BY certificate_no, dept_no
ORDER BY dept_no;

SELECT * FROM available_certificates;



#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Hvor mange doser af hver vaccine er nødvendig hver dag XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SELECT * FROM Appointment;
    
CREATE OR REPLACE VIEW needed_vaccine_doses AS
SELECT city, vaccine_type, COUNT(vaccine_type) AS 'needed doses'
FROM Appointment
WHERE appointment_date=CURDATE()
GROUP BY vaccine_type, city;

SELECT * FROM needed_vaccine_doses;

	
    

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Tilføj nyvaccineret person XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT Vaccination VALUES
(NULL, now(), '3101990981', 'covaxx', 'kbh', '1');



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
 SELECT * FROM Appointment;
 
 
 
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Find den totale mængde appointments på en dag på en bestemt lokation XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


















