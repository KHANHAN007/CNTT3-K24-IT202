EXPLAIN ANALYZE
SELECT user_id, full_name, hometown
FROM users
WHERE hometown = 'Hà Nội';

CREATE INDEX idx_hometown
ON users(hometown);


EXPLAIN ANALYZE
SELECT user_id, full_name, hometown
FROM users
WHERE hometown = 'Hà Nội';

DROP INDEX idx_hometown ON users;
