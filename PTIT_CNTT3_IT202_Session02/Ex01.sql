DROP database Ex01;
CREATE database Ex01;

USE Ex01;
CREATE TABLE Class (
    class_code   VARCHAR(10) PRIMARY KEY,
    class_title  VARCHAR(100) NOT NULL,
    academic_year YEAR NOT NULL
);

CREATE TABLE Student (
    student_code VARCHAR(10) PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    birth_date   DATE,
    class_code   VARCHAR(10) NOT NULL,
    CONSTRAINT fk_student_class
        FOREIGN KEY (class_code)
        REFERENCES Class(class_code)
);
