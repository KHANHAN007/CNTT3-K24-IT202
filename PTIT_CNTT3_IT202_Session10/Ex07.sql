CREATE OR REPLACE VIEW view_user_activity_status AS
SELECT
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    CASE 
        WHEN 
            SUM(CASE WHEN p.post_id IS NOT NULL THEN 1 ELSE 0 END) > 0
         OR SUM(CASE WHEN c.comment_id IS NOT NULL THEN 1 ELSE 0 END) > 0
        THEN 'Active'
        ELSE 'Inactive'
    END AS status
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
LEFT JOIN comments c
    ON u.user_id = c.user_id
GROUP BY
    u.user_id,
    u.username,
    u.gender,
    u.created_at;


SELECT
    user_id,
    username,
    gender,
    created_at,
    status
FROM view_user_activity_status;

SELECT
    status,
    SUM(1) AS user_count
FROM view_user_activity_status
GROUP BY status
ORDER BY user_count DESC;

SELECT
    status,
    SUM(CASE WHEN user_id IS NOT NULL THEN 1 ELSE 0 END) AS user_count
FROM view_user_activity_status
GROUP BY status
ORDER BY user_count DESC;

