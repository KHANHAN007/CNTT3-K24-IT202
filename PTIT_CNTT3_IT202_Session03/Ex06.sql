INSERT INTO Student (student_id, student_fullname, student_email, student_date_of_birth)
VALUES ('SV99', 'Nguyen Van Moi', 'sv99@gmail.com', '2006-09-01');
INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
    ('SV99', 'S01', '2025-01-10'),
    ('SV99', 'S02', '2025-01-10');
INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
    ('SV99', 'S01', 7.0, 7.5),
    ('SV99', 'S02', 6.5, 7.0);
UPDATE Score
SET final_score = 8.5
WHERE student_id = 'SV99'
  AND subject_id = 'S02';
DELETE FROM Score
WHERE student_id = 'SV99'
  AND subject_id = 'S01';
DELETE FROM Enrollment
WHERE student_id = 'SV99'
  AND subject_id = 'S01';
SELECT
    s.student_id,
    s.student_fullname,
    sub.subject_name,
    sc.mid_score,
    sc.final_score
FROM Student s
JOIN Score sc ON s.student_id = sc.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id;
