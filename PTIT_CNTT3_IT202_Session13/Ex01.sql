DROP DATABASE Session13;
CREATE DATABASE Session13;
USE Session13;

CREATE TABLE Users(
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

CREATE TABLE Posts(
	post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0,
    
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO users (username, email, created_at) VALUES
	('alice', 'alice@example.com', '2025-01-01'),
	('bob', 'bob@example.com', '2025-01-02'),
	('charlie', 'charlie@example.com', '2025-01-03');
    
DELIMITER //
CREATE TRIGGER trg_after_insert_post
	AFTER INSERT ON posts
    FOR EACH ROW
    BEGIN
		UPDATE Users
        SET post_count = post_count + 1
        WHERE user_id = NEW.user_id;
	END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_after_delete_post
	AFTER DELETE ON Posts
    FOR EACH ROW
    BEGIN 
		UPDATE Users
			SET post_count = post_count-1
			WHERE user_id = OLD.user_id;
	END //
DELIMITER ;

INSERT INTO posts (user_id, content, created_at) VALUES
	(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
	(1, 'Second post by Alice', '2025-01-10 12:00:00'),
	(2, 'Bob first post', '2025-01-11 09:00:00'),
	(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

SELECT user_id, username, email, created_at, follower_count, post_count FROM Users;

DELETE FROM Posts WHERE post_id = 2;

