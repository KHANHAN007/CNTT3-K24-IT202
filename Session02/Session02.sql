CREATE DATABASE Session02;
USE Session02;

-- Bai 1 :
CREATE TABLE Class (
    ClassID VARCHAR(10) PRIMARY KEY,
    ClassName VARCHAR(50) NOT NULL,
    SchoolYear INT NOT NULL
);

CREATE TABLE Student (
    StudentID VARCHAR(10) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE,
    ClassID VARCHAR(10) NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID)
);

-- Bai 2 :
CREATE TABLE Student_Info (
    StudentID VARCHAR(10) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL
);

CREATE TABLE Subject (
    SubjectID VARCHAR(10) PRIMARY KEY,
    SubjectName VARCHAR(100) NOT NULL,
    Credit INT CHECK (Credit > 0)
);

-- Bai 3 :
CREATE TABLE Enrollment (
    StudentID VARCHAR(10),
    SubjectID VARCHAR(10),
    EnrollDate DATE,

    PRIMARY KEY (StudentID, SubjectID),
    FOREIGN KEY (StudentID) REFERENCES Student_Info(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

-- Bai 4 :
CREATE TABLE Teacher (
    TeacherID VARCHAR(10) PRIMARY KEY,
    FullName  VARCHAR(100) NOT NULL,
    Email     VARCHAR(100) UNIQUE
);

ALTER TABLE Subject
ADD TeacherID VARCHAR(10);

ALTER TABLE Subject
ADD CONSTRAINT fk_subject_teacher
FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID);

-- Bai 5 : 
CREATE TABLE Score (
    StudentID VARCHAR(10),
    SubjectID VARCHAR(10),
    ProcessScore DECIMAL(4,2),
    FinalScore   DECIMAL(4,2),

    PRIMARY KEY (StudentID, SubjectID),

    CHECK (ProcessScore BETWEEN 0 AND 10),
    CHECK (FinalScore BETWEEN 0 AND 10),

    FOREIGN KEY (StudentID) REFERENCES Student_Info(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

-- Bai 6 : La tat ca nhung bai tren roi nhe 
-- Bai 7 : 

-- 1.Khách hàng
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName   VARCHAR(100) NOT NULL,
    CCCD       VARCHAR(12) NOT NULL UNIQUE,
    Phone      VARCHAR(15) NOT NULL UNIQUE,
    Email      VARCHAR(100),
    CreatedAt  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2.Tài khoản
CREATE TABLE Account (
    AccountID     INT AUTO_INCREMENT PRIMARY KEY,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    CustomerID    INT NOT NULL,
    Balance       DECIMAL(15,2) NOT NULL DEFAULT 0,

    CHECK (Balance >= 0),

    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- 3.Đối tác 
CREATE TABLE Partner (
    PartnerID   INT AUTO_INCREMENT PRIMARY KEY,
    PartnerName VARCHAR(100) NOT NULL UNIQUE,
    CreatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4.Hóa đơn học phí
CREATE TABLE TuitionBill (
    BillID      INT AUTO_INCREMENT PRIMARY KEY,
    PartnerID   INT NOT NULL,
    StudentName VARCHAR(100) NOT NULL,
    Amount      DECIMAL(15,2) NOT NULL,
    Status      VARCHAR(20) DEFAULT 'Unpaid',
    CreatedAt   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CHECK (Amount > 0),

    FOREIGN KEY (PartnerID) REFERENCES Partner(PartnerID)
);

-- 5. Giao dịch
CREATE TABLE Transaction (
    TransactionID   INT AUTO_INCREMENT PRIMARY KEY,
    AccountID       INT NOT NULL,
    BillID          INT NOT NULL UNIQUE,
    Amount          DECIMAL(15,2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          VARCHAR(20) DEFAULT 'Pending',

    CHECK (Amount > 0),

    FOREIGN KEY (AccountID) REFERENCES Account(AccountID),
    FOREIGN KEY (BillID) REFERENCES TuitionBill(BillID)
);





