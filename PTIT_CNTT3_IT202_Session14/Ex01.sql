DROP DATABASE Session14;
CREATE DATABASE Session14;
USE Session14;

CREATE TABLE Users(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

CREATE TABLE Posts(
	post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT(CURRENT_TIMESTAMP)
);
INSERT INTO users (username) VALUES
	('alice'),
	('bob');

START TRANSACTION;
	INSERT INTO Posts(user_id, content)
		VALUES (1, 'Bài viết đầu tiên của Alice');
        
	UPDATE Users
		SET posts_count = posts_count + 1
        WHERE user_id = 1;
        
	COMMIT;
    
START TRANSACTION;
	INSERT INTO Posts(user_id, content)
		VALUES (999, 'Bai viet loi');
        
	UPDATE Users
		SET posts_count = posts_count + 1
        WHERE user_id = 999;
        
	ROLLBACK;
SELECT * FROM posts;
SELECT * FROM users;
