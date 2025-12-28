DROP database Ex01;
CREATE database Ex01;

USE Ex01;
CREATE table Class(
	class_id VARCHAR(255) PRIMARY KEY,
    class_name VARCHAR(255) NOT NULL UNIQUE,
    class_year YEAR NOT NULL
);

CREATE table Student(
	student_id VARCHAR(255) PRIMARY KEY,
    student_fullname VARCHAR(255) NOT NULL,
    student_date_of_birth DATE NOT NULL,
    class_id VARCHAR(255),
		FOREIGN KEY (class_id) REFERENCES Class(class_id)
);