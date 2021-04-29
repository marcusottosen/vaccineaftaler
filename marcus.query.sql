
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

UPDATE Employee SET salary=salary+50 WHERE ageDifference(date_of_birth)>=30;
UPDATE Employee SET Salary=salary*1.05 WHERE ageDifference(date_of_birth)<30;
select salary FROM Employee;