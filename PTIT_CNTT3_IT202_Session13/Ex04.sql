CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER trg_before_update_post
BEFORE UPDATE ON Posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        )
        VALUES (
            OLD.post_id,
            OLD.content,
            NEW.content,
            NOW(),
            OLD.user_id
        );
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_after_delete_post_log
AFTER DELETE ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_history (
        post_id,
        old_content,
        new_content,
        changed_at,
        changed_by_user_id
    )
    VALUES (
        OLD.post_id,
        OLD.content,
        NULL,
        NOW(),
        OLD.user_id
    );
END//
DELIMITER ;

UPDATE Posts
	SET content = 'Alice updated her first post'
	WHERE post_id = 1;
    
UPDATE Posts
	SET content = 'Bob edited his post'
	WHERE post_id = 3;

SELECT * FROM post_history
	ORDER BY changed_at DESC;

SELECT post_id, like_count FROM Posts;
	UPDATE Posts
	SET content = 'Another edit by Alice'
	WHERE post_id = 1;
