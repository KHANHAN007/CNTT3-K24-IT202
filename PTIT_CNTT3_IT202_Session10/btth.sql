USE social_network_pro;
ALTER TABLE posts 
ADD COLUMN privacy ENUM('PUBLIC','PRIVATE') DEFAULT 'PUBLIC';

CREATE VIEW view_public_user_profile AS
SELECT 
    username,
    email,
    created_at
FROM users;

SELECT * FROM view_public_user_profile;


CREATE VIEW view_public_news_feed AS
SELECT 
    p.post_id,
    u.username,
    p.content,
    p.created_at,
    COUNT(l.user_id) AS total_likes
FROM posts p
JOIN users u 
    ON p.user_id = u.user_id
LEFT JOIN likes l 
    ON p.post_id = l.post_id
WHERE p.privacy = 'PUBLIC'
GROUP BY p.post_id, u.username, p.content, p.created_at;

SELECT * FROM view_public_news_feed
ORDER BY created_at DESC;


CREATE VIEW view_posts_public_only AS
SELECT *
FROM posts
WHERE privacy = 'PUBLIC'
WITH CHECK OPTION;


INSERT INTO view_posts_public_only(user_id, content, privacy)
VALUES (1, 'Bài viết công khai', 'PUBLIC');




SELECT * 
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;


EXPLAIN SELECT * 
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;

CREATE INDEX idx_posts_privacy_created_at 
ON posts(privacy, created_at DESC);

CREATE INDEX idx_posts_user_id 
ON posts(user_id);

EXPLAIN SELECT * 
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;
