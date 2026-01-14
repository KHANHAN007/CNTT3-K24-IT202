CREATE DATABASE Session13;
USE Session13;

-- Bai 1 :
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

DELIMITER $$

CREATE TRIGGER after_insert_posts
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET post_count = post_count + 1
    WHERE user_id = NEW.user_id;
END$$

CREATE TRIGGER after_delete_posts
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET post_count = post_count - 1
    WHERE user_id = OLD.user_id;
END$$

DELIMITER ;

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

DELETE FROM posts WHERE post_id = 2;

-- ======================================
-- BAI 2: TRIGGER + VIEW (LIKES)
-- ======================================

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

DELIMITER $$

CREATE TRIGGER after_insert_likes
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

CREATE TRIGGER after_delete_likes
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

DELIMITER ;

CREATE VIEW user_statistics AS
SELECT 
    u.user_id,
    u.username,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());

SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

DELETE FROM likes
WHERE user_id = 2 AND post_id = 4;

SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- BAI 2: 
CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

DELIMITER $$

CREATE TRIGGER after_insert_likes
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

CREATE TRIGGER after_delete_likes
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

DELIMITER ;

CREATE VIEW user_statistics AS
SELECT 
    u.user_id,
    u.username,
    u.post_count,
    IFNULL(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());

SELECT 
    post_id,
    content,
    like_count
FROM posts
WHERE post_id = 4;

SELECT
    user_id,
    username,
    post_count,
    total_likes
FROM user_statistics;

DELETE FROM likes
WHERE user_id = 2
  AND post_id = 4;

SELECT 
    post_id,
    content,
    like_count
FROM posts
WHERE post_id = 4;

SELECT
    user_id,
    username,
    post_count,
    total_likes
FROM user_statistics;

-- Bai 3 : 
DELIMITER $$

CREATE TRIGGER before_insert_likes
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    SELECT user_id
    INTO post_owner
    FROM posts
    WHERE post_id = NEW.post_id;

    IF NEW.user_id = post_owner THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong duoc phep like bai viet cua chinh minh';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_insert_likes_v2
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_delete_likes_v2
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_update_likes
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    IF OLD.post_id <> NEW.post_id THEN
        UPDATE posts
        SET like_count = like_count - 1
        WHERE post_id = OLD.post_id;

        UPDATE posts
        SET like_count = like_count + 1
        WHERE post_id = NEW.post_id;
    END IF;
END$$

DELIMITER ;

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (1, 1, NOW());

INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 1, NOW());

SELECT
    post_id,
    content,
    like_count
FROM posts
WHERE post_id = 1;


UPDATE likes
SET post_id = 3
WHERE user_id = 2 AND post_id = 1;

SELECT
    post_id,
    content,
    like_count
FROM posts
WHERE post_id IN (1, 3);

DELETE FROM likes
WHERE user_id = 2 AND post_id = 3;

SELECT
    post_id,
    content,
    like_count
FROM posts
WHERE post_id = 3;

SELECT
    user_id,
    username,
    post_count,
    total_likes
FROM user_statistics;

-- Bai 4 : 
CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER before_update_posts
BEFORE UPDATE ON posts
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
END$$

DELIMITER ;

UPDATE posts
SET content = 'Hello world from Alice (edited)'
WHERE post_id = 1;

UPDATE posts
SET content = 'Bob first post (updated version)'
WHERE post_id = 3;

SELECT
    history_id,
    post_id,
    old_content,
    new_content,
    changed_at,
    changed_by_user_id
FROM post_history;

SELECT
    post_id,
    content,
    like_count
FROM posts
WHERE post_id IN (1, 3);

-- Bai 5 : 
DELIMITER $$

CREATE PROCEDURE add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_created_at DATE
)
BEGIN
    INSERT INTO users (username, email, created_at)
    VALUES (p_username, p_email, p_created_at);
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email khong hop le';
    END IF;

    IF NEW.username NOT REGEXP '^[A-Za-z0-9_]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username chi duoc chua chu cai, so va dau gach duoi';
    END IF;
END$$

DELIMITER ;

CALL add_user('valid_user', 'valid_user@example.com', '2025-02-01');

CALL add_user('invalid user', 'invalid@example.com', '2025-02-01');

CALL add_user('invalid_email', 'invalidemail.com', '2025-02-01');

SELECT * FROM users;

-- Bai 7 : 
CREATE TABLE friendships (
    follower_id INT,
    followee_id INT,
    status ENUM('pending', 'accepted') DEFAULT 'accepted',
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES users(user_id) ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER after_insert_friendship
AFTER INSERT ON friendships
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' THEN
        UPDATE users
        SET follower_count = follower_count + 1
        WHERE user_id = NEW.followee_id;
    END IF;
END$$

CREATE TRIGGER after_delete_friendship
AFTER DELETE ON friendships
FOR EACH ROW
BEGIN
    IF OLD.status = 'accepted' THEN
        UPDATE users
        SET follower_count = follower_count - 1
        WHERE user_id = OLD.followee_id;
    END IF;
END$$

CREATE PROCEDURE follow_user(
    IN p_follower_id INT,
    IN p_followee_id INT,
    IN p_status ENUM('pending', 'accepted')
)
BEGIN
    IF p_follower_id = p_followee_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the tu follow';
    END IF;

    IF EXISTS (
        SELECT 1 FROM friendships
        WHERE follower_id = p_follower_id
          AND followee_id = p_followee_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Da ton tai follow';
    END IF;

    INSERT INTO friendships (follower_id, followee_id, status)
    VALUES (p_follower_id, p_followee_id, p_status);
END$$

CREATE PROCEDURE unfollow_user(
    IN p_follower_id INT,
    IN p_followee_id INT
)
BEGIN
    DELETE FROM friendships
    WHERE follower_id = p_follower_id
      AND followee_id = p_followee_id;
END$$

DELIMITER ;

CREATE VIEW user_profile AS
SELECT
    u.user_id,
    u.username,
    u.follower_count,
    COUNT(DISTINCT p.post_id) AS post_count,
    COALESCE(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.follower_count;

CALL follow_user(1, 2, 'accepted');
CALL follow_user(3, 2, 'accepted');

CALL unfollow_user(1, 2);

SELECT * FROM friendships;
SELECT * FROM users;
SELECT * FROM user_profile;

