

DROP PROCEDURE IF EXISTS sp_create_post;

DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

-- 3. Tạo lại bảng Users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);

-- 4. Tạo lại bảng Posts
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username, total_posts) VALUES ('nguyen_van_a', 0);
INSERT INTO users (username, total_posts) VALUES ('le_thi_b', 0);

DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT, 
    IN p_content TEXT
)
BEGIN
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'FAIL: Giao dịch thất bại. Đã Rollback dữ liệu.' AS status_message;
    END;

    IF p_content IS NULL OR TRIM(p_content) = '' THEN
        SELECT 'FAIL: Nội dung bài viết không được để trống!' AS status_message;
    ELSE
        START TRANSACTION;

            INSERT INTO posts (user_id, content) VALUES (p_user_id, p_content);

            UPDATE users SET total_posts = total_posts + 1 WHERE user_id = p_user_id;

        COMMIT;
        
        SELECT 'SUCCESS: Đã đăng bài và cập nhật thống kê.' AS status_message;
    END IF;
END //

DELIMITER ;


CALL sp_create_post(1, 'Hôm nay trời đẹp quá, đi học SQL thôi!');
CALL sp_create_post(1, 'Bài viết thứ 2 của tôi.');

CALL sp_create_post(1, '');

CALL sp_create_post(9999, 'Bài này sẽ gây lỗi Rollback');

   
SELECT * FROM posts;

SELECT * FROM users;

