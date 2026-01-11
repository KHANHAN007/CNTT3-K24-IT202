EXPLAIN ANALYZE
SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND created_at BETWEEN '2026-01-01' AND '2026-12-31';

CREATE INDEX idx_created_at_user_id
ON posts(created_at, user_id);


EXPLAIN ANALYZE
SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND created_at BETWEEN '2026-01-01' AND '2026-12-31';


EXPLAIN ANALYZE
SELECT user_id, username, email
FROM users
WHERE email = 'an@gmail.com';


CREATE UNIQUE INDEX idx_email
ON users(email);

EXPLAIN ANALYZE
SELECT user_id, username, email
FROM users
WHERE email = 'an@gmail.com';


ALTER TABLE posts DROP INDEX idx_created_at_user_id;
ALTER TABLE users DROP INDEX idx_email;
