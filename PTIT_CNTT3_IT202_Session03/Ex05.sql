USE Ex01;
CREATE TABLE Score (
    student_id VARCHAR(20),
    subject_id VARCHAR(20),
    mid_score   DECIMAL(4,2) NOT NULL,
    final_score DECIMAL(4,2) NOT NULL,

    PRIMARY KEY (student_id, subject_id),

    CONSTRAINT chk_mid_score
        CHECK (mid_score BETWEEN 0 AND 10),

    CONSTRAINT chk_final_score
        CHECK (final_score BETWEEN 0 AND 10),

    CONSTRAINT fk_score_student
        FOREIGN KEY (student_id)
        REFERENCES Student(student_id),

    CONSTRAINT fk_score_subject
        FOREIGN KEY (subject_id)
        REFERENCES Subject(subject_id)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
    ('SV01', 'S01', 7.5, 8.0),
    ('SV01', 'S02', 6.5, 7.0),
    ('SV02', 'S01', 8.0, 8.5);
    
UPDATE Score
SET final_score = 8.2
WHERE student_id = 'SV01'
  AND subject_id = 'S02';
  
SELECT * FROM Score;

SELECT student_id, subject_id, final_score
FROM Score
WHERE final_score >= 8;

