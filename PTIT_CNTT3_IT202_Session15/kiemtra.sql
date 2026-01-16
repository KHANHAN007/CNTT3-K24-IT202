/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File


-- Phần A
-- Câu 1: 
DELIMITER //
CREATE TRIGGER tg_CheckScore
	BEFORE INSERT ON Grades
    FOR EACH ROW
	BEGIN
		IF score < 0 THEN
			SET NEW.score = 0;
		END IF;
        
		IF NEW.Score > 10 THEN
			SET NEW.Score = 10;
		END IF;
    END //
DELIMITER ;

INSERT INTO Grades (StudentID, SubjectID, Score) 
	VALUES ('SV03', 'MH02', -5);

INSERT INTO Grades (StudentID, SubjectID, Score) 
	VALUES ('SV04', 'MH03', 15);

INSERT INTO Grades (StudentID, SubjectID, Score) 
	VALUES ('SV04', 'MH05', 8.5);

SELECT * FROM Grades 
	WHERE (StudentID = 'SV03' AND SubjectID = 'MH02')
	   OR (StudentID = 'SV04' AND SubjectID = 'MH03')
	   OR (StudentID = 'SV04' AND SubjectID = 'MH05');
   
   
   
-- Câu 2
START TRANSACTION;
	INSERT INTO Students (studentid, fullname, totaldebt)
		VALUES ('SV02', 'Ha Bich Ngoc', 0);
    UPDATE Students 
		SET totaldebt = 5000000
        WHERE studentid = 'SV02';
	COMMIT;


SELECT * FROM Students WHERE StudentID = 'SV02';

SELECT * FROM Grades WHERE StudentID = 'SV01' AND SubjectID = 'MH01';
UPDATE Grades 
SET Score = 9.5 
WHERE StudentID = 'SV01' AND SubjectID = 'MH01';

SELECT * FROM Grades WHERE StudentID = 'SV01' AND SubjectID = 'MH01';
SELECT * FROM GradeLog;




-- Phần B
-- Câu 3:
DELIMITER $$
CREATE TRIGGER tg_LogGradeUpdate
	AFTER UPDATE ON Grades
	FOR EACH ROW
	BEGIN
		IF OLD.Score != NEW.Score THEN
			INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
				VALUES (NEW.StudentID, OLD.Score, NEW.Score, NOW());
		END IF;
	END$$
DELIMITER ;

SELECT * FROM Grades WHERE StudentID = 'SV01' AND SubjectID = 'MH01';
UPDATE Grades 
SET Score = 9.5 
WHERE StudentID = 'SV01' AND SubjectID = 'MH01';
SELECT * FROM Grades WHERE StudentID = 'SV01' AND SubjectID = 'MH01';
SELECT * FROM GradeLog;



-- Câu 4: 
DELIMITER //
CREATE PROCEDURE sp_PayTuition()
	BEGIN
		DECLARE current_debt DECIMAL(10,2);
		
		START TRANSACTION;
			SELECT TotalDebt INTO current_debt
				FROM Students
				WHERE StudentID = 'SV01';
				
			UPDATE Students 
				SET TotalDebt = TotalDebt - 2000000 
				WHERE StudentID = 'SV01';
		
			IF (current_debt - 2000000) < 0 THEN
				ROLLBACK;
				SELECT 'ROLLBACK: Số tiền thanh toán vượt quá số nợ hiện tại!' AS Message;
			ELSE
				COMMIT;
				SELECT 'COMMIT: Thanh toán thành công!' AS Message;
			END IF;
	END//
DELIMITER ;

SELECT StudentID, FullName, TotalDebt 
FROM Students 
WHERE StudentID = 'SV01';
CALL sp_PayTuition();
SELECT StudentID, FullName, TotalDebt 
FROM Students 
WHERE StudentID = 'SV01';
CALL sp_PayTuition();


-- Phần C 
-- Câu 5
DELIMITER //
CREATE TRIGGER tg_PreventPassUpdate
	BEFORE UPDATE ON Grades
	FOR EACH ROW
	BEGIN
		IF OLD.Score >= 4.0 THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Không thể sửa điểm của sinh viên đã qua môn (điểm >= 4.0)!';
		END IF;
	END//
DELIMITER ;

SELECT * FROM Grades WHERE StudentID = 'SV01' AND SubjectID = 'MH02';

SELECT * FROM Grades WHERE StudentID = 'SV05' AND SubjectID = 'MH01';

UPDATE Grades 
SET Score = 3.8 
WHERE StudentID = 'SV05' AND SubjectID = 'MH01';

SELECT * FROM Grades WHERE StudentID = 'SV05' AND SubjectID = 'MH01';



-- Câu 6
DELIMITER //
CREATE PROCEDURE sp_DeleteStudentGrade(
    IN p_StudentID CHAR(5),
    IN p_SubjectID CHAR(5)
)
	BEGIN
		DECLARE old_score DECIMAL(4,2);
		DECLARE rows_affected INT;
		
		START TRANSACTION;
		
		SELECT Score INTO old_score
			FROM Grades
			WHERE StudentID = p_StudentID AND SubjectID = p_SubjectID;
		
		INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
			VALUES (p_StudentID, old_score, NULL, NOW());
		
		DELETE FROM Grades
			WHERE StudentID = p_StudentID AND SubjectID = p_SubjectID;
		
		SET rows_affected = ROW_COUNT();
		
		IF rows_affected = 0 THEN
			ROLLBACK;
			SELECT 'ROLLBACK: Không tìm thấy dữ liệu để xóa!' AS Message;
		ELSE
			COMMIT;
			SELECT CONCAT('COMMIT: Đã xóa thành công điểm của sinh viên ', p_StudentID, 
						 ' môn ', p_SubjectID) AS Message;
		END IF;
	END//
DELIMITER ;


SELECT * FROM Grades WHERE StudentID = 'SV04' AND SubjectID = 'MH05';

CALL sp_DeleteStudentGrade('SV04', 'MH05');

SELECT * FROM Grades WHERE StudentID = 'SV04' AND SubjectID = 'MH05';

SELECT * FROM GradeLog ORDER BY LogID DESC LIMIT 1;

CALL sp_DeleteStudentGrade('SV99', 'MH99');

USE StudentManagement;

SHOW TRIGGERS;

SHOW PROCEDURE STATUS WHERE Db = 'StudentManagement';


SELECT * FROM Students ORDER BY StudentID;

SELECT * FROM Subjects ORDER BY SubjectID;

SELECT * FROM Grades ORDER BY StudentID, SubjectID;

SELECT * FROM GradeLog ORDER BY LogID;

INSERT INTO Grades (StudentID, SubjectID, Score) 
	VALUES ('SV02', 'MH01', 12); 

SELECT * FROM Grades WHERE StudentID = 'SV02';

UPDATE Grades 
SET Score = 8.0 
WHERE StudentID = 'SV03' AND SubjectID = 'MH01';

SELECT * FROM GradeLog ORDER BY LogID DESC LIMIT 1;

-- UPDATE Grades SET Score = 9.0 WHERE StudentID = 'SV03' AND SubjectID = 'MH03';