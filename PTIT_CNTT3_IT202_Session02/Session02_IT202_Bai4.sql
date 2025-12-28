USE QuanLyTruongHoc;

CREATE TABLE Teacher (
    TeacherID INT NOT NULL,             -- Mã giảng viên
    FullName VARCHAR(100) NOT NULL,     -- Họ tên
    Email VARCHAR(100),                 -- Email (Có thể để trống hoặc không)
    
    PRIMARY KEY (TeacherID)             -- Khóa chính
);


ALTER TABLE Subject
ADD TeacherID INT;

ALTER TABLE Subject
ADD CONSTRAINT FK_Subject_Teacher       -- Đặt tên cho mối liên kết
FOREIGN KEY (TeacherID)                 -- Cột trong bảng Subject
REFERENCES Teacher(TeacherID);          -- Trỏ tới bảng Teacher