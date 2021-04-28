
DROP FUNCTION IF EXISTS ageDifference;

DELIMITER //
CREATE FUNCTION ageDifference(dateInput DATE)
	RETURNS INT
BEGIN
DECLARE age INT;
    SET age = DATE_FORMAT(NOW(), "%y") - DATE_FORMAT(dateInput, "%y") - 
		(CASE WHEN DATE_FORMAT(dateInput, "%c") > DATE_FORMAT(NOW(), "%c") OR
		(DATE_FORMAT(dateInput, "%c") = DATE_FORMAT(NOW(), "%c") AND DATE_FORMAT(dateInput, "%e") > DATE_FORMAT(NOW(), "%e"))
		THEN 1
		ELSE 0
	END);
	RETURN age;
END//
DELIMITER ;

SELECT ageDifference('2000-06-15') AS Difference;
