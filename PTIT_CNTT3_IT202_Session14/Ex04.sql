USE social_network;

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

CREATE PROCEDURE sp_post_comment(
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    START TRANSACTION;

    INSERT INTO comments(post_id, user_id, content)
		VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    IF p_content = 'ERROR' THEN
        ROLLBACK TO after_insert;
        COMMIT;
    ELSE
        UPDATE posts
			SET comments_count = comments_count + 1
			WHERE post_id = p_post_id;
        COMMIT;
    END IF;
END //

DELIMITER ;

CALL sp_post_comment(1, 1, 'Bình luận hợp lệ');
CALL sp_post_comment(1, 1, 'ERROR');

SELECT * FROM comments;
SELECT post_id, comments_count FROM posts;
