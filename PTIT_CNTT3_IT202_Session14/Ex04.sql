CREATE TABLE IF NOT EXISTS comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (post_id) REFERENCES posts(post_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id)
);

ALTER TABLE posts
	ADD COLUMN comments_count INT DEFAULT 0;

DELIMITER //
CREATE PROCEDURE sp_post_comment (
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    START TRANSACTION;
    -- 1. Thêm bình luận
    INSERT INTO comments (post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    -- 2. Tạo SAVEPOINT sau khi insert comment
    SAVEPOINT after_insert;

    -- 3. Cập nhật số lượng comment
    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = p_post_id;

    -- 4. Kiểm tra update có thành công không
    IF ROW_COUNT() = 0 THEN
        -- Giả lập lỗi ở bước UPDATE
        ROLLBACK TO after_insert;
    END IF;

    -- 5. Thành công toàn bộ
    COMMIT;
END//
DELIMITER ;

CALL sp_post_comment(1, 1, 'Day la binh luan dau tien');
CALL sp_post_comment(999, 1, 'Binh luan loi');

SELECT * FROM comments;
SELECT post_id, comments_count FROM posts;
