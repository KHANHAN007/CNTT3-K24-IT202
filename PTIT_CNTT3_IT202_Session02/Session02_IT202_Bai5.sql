USE QuanLyTruongHoc;

CREATE TABLE Score (
    StudentID INT NOT NULL,
    SubjectID INT NOT NULL,
    ProcessScore DECIMAL(4, 2),    -- Điểm quá trình (Kiểu số thực để lưu điểm lẻ, vd: 8.5)
    FinalScore DECIMAL(4, 2),      -- Điểm cuối kỳ
    
    PRIMARY KEY (StudentID, SubjectID),
    
    CONSTRAINT FK_Score_Student 
        FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
        
    CONSTRAINT FK_Score_Subject 
        FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID),
        
    CONSTRAINT CK_ProcessScore CHECK (ProcessScore >= 0 AND ProcessScore <= 10),
    CONSTRAINT CK_FinalScore CHECK (FinalScore >= 0 AND FinalScore <= 10)
);