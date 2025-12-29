USE Ex01;
UPDATE Student
	SET student_email = 'c@gmail.com'
    WHERE student_id = 'SV03';
    
UPDATE Student
	SET student_date_of_birth = '2006-12-12'
	WHERE student_id = 'SV02';
    
DELETE FROM Student
	WHERE student_id = 'SV05';
    
SELECT * FROM Student;