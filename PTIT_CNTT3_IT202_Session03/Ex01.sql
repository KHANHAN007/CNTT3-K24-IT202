DROP DATABASE Ex01;
CREATE DATABASE Ex01;
USE Ex01;

DROP TABLE Student;
CREATE TABLE Student(
	student_id VARCHAR(20) PRIMARY KEY,
    student_fullname VARCHAR(255) NOT NULL,
    student_email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO Student
	VALUES ('SV01', 'Trương Hà Cẩm Linh', 'camlinhmattron@gmail.com'),
			('SV02', 'Đặng Khánh An', 'a@gmail.com'),
            ('SV03', 'b', 'b@gmail.com');
    
SELECT * FROM Student;

SELECT student_id, student_fullname FROM Student;
