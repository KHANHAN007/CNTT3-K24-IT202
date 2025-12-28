CREATE DATABASE QuanLyTruongHoc;

USE QuanLyTruongHoc;


CREATE TABLE Class (
    ClassID INT NOT NULL,               -- Mã lớp (Số nguyên)
    ClassName VARCHAR(50) NOT NULL,     -- Tên lớp (Chuỗi tối đa 50 ký tự)
    SchoolYear VARCHAR(20),             -- Năm học (Ví dụ: "2023-2024")
    PRIMARY KEY (ClassID)               -- Thiết lập Khóa Chính
);
CREATE TABLE Student (
    StudentID INT NOT NULL,             -- Mã sinh viên
    FullName VARCHAR(100) NOT NULL,     -- Họ và tên
    DateOfBirth DATE,                   -- Ngày tháng năm sinh
    ClassID INT,                        -- Mã lớp (Phải cùng kiểu INT với bảng Class)
    
    PRIMARY KEY (StudentID),            -- Thiết lập Khóa Chính cho SV
    
    -- Thiết lập Khóa Ngoại (Ràng buộc quan hệ)
    CONSTRAINT FK_Student_Class         -- Đặt tên cho ràng buộc (tùy chọn nhưng nên làm)
    FOREIGN KEY (ClassID)               -- Cột trong bảng Student
    REFERENCES Class(ClassID)           -- Tham chiếu đến cột trong bảng Class
);