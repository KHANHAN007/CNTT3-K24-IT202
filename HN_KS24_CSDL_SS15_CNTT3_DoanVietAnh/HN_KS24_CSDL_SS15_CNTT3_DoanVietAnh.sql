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

SELECT StudentID, FullName, TotalDebt FROM Students;
SELECT SubjectID, SubjectName, Credits FROM Subjects;
SELECT StudentID, SubjectID, Score FROM Grades;
SELECT LogID, StudentID, OldScore, NewScore, ChangeDate FROM GradeLog;

DELIMITER //
create trigger tg_CheckScore before insert on Grades
for each row
begin
    if new.Score < 0 then
        set new.Score = 0;
    elseif new.Score > 10 then
        set new.Score = 10;
    end if;
end;
//
DELIMITER ;

insert into Grades (StudentID, SubjectID, Score) values ('SV01', 'SB02', -1); 
insert into Grades (StudentID, SubjectID, Score) values ('SV01', 'SB03', 15); 
select StudentID, FullName, TotalDebt from Grades where StudentID = 'SV01';

start transaction;
insert into Students (StudentID, FullName) value ('SV02', 'Ha Bich Ngoc');
update Students set TotalDebt = 5000000 where StudentID = 'SV02';
commit;

select StudentID, FullName, TotalDebt from Students where StudentID = 'SV02';


DELIMITER //
create trigger tg_LogGradeUpdate after update on Grades
for each row
begin
    insert into GradeLog (StudentID, OldScore, NewScore) value (new.StudentID, old.Score, new.Score);
end;
//
DELIMITER ;

update Grades set Score = 9.0 where StudentID = 'SV01' and SubjectID = 'SB01';
select LogID, StudentID, OldScore, NewScore, ChangeDate from GradeLog;

DELIMITER //
create procedure sp_PayTuition()
begin
    start transaction;
    update Students set TotalDebt = TotalDebt - 2000000 where StudentID = 'SV01';
    if (select TotalDebt from Students where StudentID = 'SV01') < 0 then
        rollback;
    else
        commit;
    end if;
end;
//
DELIMITER ;

call sp_PayTuition();
select TotalDebt from Students where StudentID = 'SV01';

DELIMITER //
create trigger tg_PreventPassUpdate before update on Grades
for each row
begin
    if old.Score >= 4.0 then
        signal sqlstate '45000' set message_text ='Không thể cập nhật điểm';
    end if;
end;
//
DELIMITER ;

update Grades set Score = 5.0 where StudentID = 'SV01' and SubjectID = 'SB01'; 

DELIMITER //
create procedure sp_DeleteStudentGrade(
	in p_StudentID char(5),
    in p_SubjectID char(5))
begin
    start transaction;
    insert into GradeLog (StudentID, OldScore, NewScore) 
    select StudentID, Score, null from Grades where StudentID = p_StudentID and SubjectID = p_SubjectID;
    delete from Grades where StudentID = p_StudentID and SubjectID = p_SubjectID;
    if row_count() = 0 then
        rollback;
    else
        commit;
    end if;
end;
//
DELIMITER ;

call sp_DeleteStudentGrade('SV03', 'SB02');
select StudentID, SubjectID, Score from Grades where StudentID = 'SV03';
select LogID, StudentID, OldScore, NewScore, ChangeDate from GradeLog where StudentID = 'SV03';



