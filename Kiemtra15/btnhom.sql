DROP DATABASE IF EXISTS mini_social_network;
CREATE DATABASE mini_social_network;
USE mini_social_network;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);


CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending' , 'accepted')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id , friend_id),
    FOREIGN KEY (user_id)
        REFERENCES Users (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (friend_id)
        REFERENCES Users (user_id)
        ON DELETE CASCADE
);

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE like_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;

    INSERT INTO Users(username, password, email)
    VALUES (p_username, p_password, p_email);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_user_register
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES (NEW.user_id, 'User registered');
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NULL OR LENGTH(TRIM(p_content)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Content cannot be empty';
    END IF;

    INSERT INTO Posts(user_id, content)
    VALUES (p_user_id, p_content);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_post_insert
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES (NEW.post_id, 'Post created');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_like_insert
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;

    INSERT INTO like_log(user_id, post_id, action)
    VALUES (NEW.user_id, NEW.post_id, 'LIKE');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_like_delete
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;

    INSERT INTO like_log(user_id, post_id, action)
    VALUES (OLD.user_id, OLD.post_id, 'UNLIKE');
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot add yourself';
    END IF;

    IF EXISTS (
        SELECT 1 FROM Friends
        WHERE user_id = p_sender AND friend_id = p_receiver
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Friend request already exists';
    END IF;

    INSERT INTO Friends(user_id, friend_id)
    VALUES (p_sender, p_receiver);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_friend_accept
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'accepted' THEN
        INSERT IGNORE INTO Friends(user_id, friend_id, status)
        VALUES (NEW.friend_id, NEW.user_id, 'accepted');
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_remove_friend(
    IN p_user INT,
    IN p_friend INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM Friends
    WHERE (user_id = p_user AND friend_id = p_friend)
       OR (user_id = p_friend AND friend_id = p_user);

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM Posts
        WHERE post_id = p_post_id AND user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No permission';
    END IF;

    DELETE FROM Posts WHERE post_id = p_post_id;

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_delete_user(IN p_user_id INT)
BEGIN
    START TRANSACTION;

    DELETE FROM Users WHERE user_id = p_user_id;

    COMMIT;
END$$
DELIMITER ;

CALL sp_register_user('an', '123', 'an@gmail.com');
CALL sp_register_user('binh', '123', 'binh@gmail.com');

CALL sp_create_post(1, 'Hello world');
CALL sp_create_post(2, 'My first post');

INSERT INTO Likes VALUES (1, 2, NOW());
DELETE FROM Likes WHERE user_id = 1 AND post_id = 2;

CALL sp_send_friend_request(1, 2);
UPDATE Friends SET status = 'accepted' WHERE user_id = 1 AND friend_id = 2;

CALL sp_delete_post(1, 1);
CALL sp_delete_user(2);

