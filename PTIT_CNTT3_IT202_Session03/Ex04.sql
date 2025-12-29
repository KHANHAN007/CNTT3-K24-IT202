USE Ex01;

CREATE TABLE Enrollment(
	student_id VARCHAR(20),
    subject_id VARCHAR(20),
    enroll_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (student_id, subject_id),
    
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- sv n-n mh
-- sv 1-n enroll
-- mh 1-n eroll

INSERT INTO Enrollment (student_id, subject_id)
VALUES
    ('SV01', 'S01'),
    ('SV01', 'S02'),
    ('SV02', 'S01'),
    ('SV02', 'S03');
    
SELECT * FROM Enrollment;
WHERE student_id = 'SV01';

