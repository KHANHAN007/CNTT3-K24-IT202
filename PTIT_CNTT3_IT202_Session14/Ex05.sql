CREATE TABLE IF NOT EXISTS delete_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    deleted_by INT NOT NULL,
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_delete_post (
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner_id INT;
    START TRANSACTION;
    -- 1. Kiểm tra bài viết tồn tại và thuộc về user
		SELECT user_id INTO v_owner_id
		FROM posts
		WHERE post_id = p_post_id;

		IF v_owner_id IS NULL THEN
			ROLLBACK;
		END IF;

		IF v_owner_id <> p_user_id THEN
			ROLLBACK;
		END IF;

		-- 2. Xóa likes (bảng con)
		DELETE FROM likes
			WHERE post_id = p_post_id;

		-- 3. Xóa comments (bảng con)
		DELETE FROM comments
			WHERE post_id = p_post_id;

		-- 4. Xóa bài viết (bảng cha)
		DELETE FROM posts
			WHERE post_id = p_post_id;

		IF ROW_COUNT() = 0 THEN
			ROLLBACK;
		END IF;

		-- 5. Giảm posts_count của user
		UPDATE users
			SET posts_count = posts_count - 1
			WHERE user_id = p_user_id;

		-- 6. Ghi log xóa thành công
		INSERT INTO delete_log (post_id, deleted_by)
			VALUES (p_post_id, p_user_id);
    COMMIT;
END//
DELIMITER ;

CALL sp_delete_post(1, 1);
CALL sp_delete_post(1, 2);
CALL sp_delete_post(999, 1);

SELECT * FROM posts;
SELECT * FROM likes;
SELECT * FROM comments;
SELECT user_id, posts_count FROM users;
SELECT * FROM delete_log;
