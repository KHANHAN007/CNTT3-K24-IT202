USE social_network_pro;

CREATE OR REPLACE VIEW view_user_post AS
SELECT 
    p.user_id,
    COUNT(p.post_id) AS total_user_post
FROM posts p
GROUP BY p.user_id;


SELECT 
    user_id,
    total_user_post
FROM view_user_post;


SELECT 
    u.full_name,
    v.total_user_post
FROM users u
JOIN view_user_post v
    ON u.user_id = v.user_id;

SELECT 
    u.full_name,
    IFNULL(v.total_user_post, 0) AS total_user_post
FROM users u
LEFT JOIN view_user_post v
    ON u.user_id = v.user_id;
