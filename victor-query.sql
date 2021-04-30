
INSERT Employee VALUES
(NULL, 2447965342, 'Marcus Thomsen', 'Manager', 100, 210, 'marcus323@gmail.com' , 34256236, 'København', 'tøjmestervej', 16, NULL, '1999-04-26'),
(NULL, 4363456346, 'Thomas Marcussen', 'Nurse',90, 160, 'thomas3523@gmail.com' , 54457565, 'Nørreballe', 'Overhærupvej', 128, NULL, '1901-04-26');
#(NULL, 5647376536, 210, 'Doctor', 'tim352@gmail.com' , 27542754, 'Frørupvej 99, 1149 KøbenhavnK'),
#(NULL, 3637245453, 210, 'Doctor', 'bob123@gmail.com' , 56742234, 'Åledalen 35, 1902 Frederiksberg C'),
#(NULL, 5634876385, 200, 'Doctor', 'tim392@gmail.com' , 78987597, 'Christianslundsvej 50, 4532 Gislinge'),
#(NULL, 4457374565, 190, 'Doctor', 'thomas.thimsen@gmail.com' , 87957857, 'Blæsenborgvej 5, 1064 Svenderup '),
#(NULL, 5747356365, 200, 'Doctor', 'ole.wedel@gmail.com' , 69554766, 'Sibiriensvej 28, 4243 Rude'),
#(NULL, 6574856856, 210, 'Doctor', 'nick420@gmail.com' , 34527676, 'Ladbyvej 89, 6855 Outrup');
SELECT * FROM Employee;


INSERT Vaccinetype VALUES 
	('covaxx'), 
    ('divoc'),
    ('blast3000'),
    ('aspera');


INSERT INTO Certificate (certificate_no, vaccine_type, emp_no, certified_date) 
	VALUES (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now());
SELECT * FROM Certificate;




INSERT Department VALUES
(NULL, 'Københavnslægehus', 'København', 'manøgade', 12, NULL),
(NULL, 'Hillerødlægehus', 'Hillerød', 'Hillerødvej', 2, NULL),
(NULL, 'Aarhuslægerne', 'Aarhus', 'Aarhus alle', 10, NULL),
(NULL, 'Koldinglægerne', 'Kolding', 'Koldingvej', 2, NULL),
(NULL, 'Odenselægehus', 'Odense', 'Odensevej', 25, NULL),
(NULL, 'Nakskovlægerne', 'Nakskov', 'Nakskov alle', 6, NULL);
SELECT * FROM Department;


INSERT Occurs VALUES
('København', (SELECT dept_no FROM Department WHERE city='København')),
('Hillerød', (SELECT dept_no FROM Department WHERE city='Hillerød')),
('Aarhus', (SELECT dept_no FROM Department WHERE city='Aarhus')),
('Kolding', (SELECT dept_no FROM Department WHERE city='Kolding')),
('Odense', (SELECT dept_no FROM Department WHERE city='Odense')),
('Nakskov', (SELECT dept_no FROM Department WHERE city='Nakskov'));
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
	(NULL, '3101990981', 'Victor Kongsbak', '2021-04-05', '11:30', 'covaxx', 'København'),
	(NULL, '1212562345', 'Jakob Svensson', '2021-04-05', '09:30', 'covaxx', 'København'),
	(NULL, '0405993487', 'Torben Jakobsen', '2021-04-05', '11:00', 'covaxx', 'København'),
	(NULL, '3101990981', 'Victor Kongsbak', '2021-06-05', '12:00', 'covaxx', 'København'),
	(NULL, '2403778789', 'Anton Bloch', '2021-04-05', '11:00', 'covaxx', 'København'),
    (NULL, '2312965612', 'Anders Andersen', '2021-07-05', '11:30', 'divoc', 'København'),
	(NULL, '0411980677', 'Vincent von Dreyer', '2021-06-05', '11:30', 'divoc', 'København'),
	(NULL, '1204994576', 'Thomas Bohl', '2021-06-05', '10:30', 'aspera', 'København'),
	(NULL, '0612882354', 'Patrick Meyer', '2021-06-05', '11:30', 'divoc', 'Hillerød'),
	(NULL, '0412964565', 'Mathias Berger', '2021-04-30', '11:30', 'divoc', 'København'),
	(NULL, '1206984565', 'Troels Frederiksen', '2021-04-30', '11:30', 'covaxx', 'København'),
	(NULL, '1206984565', 'Laura Kruse', '2021-04-30', '11:30', 'covaxx', 'København'),
	(NULL, '1206984565', 'Markus Jakobsen', '2021-04-30', '11:30', 'covaxx', 'København'),
	(NULL, '2003980454', 'Mathias Orsted', '2021-04-05', '11:30', 'divoc', 'Hillerød'),
    (NULL, '0412873454', 'Thomas Modvig', '2021-04-30', '11:30', 'divoc', 'Hillerød'),
    (NULL, '0304084565', 'Vilhelm Alfred', '2021-04-30', '11:30', 'blast3000', 'København');
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
(NULL, '2021-04-29 12:30', '3101990981', 'covaxx', 'København', '1');




#XXXXXXXXXXXXXX FORESPØRGSEL: Tæl mængden af certificerede medarbejdere på alle lokation. ORDER BY dept_no
INSERT INTO Certificate (certificate_no, vaccine_type, emp_no, certified_date) 
	VALUES 
    (NULL, 'divoc', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now()),
    (NULL, 'covaxx', (SELECT emp_no FROM Employee WHERE emp_name='Thomas Marcussen'), now()),
    (NULL, 'aspera', (SELECT emp_no FROM Employee WHERE emp_name='Marcus Thomsen'), now()),
    (NULL, 'blast3000', (SELECT emp_no FROM Employee WHERE emp_name='Thomas Marcussen'), now());
SELECT * FROM Certificate;

SELECT * FROM Employee;
SELECT * FROM Department;
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























