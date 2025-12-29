USE Ex01;

DROP TABLE Subject;
CREATE TABLE Subject(
	subject_id VARCHAR(20) PRIMARY KEY,
    subject_name VARCHAR(255) NOT NULL,
    credit INT CHECK (credit > 0)
);

INSERT INTO Subject
	VALUES 	('S01', 'CSDL', 5), 
			('S02', 'Nhập môn C', 4),
            ('S03', 'Agile/Scrum', 2);
			
UPDATE Subject
	SET credit = 6,
		subject_name = 'Lập trình C'
    WHERE subject_id = 'S02';
    
