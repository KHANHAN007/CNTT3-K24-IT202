DELIMITER //
CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE v_post_id INT;
    DECLARE v_full_name VARCHAR(100);

    SELECT full_name INTO v_full_name
    FROM users
    WHERE user_id = p_user_id;

    INSERT INTO posts(user_id, content, created_at)
    VALUES (p_user_id, p_content, NOW());

    SET v_post_id = LAST_INSERT_ID();

    INSERT INTO notifications(user_id, type, content, created_at)
    SELECT 
        friend_user_id,
        'new_post',
        CONCAT(v_full_name, ' đã đăng một bài viết mới'),
        NOW()
    FROM (
        SELECT friend_id AS friend_user_id
        FROM friends
        WHERE user_id = p_user_id AND status = 'accepted'

        UNION

        -- Trường hợp p_user_id là friend_id
        SELECT user_id AS friend_user_id
        FROM friends
        WHERE friend_id = p_user_id AND status = 'accepted'
    ) AS all_friends
    WHERE friend_user_id <> p_user_id;  -- Không gửi cho chính mình

END //
DELIMITER ;

CALL NotifyFriendsOnNewPost(1, 'Hôm nay mình vừa học xong Stored Procedure!');
SELECT *
FROM notifications
ORDER BY notification_id DESC;
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
