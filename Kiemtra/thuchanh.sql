DROP DATABASE Thuchanh;
CREATE DATABASE Thuchanh;

USE Thuchanh;

CREATE TABLE Student(
	student_id VARCHAR(20) PRIMARY KEY,
    student_fullname VARCHAR(255) NOT NULL,
    student_email VARCHAR(255) NOT NULL UNIQUE,
    student_phone_number CHAR(11)
);

CREATE TABLE Course(
	course_id VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    credit INT NOT NULL CHECK (credit > 0)
);

CREATE TABLE Enrollment(
	student_id VARCHAR(20),
    course_id VARCHAR(20),
    gradle DECIMAL (4,2) DEFAULT(0) CHECK (gradle BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id),
    
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);


INSERT INTO Student
	VALUES 	('SV01', 'Nguyễn Văn A', 'a@gmail.com', '09876543211'),
			('SV02', 'Trần Văn B', 'b@gmail.com', '01234567890'),
            ('SV03', 'Nguyễn Thị C', 'c@gmail.com', '02124483798'),
            ('SV04', 'Ngô Văn D', 'd@gmail.com', '03248947123'),
            ('SV05', 'Dinh Thị E', 'e@gmail.com', '03248269783');

INSERT INTO Course
	VALUES 	('MH01', 'CSDL', 3),
			('MH02', 'Nhập môn C', 4),
            ('MH03', 'Agile/Scrum', 2),
            ('MH04', 'Xây dựng và thiết kế phần mềm', 3),
            ('MH05', 'React-FRONTEND', 5),
            ('MH101', 'a', 2);

INSERT INTO Enrollment
	VALUES 	('SV01', 'MH01', 9.2),
			('SV02', 'MH01', 8.5),
            ('SV01', 'MH02', 9.5),
            ('SV03', 'MH04', 10),
            ('SV03', 'MH01', 9.8),
            ('SV01', 'MH101', 2);
            
UPDATE Enrollment
	SET gradle = 9
    WHERE	student_id = 'SV02' and
			course_id = 'MH03';

SELECT student_fullname, student_email, student_phone_number FROM Student;

DELETE FROM Course
	WHERE course_id = 'MH101';
-- Câu lệnh DELETE không thực thi được do khóa học MH101 đang được tham chiếu trong bảng Enrollment thông qua ràng buộc khóa ngoại. MySQL không cho phép xóa dữ liệu ở bảng cha khi vẫn còn dữ liệu liên quan ở bảng con nhằm đảm bảo toàn vẹn dữ liệu.