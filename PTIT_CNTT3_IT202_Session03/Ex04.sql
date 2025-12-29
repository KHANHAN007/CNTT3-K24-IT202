USE Ex01;

CREATE TABLE Enrollment(
	student_id VARCHAR(20),
    subject_id VARCHAR(20),
    PRIMARY KEY (student_id, subject_id),
    
    CONSTRAINT fk_enrollment_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    
    CONSTRAINT fk_enrollment_subject
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    
    enroll_date DATE NOT NULL DEFAULT(CURRENT_DATE)
);

INSERT INTO Enrollment (student_id, subject_id)
	VALUES 	('1', '1'),
			('1', '2'),
			('2', '3');
            
SELECT * FROM Enrollment;

SELECT * FROM Enrollment 
	WHERE student_id = '1';