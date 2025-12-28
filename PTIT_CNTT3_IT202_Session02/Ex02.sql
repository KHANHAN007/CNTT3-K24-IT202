DROP database Ex02;
CREATE database Ex02;

USE Ex02;

CREATE TABLE Class (
    class_id VARCHAR(20) PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL UNIQUE,
    school_year YEAR NOT NULL
);

CREATE TABLE Student (
    student_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    class_id VARCHAR(20) NOT NULL,

    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
);

CREATE TABLE Teacher (
    teacher_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Subject (
    subject_id VARCHAR(20) PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL,
    teacher_id VARCHAR(20),

    CONSTRAINT chk_credit
        CHECK (credit > 0),

    CONSTRAINT fk_subject_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    student_id VARCHAR(20),
    subject_id VARCHAR(20),
    enroll_date DATE NOT NULL,

    PRIMARY KEY (student_id, subject_id),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    CONSTRAINT fk_enrollment_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);

CREATE TABLE Score (
    student_id VARCHAR(20),
    subject_id VARCHAR(20),
    process_score DECIMAL(4,2),
    final_score DECIMAL(4,2),

    PRIMARY KEY (student_id, subject_id),

    CONSTRAINT chk_process_score
        CHECK (process_score BETWEEN 0 AND 10),

    CONSTRAINT chk_final_score
        CHECK (final_score BETWEEN 0 AND 10),

    CONSTRAINT fk_score_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    CONSTRAINT fk_score_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);