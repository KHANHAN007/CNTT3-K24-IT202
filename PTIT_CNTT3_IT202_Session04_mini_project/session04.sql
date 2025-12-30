CREATE DATABASE  OnlineLearningSystem;
USE OnlineLearningSystem;

CREATE TABLE Instructor (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Course (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    total_sessions INT CHECK (total_sessions > 0),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE (student_id, course_id)
);

CREATE TABLE Result (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    midterm_score FLOAT CHECK (midterm_score BETWEEN 0 AND 10),
    final_score FLOAT CHECK (final_score BETWEEN 0 AND 10),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE (student_id, course_id)
);

INSERT INTO Instructor (full_name, email) VALUES 
('Nguyen Van Hung', 'hung.nv@uni.edu.vn'),
('Tran Thi Mai', 'mai.tt@uni.edu.vn'),
('Le Van Son', 'son.lv@uni.edu.vn'),
('Pham Thu Ha', 'ha.pt@uni.edu.vn'),
('Hoang Minh Tuan', 'tuan.hm@uni.edu.vn');

INSERT INTO Course (course_name, description, total_sessions, instructor_id) VALUES 
('Lap trinh C# co ban', 'Nhap mon C# va .NET', 12, 1),
('Co so du lieu SQL', 'Thiet ke va truy van CSDL', 15, 2),
('Lap trinh Web voi React', 'Frontend hien dai', 20, 3),
('Cau truc du lieu & Giai thuat', 'Nen tang CNTT', 18, 1),
('Tieng Anh chuyen nganh IT', 'Tu vung va giao tiep', 10, 4);

INSERT INTO Student (full_name, date_of_birth, email) VALUES 
('Dang Van Lam', '2003-01-15', 'lam.dv@st.uni.edu.vn'),
('Nguyen Quang Hai', '2003-05-20', 'hai.nq@st.uni.edu.vn'),
('Doan Van Hau', '2002-12-10', 'hau.dv@st.uni.edu.vn'),
('Que Ngoc Hai', '2001-08-05', 'hai.qn@st.uni.edu.vn'),
('Nguyen Cong Phuong', '2002-03-25', 'phuong.nc@st.uni.edu.vn');

INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES 
(1, 1, '2024-01-10'), 
(1, 2, '2024-01-12'), 
(2, 2, '2024-01-11'), 
(3, 3, '2024-01-15'), 
(4, 1, '2024-01-20'), 
(5, 5, '2024-02-01'); 

INSERT INTO Result (student_id, course_id, midterm_score, final_score) VALUES 
(1, 1, 7.5, 8.0), 
(1, 2, 6.0, 7.5), 
(2, 2, 8.5, 9.0), 
(3, 3, 5.0, 6.5), 
(4, 1, 9.0, 9.5); 

UPDATE Student 
SET email = 'lam.dv.new@st.uni.edu.vn' 
WHERE student_id = 1;

UPDATE Course 
SET description = 'Frontend hien dai voi ReactJS va TypeScript' 
WHERE course_id = 3;

UPDATE Result 
SET final_score = 9.5 
WHERE student_id = 2 AND course_id = 2;

DELETE FROM Result 
WHERE student_id = 5 AND course_id = 5;

DELETE FROM Enrollment 
WHERE student_id = 5 AND course_id = 5;


SELECT * FROM Student;

SELECT * FROM Instructor;

SELECT 
    c.course_id, 
    c.course_name, 
    c.description, 
    c.total_sessions, 
    i.full_name AS instructor_name
FROM Course c, Instructor i
WHERE c.instructor_id = i.instructor_id;

SELECT 
    e.enrollment_id, 
    s.full_name AS student_name, 
    c.course_name, 
    e.enrollment_date
FROM Enrollment e, Student s, Course c
WHERE e.student_id = s.student_id 
  AND e.course_id = c.course_id;

SELECT 
    r.result_id,
    s.full_name AS student_name,
    c.course_name,
    r.midterm_score,
    r.final_score,
    (r.midterm_score * 0.4 + r.final_score * 0.6) AS average_score 
FROM Result r, Student s, Course c
WHERE r.student_id = s.student_id 
  AND r.course_id = c.course_id;