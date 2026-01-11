CREATE OR REPLACE VIEW view_user_activity AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
LEFT JOIN comments c
    ON u.user_id = c.user_id
GROUP BY
    u.user_id;

SELECT
    user_id,
    total_posts,
    total_comments
FROM view_user_activity;

SELECT
    u.user_id,
    u.username,
    u.full_name,
    v.total_posts,
    v.total_comments
FROM users u
JOIN view_user_activity v
    ON u.user_id = v.user_id
WHERE v.total_posts > 5
  AND v.total_comments > 20
ORDER BY v.total_comments DESC
LIMIT 5;
