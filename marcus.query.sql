
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Beregner alderforskel (9.1.1) XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Ved alle ansatte over 30 år, tilføj 50 kr. i løn. 5\% ved alle andre XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
UPDATE Employee SET salary=salary+50 WHERE ageDifference(date_of_birth)>=30;
UPDATE Employee SET Salary=salary*1.05 WHERE ageDifference(date_of_birth)<30;
select salary FROM Employee;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Tilføj ekstra vacciner til et lager ved en bestemt department XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
INSERT Stock values 
((SELECT dept_no FROM Department WHERE dept_no = 1),'covaxx',5000);
UPDATE Stock SET amount=amount+1000 WHERE vaccine_type='covaxx' AND dept_no = 1;


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Find medarbejdere der arbejder mellem 30 og 40 timer om ugen og har et navn der starter med T XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
SELECT emp_no, emp_name, hours FROM Employee WHERE hours/4 BETWEEN 20 AND 30 AND emp_name LIKE 'T%';


#XXXXskrammelXXXX
INSERT INTO Certificate VALUES 
(NULL, 'covaxx', 1, now()),
(NULL, 'covaxx', 2, now()),
(NULL, 'aspera', 1, now()),
(NULL, 'blast3000', 3, now()),
(NULL, 'divoc', 5, now()),
(NULL, 'divoc', 2, now());
SELECT count(certificate_no) AS NumberOfConaxxCertificates FROM Certificate WHERE Vaccine_type = 'covaxx';
SELECT count(certificate_no) AS NumberOfAsperaCertificates FROM Certificate WHERE Vaccine_type = 'aspera';
SELECT count(certificate_no) AS NumberOfBlast3000Certificates FROM Certificate WHERE Vaccine_type = 'blast3000';
SELECT count(certificate_no) AS NumberOfdivocCertificates FROM Certificate WHERE Vaccine_type = 'divoc';


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Find for hver type vaccine antallet af medarbejdere der har certificat til denne XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Daglige rapport ved PROCEDURE XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Daglige rapport ved VIEW XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
DROP VIEW IF EXISTS DailyReport;
CREATE VIEW DailyReport (City, Vaccination_date, Vaccine_type, Employee, Customer_CPR, Customer_name, Appointment_date, Appointment_time) AS
SELECT city, DATE_FORMAT(vaccinated_dateTime, "%d" "/" "%m" "/" "%Y"), vaccine_type, emp_no, CPR, customer_name, appointment_date, appointment_time
	FROM Vaccination NATURAL RIGHT OUTER JOIN Customer NATURAL RIGHT OUTER JOIN Appointment WHERE date_format(vaccinated_dateTime, "%d %m %Y") = date_format(20210429, "%d %m %Y");
SELECT * FROM DailyReport;

#XXXXskrammelXXXX
SELECT DATE_FORMAT("2021-04-29", "%d %m %Y");
SELECT DATE_FORMAT(vaccinated_dateTime, "%d %m %Y") FROM Vaccination WHERE vaccination_ID=1;
SELECT vaccinated_dateTime FROM Vaccination WHERE vaccination_ID=1;
INSERT INTO Vaccination VALUES
(3, NOW(), NULL, NULL, NULL, NULL),
(4, NOW(), NULL, NULL, NULL, NULL);
SELECT * FROM Vaccination;



#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Månedlige rapport XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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


#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Månedlige rapport ved loop XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
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
            
             #INSERT INTO monthly_report (amount, vac, price) 
				#VALUES ((SELECT COUNT(vaccination_ID) FROM Vaccination WHERE vaccine_Type = vacType), vacType , COUNT(vaccination_ID)*price);
            
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
            








           
#XXXXXresten er skrammelXXXXX
select DATE_FORMAT(vaccinated_dateTime, "%M") from Vaccination;

SELECT COUNT(vaccination_ID) as Amount, vaccine_Type, COUNT(vaccination_ID)*price as price  
	FROM Vaccination NATURAL RIGHT OUTER JOIN VaccineType WHERE vaccine_Type = "covaxx" 
	AND DATE_FORMAT(vaccinated_dateTime, "%M - %Y") LIKE "April - 2021";

SELECT DATE_FORMAT(vaccinated_dateTime, "%M") as amount, vaccine_Type FROM Vaccination;
SELECT * FROM Vaccination WHERE vaccine_Type = "covaxx";

SELECT 5+COUNT(vaccination_ID) FROM Vaccination;

INSERT INTO Vaccination VALUES
#(1, NOW(), NULL, NULL, NULL, NULL),
(2, NOW(), NULL, NULL, NULL, NULL);
SELECT * FROM Vaccination;


SELECT * FROM Vaccination WHERE DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination), '%e'=29);
SELECT DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination));

SELECT COUNT(*) FROM Vaccination 
	WHERE DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination), "%Y") = DATE_FORMAT(NOW(), "%Y")
	AND DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination), "%c") = DATE_FORMAT(NOW(), "%c")
	AND DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination), "%e") = DATE_FORMAT(NOW(), "%e");

#DATE_FORMAT((SELECT vaccinated_dateTime FROM Vaccination), "%e") = DATE_FORMAT(NOW(), "%e");







