DROP DATABASE StudentDB;
CREATE DATABASE StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

-- Tạo View View_StudentBasic hiển thị: StudentID, FullName , DeptName. Sau đó truy vấn toàn bộ View_StudentBasic;
CREATE VIEW View_StudentBasic AS
	SELECT 	s.studentid,
			s.fullname,
            d.deptname
		FROM Student s
        JOIN Department d ON s.deptid = d.deptid;

SELECT 	studentid,
		fullname,
		deptname
	FROM View_StudentBasic;

-- Tạo Regular Index cho cột FullName của bảng Student.
CREATE INDEX idx_student_fullname ON Student(fullname);

-- Viết Stored Procedure GetStudentsIT
DELIMITER //
CREATE PROCEDURE GetStudentsIt()
BEGIN
	SELECT s.StudentID, s.FullName, d.DeptName
		FROM Department d
        JOIN Student s ON s.deptid = d.deptid
        WHERE d.deptname = 'Information Technology';
END //
DELIMITER ;
CALL GetStudentsIt;

-- Câu 4:
-- a)Tạo View View_StudentCountByDept hiển thị: DeptName, TotalStudents (số sinh viên mỗi khoa).
CREATE VIEW View_StudentCountByDept AS
	SELECT d.DeptName, COUNT(s.StudentID) AS TotalStudents
		FROM Department d
        LEFT JOIN Student s ON s.deptid = d.deptid
        GROUP BY d.deptname;
        
-- b)Từ View trên, viết truy vấn hiển thị khoa có nhiều sinh viên nhất.
SELECT DeptName, TotalStudents
	FROM View_StudentCountByDept
	ORDER BY TotalStudents DESC
	LIMIT 1;
    
-- Câu 5:
-- Viết Stored Procedure GetTopScoreStudent
DELIMITER //
CREATE PROCEDURE GetTopScoreStudent(IN p_CourseID CHAR(6))
	BEGIN
		SELECT e.StudentID, s.FullName, e.Score
			FROM Enrollment e
             JOIN Student s ON e.StudentID = s.StudentID
			WHERE e.CourseID = p_CourseID
			ORDER BY e.Score DESC
            LIMIT 1;
	END //
DELIMITER ;

-- b) Gọi thủ tục trên để tìm sinh viên có điểm cao nhất môn Database Systems (C00001).
CALL GetTopScoreStudent('C00001');


-- Phần C
-- Bài 6:
-- a. Tạo view
CREATE OR REPLACE VIEW View_IT_Enrollment_DB AS
	SELECT e.StudentID, e.CourseID, e.Score
		FROM Enrollment e
		WHERE e.CourseID = 'C00001'
		  AND e.StudentID IN (
			SELECT s.StudentID FROM Student s
				WHERE s.DeptID = (
				  SELECT DeptID FROM Department WHERE DeptName = 'Information Technology'
				)
		  )
WITH CASCADED CHECK OPTION;

-- b. Viết Stored Procedure UpdateScore_IT_DB
DELIMITER $$
CREATE PROCEDURE UpdateScore_IT_DB(IN p_StudentID CHAR(6), INOUT p_NewScore FLOAT)
BEGIN
  IF p_NewScore > 10 THEN
    SET p_NewScore = 10;
  END IF;
	  UPDATE View_IT_Enrollment_DB
	  SET Score = p_NewScore
	  WHERE StudentID = p_StudentID AND CourseID = 'C00001';
	  SELECT p_NewScore AS FinalScore;
END $$
DELIMITER ;

-- c
SET @newscore = 11;
CALL UpdateScore_IT_DB('S00001', @newscore);
SELECT @newscore AS UpdatedValue;
SELECT StudentID, CourseID, Score FROM View_IT_Enrollment_DB WHERE StudentID = 'S00001';
			
