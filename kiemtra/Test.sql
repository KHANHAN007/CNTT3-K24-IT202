DROP DATABASE Test;
CREATE DATABASE Test;

USE Test;

CREATE TABLE Student(
		student_id VARCHAR(100) PRIMARY KEY,
        student_fullname VARCHAR(255) NOT NULL,
        student_email VARCHAR(255) UNIQUE NOT NULL,
        student_phone_number CHAR(11)
);
 CREATE TABLE Course(
		course_id  VARCHAR(100) PRIMARY KEY,
        course_fullname VARCHAR(255) NOT NULL,
        credits INT NOT NULL CHECK(credits > 0)
);
CREATE TABLE Enrollment (
    student_id VARCHAR(100),
	course_id VARCHAR(255),
    grade DECIMAL(4,2) DEFAULT 0,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
INSERT INTO Student VALUES 
	('SV01','Truong Ha Cam Linh', 'camlinhmattron@gmail.com', '0337323451'),
	('SV02','Tran Thi B', 'b@gmail.com', '0987654321'),
	('SV03','Le Van C', 'c@gmail.com', '0111111111'),
	('SV04','Pham Thi D', 'd@gmail.com', '0222222222'),
	('SV05','Hoang Van E', 'e@gmail.com', '0333333333');

INSERT INTO Course VALUES 
('MH01','Toan Cao Cap', 3),
('MH02','Lap Trinh Python', 4),
('MH03','Co So Du Lieu', 3),
('MH04','Marketing Online', 2),
('MH05','Anh Van Giao Tiep', 2),
('MH101','Anh Van Giao Tiep', 2);

INSERT INTO Enrollment (student_id, course_id, grade) VALUES 
('SV01', 'MH01', 8.5),
('SV02', 'MH02', 7.0),
('SV03', 'MH03', 9.0),
('SV04', 'MH04', 6.5),
('SV05', 'MH05', 8.0),
('SV01', 'MH101', 2);

UPDATE Enrollment SET grade = 9.0 WHERE student_id = 'SV02' AND course_id = 'MH03';

SELECT student_fullname, student_email, student_phone_number FROM Student;

DELETE FROM Course
	WHERE course_id = 'MH101'
-- Cau lenh DELETA khong thuc thi duoc do khoa hoc MH101 dang duoc tham chieu trong bang Enrollment thong qua rang buoc khoa ngoai. Du lieu ton tai o bang con nen khong xoa duoc.