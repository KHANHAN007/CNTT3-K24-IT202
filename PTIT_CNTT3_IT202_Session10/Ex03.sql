EXPLAIN ANALYZE
SELECT 
    user_id,
    username,
    full_name,
    email,
    hometown,
    created_at
FROM users
WHERE hometown = 'Hà Nội';

CREATE INDEX idx_hometown
ON users(hometown);

EXPLAIN ANALYZE
SELECT 
    user_id,
    username,
    full_name,
    email,
    hometown,
    created_at
FROM users
WHERE hometown = 'Hà Nội';

DROP INDEX idx_hometown ON users;
