DROP DATABASE thuchanh01;
CREATE DATABASE thuchanh01;

USE thuchanh01;

CREATE TABLE Student (
    student_id VARCHAR(20) PRIMARY KEY,
    student_fullname VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    student_email VARCHAR(255) UNIQUE
);

CREATE TABLE Teacher (
    teacher_id VARCHAR(20) PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL,
    teacher_email VARCHAR(255) UNIQUE
);

CREATE TABLE Course (
    course_id VARCHAR(20) PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    description TEXT,
    total_sessions INT NOT NULL CHECK (total_sessions > 0),
    teacher_id VARCHAR(20),

    CONSTRAINT fk_course_teacher
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    student_id VARCHAR(20),
    course_id VARCHAR(20),
    enroll_date DATE DEFAULT (CURRENT_DATE),

    PRIMARY KEY (student_id, course_id),

    CONSTRAINT fk_enroll_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id),

    CONSTRAINT fk_enroll_course
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Score (
    student_id VARCHAR(20),
    course_id VARCHAR(20),
    mid_score DECIMAL(4,2) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),

    PRIMARY KEY (student_id, course_id),

    CONSTRAINT fk_score_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id),

    CONSTRAINT fk_score_course
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);



-- Phần 2
INSERT INTO Student 
	VALUES
	('SV001', 'Nguyen Van A', '2005-01-12', 'a@gmail.com'),
	('SV002', 'Tran Thi B', '2004-09-22', 'b@gmail.com'),
	('SV003', 'Le Van C', '2005-05-10', 'c@gmail.com'),
	('SV004', 'Pham Thi D', '2006-03-18', 'd@gmail.com'),
	('SV005', 'Hoang Van E', '2004-12-01', 'e@gmail.com');

INSERT INTO Teacher 
	VALUES
	('GV001', 'Nguyen Van Nam', 'nam@gmail.com'),
	('GV002', 'Tran Thi Hoa', 'hoa@gmail.com'),
	('GV003', 'Le Minh Tuan', 'tuan@gmail.com'),
	('GV004', 'Pham Quang Huy', 'huy@gmail.com'),
	('GV005', 'Do Thi Lan', 'lan@gmail.com');

INSERT INTO Course 
	VALUES
	('C001', 'Database Basics', 'Introduction to Database', 20, 'GV001'),
	('C002', 'Web Development', 'HTML CSS JavaScript', 25, 'GV002'),
	('C003', 'Java Programming', 'Core Java course', 30, 'GV003'),
	('C004', 'Python Programming', 'Python from zero', 28, 'GV004'),
	('C005', 'Software Testing', 'Basic testing skills', 15, 'GV005');

    
INSERT INTO Enrollment 
	VALUES
	('SV001', 'C001', CURRENT_DATE),
	('SV001', 'C002', CURRENT_DATE),
	('SV002', 'C001', CURRENT_DATE),
	('SV003', 'C003', CURRENT_DATE),
	('SV004', 'C004', CURRENT_DATE),
	('SV005', 'C005', CURRENT_DATE);


INSERT INTO Score 
	VALUES
	('SV001', 'C001', 7.5, 8.0),
	('SV001', 'C002', 6.5, 7.0),
	('SV002', 'C001', 8.0, 8.5),
	('SV003', 'C003', 7.0, 7.5),
	('SV004', 'C004', 9.0, 9.2);

        
-- Phần 3: Cập nhập dữ liệu
UPDATE Student
	SET student_email = 'a_new@gmail.com'
	WHERE student_id = 'SV001';

UPDATE Course
	SET description = 'CSDL'
	WHERE course_id = 'C001';


UPDATE Score
	SET final_score = 10
	WHERE student_id = 'SV001'
	  AND course_id = 'C001';


-- Phần 4: Xoá dữ liệu
DELETE FROM Enrollment
	WHERE student_id = 'SV003'
	  AND course_id = 'C003';

    

-- Phần 5: Truy vấn dữ liệu
SELECT * FROM Student;
SELECT * FROM Teacher;
SELECT * FROM Course;
SELECT * FROM Enrollment;
SELECT * FROM Score;