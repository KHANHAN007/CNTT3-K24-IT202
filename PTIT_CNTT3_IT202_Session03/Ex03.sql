USE Ex01;

CREATE TABLE Subject(
	subject_id VARCHAR(20) PRIMARY KEY,
    subject_name VARCHAR(255) NOT NULL,
    credit INT NOT NULL 
		CHECK (credit > 0)
);

INSERT INTO Subject
	VALUES 	('1', 'CSDL', 4),
			('2', 'Agile/Scrum', 2),
            ('3', 'Lập trình C', 5);

UPDATE Subject
	SET credit = 6
    WHERE subject_id = '3';
    
UPDATE Subject
	SET subject_name = 'Cơ sở dữ liệu'
    WHERE subject_id = '1';