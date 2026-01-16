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

-- phần a – cơ bản
-- câu 1: trigger tg_checkscore
delimiter //
create trigger tg_checkscore before insert on grades
for each row
begin
    if new.score < 0 then
        set new.score = 0;
    elseif new.score > 10 then
        set new.score = 10;
    end if;
end;
//
delimiter ;

-- câu 2: script transaction thêm sinh viên
start transaction;
insert into students (studentid, fullname) values ('sv02', 'ha bich ngoc');
update students set totaldebt = 5000000 where studentid = 'sv02';
commit;

-- phần b – khá
-- câu 3: trigger tg_loggradeupdate
delimiter //
create trigger tg_loggradeupdate after update on grades
for each row
begin
    if old.score != new.score then
        insert into gradelog (studentid, oldscore, newscore) values (new.studentid, old.score, new.score);
    end if;
end;
//
delimiter ;

-- câu 4: stored procedure sp_paytuition
delimiter //
create procedure sp_paytuition()
begin
    declare current_debt decimal(10,2);
    start transaction;
    select totaldebt into current_debt from students where studentid = 'sv01';
    update students set totaldebt = totaldebt - 2000000 where studentid = 'sv01';
    if (select totaldebt from students where studentid = 'sv01') < 0 then
        rollback;
    else
        commit;
    end if;
end;
//
delimiter ;
-- phần c – giỏi
-- câu 5: trigger tg_preventpassupdate
delimiter //
create trigger tg_preventpassupdate before update on grades
for each row
begin
    if old.score >= 4.0 then
        signal sqlstate '45000' set message_text = 'không duocwj sửa điểm của sinh viên đã qua môn !';
    end if;
end;
//
delimiter ;

-- câu 6: stored procedure sp_deletestudentgrade
delimiter //
create procedure sp_deletestudentgrade(in p_studentid char(5), in p_subjectid char(5))
begin
    declare old_score decimal(4,2);
    start transaction;
    select score into old_score from grades where studentid = p_studentid and subjectid = p_subjectid;
    insert into gradelog (studentid, oldscore, newscore) values (p_studentid, old_score, null);
    delete from grades where studentid = p_studentid and subjectid = p_subjectid;
    if row_count() = 0 then
        rollback;
    else
        commit;
    end if;
end;
//
delimiter ;

