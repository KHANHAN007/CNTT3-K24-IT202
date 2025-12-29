USE Ex01;

INSERT INTO Student (student_id, student_fullname, student_day_of_birth, student_email)
	VALUES ('SV10', 'Nguyen Van Nam', '2005-09-12', 'nam.nguyen@gmail.com');

INSERT INTO Enrollment (student_id, subject_id)
	VALUES 
		('SV10', '1'),
		('SV10', '2');
    
INSERT INTO Score (student_id, subject_id, mid_score, final_score)
	VALUES
		('SV10', '1', 7.0, 8.0),
		('SV10', '2', 6.5, 7.5);

UPDATE Score
	SET final_score = 8.5
	WHERE student_id = 'SV10'
	  AND subject_id = '2';
      
      
DELETE FROM Enrollment
	WHERE student_id = 'SV10'
	  AND subject_id = '1';


SELECT 
    s.student_id,
    s.student_fullname,
    sub.subject_name,
    sc.mid_score,
    sc.final_score
	FROM Student s
	JOIN Score sc
		ON s.student_id = sc.student_id
	JOIN Subject sub
		ON sc.subject_id = sub.subject_id;

