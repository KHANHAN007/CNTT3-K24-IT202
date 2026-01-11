CREATE INDEX idx_user_gender
ON users(gender);

CREATE OR REPLACE VIEW view_popular_posts AS
SELECT
    p.post_id,
    u.username,
    p.content,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM posts p
JOIN users u
    ON p.user_id = u.user_id
LEFT JOIN likes l
    ON p.post_id = l.post_id
LEFT JOIN comments c
    ON p.post_id = c.post_id
GROUP BY
    p.post_id,
    u.username,
    p.content;

SELECT
    post_id,
    username,
    content,
    total_likes,
    total_comments
FROM view_popular_posts;

SELECT
    post_id,
    username,
    content,
    total_likes,
    total_comments,
    (total_likes + total_comments) AS total_interactions
FROM view_popular_posts
WHERE (total_likes + total_comments) > 10
ORDER BY total_interactions DESC;
