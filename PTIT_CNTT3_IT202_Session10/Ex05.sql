CREATE INDEX idx_hometown
ON users(hometown);


SELECT 
    u.user_id,
    u.username,
    u.full_name,
    u.hometown,
    p.post_id,
    p.content
FROM users u
JOIN posts p 
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    u.hometown,
    p.post_id,
    p.content
FROM users u
JOIN posts p 
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.username,
    u.full_name,
    u.hometown,
    p.post_id,
    p.content
FROM users u
JOIN posts p 
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

