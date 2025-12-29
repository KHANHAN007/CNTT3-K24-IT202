
DROP DATABASE IF EXISTS SchoolManagement;
CREATE DATABASE SchoolManagement;
USE SchoolManagement;

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;


CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,            
    date_of_birth DATE,                        
    email VARCHAR(100) UNIQUE                  
);

CREATE TABLE Subject (
    subject_id INT AUTO_INCREMENT PRIMARY KEY, 
    subject_name VARCHAR(100) NOT NULL,        
    credit INT NOT NULL,                        
    CONSTRAINT chk_credit CHECK (credit > 0)
);

CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE DEFAULT (CURRENT_DATE), 
    
    PRIMARY KEY (student_id, subject_id),
    
    CONSTRAINT fk_enrollment_student 
        FOREIGN KEY (student_id) REFERENCES Student(student_id)
        ON DELETE CASCADE, 
    CONSTRAINT fk_enrollment_subject 
        FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
        ON DELETE CASCADE  
);

CREATE TABLE Score (
    student_id INT,
    subject_id INT,
    mid_score DECIMAL(4, 2),   
    final_score DECIMAL(4, 2), 
    
    PRIMARY KEY (student_id, subject_id),
    
    CONSTRAINT fk_score_student 
        FOREIGN KEY (student_id) REFERENCES Student(student_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_score_subject 
        FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
        ON DELETE CASCADE,
    
    CONSTRAINT chk_mid_score CHECK (mid_score >= 0 AND mid_score <= 10),
    CONSTRAINT chk_final_score CHECK (final_score >= 0 AND final_score <= 10)
);

--
INSERT INTO Student (full_name, date_of_birth, email) VALUES 
('Nguyen Van An', '2003-05-10', 'an.nguyen@example.com'),   
('Tran Thi Binh', '2003-08-20', 'binh.tran@example.com'),   
('Le Van Cuong', '2003-12-15', 'cuong.le@example.com');    

INSERT INTO Student (student_id, full_name, email, date_of_birth) 
VALUES (5, 'Nguyen Van Nhap Nham', 'nhapnham@test.com', '2000-01-01');

UPDATE Student SET email = 'email.moi.update@example.com' WHERE student_id = 3;
UPDATE Student SET date_of_birth = '1999-12-31' WHERE student_id = 2;
DELETE FROM Student WHERE student_id = 5;

INSERT INTO Subject (subject_name, credit) VALUES 
('Toan Cao Cap', 3),       -- ID 1
('Tin Hoc Dai Cuong', 2),  -- ID 2
('Triet Hoc', 3),          -- ID 3
('Lap Trinh Java', 4);     -- ID 4

UPDATE Subject SET credit = 3 WHERE subject_id = 2;
UPDATE Subject SET subject_name = 'Toan Cao Cap A1' WHERE subject_id = 1;

INSERT INTO Enrollment (student_id, subject_id) VALUES
(1, 1),
(1, 4),
(2, 1);


INSERT INTO Score (student_id, subject_id, mid_score, final_score) VALUES 
(1, 1, 7.5, 8.0),  
(1, 2, 6.0, 7.5),  
(2, 1, 8.0, 9.0),  
(3, 2, 4.0, 5.0);  

UPDATE Score SET final_score = 9.5 WHERE student_id = 1 AND subject_id = 1;


SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Student;
SELECT * FROM Subject;
SELECT * FROM Enrollment;
SELECT * FROM Score;