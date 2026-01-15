DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username, total_posts)
	VALUES 	('nguyen_van_a', 0),
			('le_thi_b', 0);

DELIMITER //
CREATE PROCEDURE sp_create_post (
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi khi tạo bài viết. Giao dịch đã được rollback.';
    END;

    IF p_content IS NULL OR TRIM(p_content) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nội dung bài viết không được để trống';
    END IF;

    START TRANSACTION;
        INSERT INTO posts (user_id, content)
			VALUES (p_user_id, p_content);

        UPDATE users
			SET total_posts = total_posts + 1
			WHERE user_id = p_user_id;
    COMMIT;
END//

DELIMITER ;

CALL sp_create_post(1, 'Bài viết đầu tiên của tôi');

CALL sp_create_post(9999, 'Bài viết lỗi');

CALL sp_create_post(1, '');

SELECT * FROM users;
SELECT * FROM posts;
