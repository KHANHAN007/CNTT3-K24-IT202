USE Ex01;

UPDATE Student
	SET student_email = 'thaythe@gmail.com'
    WHERE student_id = '3' ;
    
UPDATE Student
	SET student_day_of_birth = '2006-04-21'
    WHERE student_id = '2';
    
DELETE FROM Student 
	WHERE student_id = '5';
    
SELECT * FROM Student;