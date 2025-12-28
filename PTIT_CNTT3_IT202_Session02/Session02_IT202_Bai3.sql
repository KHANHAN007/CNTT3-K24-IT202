USE QuanLyTruongHoc;

CREATE TABLE Enrollment (
    StudentID INT NOT NULL,             -- Lấy từ bảng Student
    SubjectID INT NOT NULL,             -- Lấy từ bảng Subject
    EnrollmentDate DATE,                -- Ngày đăng ký
    
    CONSTRAINT FK_Enrollment_Student 
        FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    CONSTRAINT FK_Enrollment_Subject 
        FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID),
    PRIMARY KEY (StudentID, SubjectID)
);