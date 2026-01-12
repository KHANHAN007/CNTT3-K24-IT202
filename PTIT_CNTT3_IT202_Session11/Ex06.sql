DELIMITER $$
CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE v_post_id INT;
    DECLARE v_full_name VARCHAR(255);

    -- Lấy full_name của người đăng
    SELECT full_name
    INTO v_full_name
    FROM users
    WHERE user_id = p_user_id;

    -- 1. Thêm bài viết mới
    INSERT INTO posts(user_id, content, created_at)
    VALUES (p_user_id, p_content, NOW());

    -- Lấy id của bài viết vừa thêm (nếu cần dùng về sau)
    SET v_post_id = LAST_INSERT_ID();

    -- 2. Gửi thông báo cho tất cả bạn bè đã accepted (cả hai chiều)
    INSERT INTO notifications(user_id, type, content, created_at)
    SELECT 
        CASE 
            WHEN f.user_id = p_user_id THEN f.friend_id
            ELSE f.user_id
        END AS receiver_id,
        'new_post' AS type,
        CONCAT(v_full_name, ' đã đăng một bài viết mới') AS content,
        NOW() AS created_at
    FROM friends f
    WHERE f.status = 'accepted'
      AND (f.user_id = p_user_id OR f.friend_id = p_user_id)
      -- không gửi cho chính người đăng
      AND (
            CASE 
                WHEN f.user_id = p_user_id THEN f.friend_id
                ELSE f.user_id
            END
          ) <> p_user_id;

END$$
DELIMITER ;
CALL NotifyFriendsOnNewPost(1, 'Hôm nay mình vừa hoàn thành bài tập SQL!');
SELECT
    n.notification_id,
    n.user_id,
    n.type,
    n.content,
    n.created_at
FROM notifications n
WHERE n.type = 'new_post'
ORDER BY n.created_at DESC;
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
