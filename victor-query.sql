
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


INSERT Vaccinetype VALUES 
	('covaxx'), 
    ('divoc'),
    ('blast3000'),
    ('aspera');


INSERT INTO Certificate VALUES (NULL, 'covaxx', now(), 1);
SELECT * FROM Certificate;


INSERT Customer VALUES
('3101990981', 'Victor Emil Skafte Kongsbak', 'Holte', 'Vængestien', 2, NULL);
SELECT * FROM Customer;


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


INSERT Appointment VALUES
(NULL, '3101990981', 'Victor Emil Skafte Kongsbak', '2021-04-05', '11:30:00', 'covaxx', '1', 'København');
SELECT * FROM Appointment;