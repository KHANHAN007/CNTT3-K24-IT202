
USE QuanLyTruongHoc;

CREATE TABLE Student (
    StudentID INT NOT NULL,             -- Mã SV
    FullName VARCHAR(100) NOT NULL,     -- Tên SV
    PRIMARY KEY (StudentID)             
);

CREATE TABLE Subject (
    SubjectID INT NOT NULL,             -- Mã môn học
    SubjectName VARCHAR(100) NOT NULL,  -- Tên môn học
    Credits INT NOT NULL,               -- Số tín chỉ
    PRIMARY KEY (SubjectID),
	CHECK (Credits > 0)                 
);