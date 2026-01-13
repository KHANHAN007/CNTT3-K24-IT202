DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

CREATE TABLE Users(
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts(
	post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Friends(
	user_id INT,
    friend_id INT,
    status ENUM('pending', 'accepted'),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes(
	user_id INT,
    post_id INT,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

CREATE TABLE Comments(
	comment_id INT AUTO_INCREMENT PRIMARY KEY,
	post_id INT NOT NULL,
	user_id INT NOT NULL,
	content TEXT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (post_id) REFERENCES Posts(post_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


INSERT INTO Users(username,password,email) 
	VALUES	('an','123','an@gmail.com'),
			('binh','123','binh@gmail.com'),
			('cuong','123','cuong@gmail.com'),
			('dung','123','dung@gmail.com');
            

CREATE VIEW vw_public_users AS
	SELECT u.user_id, username, created_at
    FROM Users u;
    

CREATE INDEX idx_users_username ON Users(username);


DELIMITER //
CREATE PROCEDURE sp_create_post(
	IN p_user_id INT,
    IN p_content TEXT
)
	BEGIN
		IF EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
			INSERT INTO Posts(user_id, content)
				VALUES (p_user_id, p_content);
		ELSE 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User không tồn tại';
		END IF;
	END //
DELIMITER ;

CALL sp_create_post(1,'Hello database');
CALL sp_create_post(2,'Learning SQL');


CREATE VIEW vw_recent_posts AS
	SELECT p.post_id, u.username, p.content, p.created_at
		FROM Posts p
		JOIN Users u ON p.user_id = u.user_id
		WHERE p.created_at >= NOW() - INTERVAL 7 DAY;

        
CREATE INDEX idx_posts_user ON Posts(user_id);
CREATE INDEX idx_posts_user_date ON Posts(user_id, created_at);

DELIMITER //
CREATE PROCEDURE sp_count_posts(
	IN p_user_id INT,
    OUT p_total INT
)
	BEGIN
		SELECT COUNT(p.post_id) INTO p_total
			FROM Posts p
            WHERE user_id = p_user_id;
	END//
DELIMITER ;

SET @total = 0;
CALL sp_count_posts(1, @total);
SELECT @total AS total_posts_user1;


ALTER TABLE Users ADD is_active TINYINT DEFAULT 1;

CREATE VIEW vw_active_users AS
	SELECT * 
    FROM Users
    WHERE is_active = 1
    WITH CHECK OPTION;
    
DELIMITER //
CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    IF p_user_id = p_friend_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể kết bạn với chính mình';
    ELSEIF EXISTS (
        SELECT 1 FROM Friends 
        WHERE user_id = p_user_id AND friend_id = p_friend_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đã gửi lời mời hoặc đã là bạn';
    ELSE
        INSERT INTO Friends(user_id, friend_id, status)
        VALUES (p_user_id, p_friend_id, 'pending');
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT,
    INOUT p_limit INT
)
BEGIN
    DECLARE counter INT DEFAULT 0;

    WHILE counter < p_limit DO
        SELECT u.user_id, u.username
        FROM Users u
        WHERE u.user_id != p_user_id
          AND u.user_id NOT IN (
              SELECT friend_id FROM Friends WHERE user_id = p_user_id
          )
        LIMIT p_limit;
        SET counter = p_limit;
    END WHILE;
END//
DELIMITER ;

CREATE INDEX idx_likes_post ON Likes(post_id);

CREATE VIEW vw_top_posts AS
SELECT p.post_id, p.content, COUNT(l.user_id) AS total_likes
FROM Posts p
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id
ORDER BY total_likes DESC
LIMIT 5;


DELIMITER //
CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User không tồn tại';
    ELSEIF NOT EXISTS (SELECT 1 FROM Posts WHERE post_id = p_post_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Post không tồn tại';
    ELSE
        INSERT INTO Comments(user_id, post_id, content)
        VALUES (p_user_id, p_post_id, p_content);
    END IF;
END//
DELIMITER ;

CREATE VIEW vw_post_comments AS
SELECT c.content, u.username, c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.user_id;


DELIMITER //
CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Likes
        WHERE user_id = p_user_id AND post_id = p_post_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bạn đã like bài viết này rồi';
    ELSE
        INSERT INTO Likes(user_id, post_id)
        VALUES (p_user_id, p_post_id);
    END IF;
END//
DELIMITER ;

CREATE VIEW vw_post_likes AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id;


DELIMITER //
CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        SELECT * FROM Users
        WHERE username LIKE CONCAT('%', p_keyword, '%');
    ELSEIF p_option = 2 THEN
        SELECT * FROM Posts
        WHERE content LIKE CONCAT('%', p_keyword, '%');
    ELSE
        SELECT 'Giá trị p_option không hợp lệ' AS message;
    END IF;
END//
DELIMITER ;

CALL sp_search_social(1, 'an');
CALL sp_search_social(2, 'database');