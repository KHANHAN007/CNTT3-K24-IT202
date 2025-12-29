USE Ex01;

DROP TABLE Score;
CREATE TABLE Score(
	student_id VARCHAR(20),
    subject_id VARCHAR(20),
    
    PRIMARY KEY (student_id, subject_id),
    
    CONSTRAINT fk_score_student
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    
    CONSTRAINT fk_score_subject
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),
    
    mid_score DECIMAL(4,2) NOT NULL CHECK(mid_score between 0 and 10),
    final_score DECIMAL(4,2) NOT NULL CHECK(final_score between 0 and 10)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
	VALUES
		('1', '1', 7.5, 8.0),
		('2', '1', 6.0, 7.0),
		('1', '2', 8.0, 9.0);

UPDATE Score
	SET final_score =  10.0
    WHERE student_id = '1' and subject_id = '1';
    
SELECT * FROM Score;

SELECT *
FROM Score
WHERE final_score >= 8;
