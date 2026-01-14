CREATE TABLE friendships (
    follower_id INT,
    followee_id INT,
    status ENUM('pending', 'accepted') DEFAULT 'accepted',

    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

DELIMITER //
CREATE TRIGGER trg_after_insert_friendship
AFTER INSERT ON friendships
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' THEN
        UPDATE Users
        SET follower_count = follower_count + 1
        WHERE user_id = NEW.followee_id;
    END IF;
END//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE follow_user(
    IN p_follower_id INT,
    IN p_followee_id INT,
    IN p_status ENUM('pending', 'accepted')
)
BEGIN
    IF p_follower_id = p_followee_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể tự follow chính mình';
    END IF;

    IF EXISTS (
        SELECT 1 FROM friendships
        WHERE follower_id = p_follower_id
          AND followee_id = p_followee_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã tồn tại quan hệ follow';
    END IF;
    INSERT INTO friendships(follower_id, followee_id, status)
    VALUES (p_follower_id, p_followee_id, p_status);
END//
DELIMITER ;

CREATE VIEW user_profile AS
SELECT 
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    COALESCE(SUM(p.like_count), 0) AS total_likes,
    GROUP_CONCAT(
        CONCAT('[', p.post_id, '] ', LEFT(p.content, 50))
        ORDER BY p.created_at DESC
        SEPARATOR ' | '
    ) AS recent_posts
	FROM Users u
	LEFT JOIN Posts p ON u.user_id = p.user_id
	GROUP BY u.user_id, u.username, u.follower_count, u.post_count;


CALL follow_user(2, 1, 'accepted'); -- Bob follow Alice
CALL follow_user(3, 1, 'accepted'); -- Charlie follow Alice
SELECT username, follower_count FROM Users WHERE user_id = 1;


CALL follow_user(1, 1, 'accepted');

DELETE FROM friendships
	WHERE follower_id = 2 AND followee_id = 1;
    
SELECT username, follower_count FROM Users WHERE user_id = 1;
