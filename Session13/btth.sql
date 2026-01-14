CREATE DATABASE SocialNetworkDB;
USE SocialNetworkDB;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    total_posts INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE post_audits (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME
);

DELIMITER $$

CREATE TRIGGER tg_CheckPostContent
BEFORE INSERT ON posts
FOR EACH ROW
BEGIN
    IF TRIM(NEW.content) = '' OR NEW.content IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Noi dung bai viet khong duoc de trong';
    END IF;
END$$

CREATE TRIGGER tg_UpdatePostCountAfterInsert
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET total_posts = total_posts + 1
    WHERE user_id = NEW.user_id;
END$$

CREATE TRIGGER tg_LogPostChanges
AFTER UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_audits (post_id, old_content, new_content, changed_at)
        VALUES (OLD.post_id, OLD.content, NEW.content, NOW());
    END IF;
END$$

CREATE TRIGGER tg_UpdatePostCountAfterDelete
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET total_posts = total_posts - 1
    WHERE user_id = OLD.user_id;
END$$

DELIMITER ;

INSERT INTO users (username) VALUES ('alice');

INSERT INTO posts (user_id, content, created_at)
VALUES (1, 'Bai viet dau tien', NOW());

INSERT INTO posts (user_id, content, created_at)
VALUES (1, '   ', NOW());

UPDATE posts
SET content = 'Noi dung da chinh sua'
WHERE post_id = 1;

DELETE FROM posts
WHERE post_id = 1;

DROP TRIGGER tg_CheckPostContent;
DROP TRIGGER tg_UpdatePostCountAfterInsert;
DROP TRIGGER tg_LogPostChanges;
DROP TRIGGER tg_UpdatePostCountAfterDelete;
