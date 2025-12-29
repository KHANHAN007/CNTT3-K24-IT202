DROP database if exists Ex01;
CREATE DATABASE Ex01;
USE Ex01;

CREATE TABLE Student(
	student_id VARCHAR(20) PRIMARY KEY,
    student_fullname VARCHAR(255) NOT NULL,
	student_day_of_birth DATE NOT NULL,
	student_email VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Student 
	VALUES 	('1', 'Nguyen Van A', '2006-01-01', 'vana@gmail.com'),
			('2', 'Tran Thi Binh', '2004-08-22', 'binh.tran@gmail.com'),
			('3', 'Le Minh Chau', '2005-01-15', 'chau.le@gmail.com'),
            ('5', 'bbb', '2007-02-15', 'bbb.@gmail.com');
            
SELECT * FROM Student;

SELECT student_id, student_fullname FROM Student;