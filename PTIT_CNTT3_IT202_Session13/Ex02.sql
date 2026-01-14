USE Session13;

CREATE TABLE Likes(
	like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at DATETIME DEFAULT(current_date()),
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
	(2, 1, '2025-01-10 11:00:00'),
	(3, 1, '2025-01-10 13:00:00'),
	(1, 3, '2025-01-11 10:00:00'),
	(3, 4, '2025-01-12 16:00:00');
    
DELIMITER //
CREATE TRIGGER trg_afer_insert_like
	AFTER INSERT ON Likes
    FOR EACH ROW
    BEGIN
		UPDATE Posts
			SET like_count = like_count + 1
			WHERE post_id = NEW.post_id;
	END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_after_delete_like
	AFTER DELETE ON Likes
    FOR EACH ROW
    BEGIN
		UPDATE Posts
			SET like_count = like_count - 1
            WHERE post_id = OLD.post_id;
	END //
DELIMITER ;

CREATE VIEW vw_user_statistics AS
	SELECT 	u.user_id,
			u.username,
            u.post_count,
            COALESCE(SUM(p.like_count), 0) AS total_likes
		FROM Users u
        LEFT JOIN Posts p ON u.user_id = p.user_id
        GROUP BY u.user_id, u.username, u.post_count;
        
INSERT INTO Likes (user_id, post_id, liked_at)
	VALUES (2, 4, NOW());
    
SELECT * FROM Posts WHERE post_id = 4;
SELECT * FROM vw_user_statistics;

DELETE FROM likes
	WHERE user_id = 2 AND post_id = 4
	ORDER BY like_id DESC
	LIMIT 1;
