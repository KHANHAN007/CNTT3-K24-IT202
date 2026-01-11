-- ==============================
-- DATABASE: Social Network Mini Project
-- TOPIC: VIEW & INDEX (MySQL)
-- ==============================

DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

-- ==============================
-- 1. TABLE: users
-- ==============================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==============================
-- 2. TABLE: posts
-- ==============================
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    privacy ENUM('PUBLIC', 'FRIEND', 'PRIVATE') DEFAULT 'PUBLIC',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==============================
-- 3. TABLE: comments
-- ==============================
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==============================
-- 4. TABLE: likes
-- ==============================
CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ==============================
-- INSERT SAMPLE DATA
-- ==============================

-- Users
INSERT INTO users (username, email, phone) VALUES
('alice', 'alice@gmail.com', '0901111111'),
('bob', 'bob@gmail.com', '0902222222'),
('charlie', 'charlie@gmail.com', '0903333333'),
('david', 'david@gmail.com', '0904444444');

-- Posts
INSERT INTO posts (user_id, content, privacy, created_at) VALUES
(1, 'Hello world from Alice', 'PUBLIC', '2024-01-10'),
(2, 'Bob private post', 'PRIVATE', '2024-02-01'),
(3, 'Charlie public sharing', 'PUBLIC', '2024-03-05'),
(1, 'Alice friend-only post', 'FRIEND', '2024-03-20'),
(4, 'David public post', 'PUBLIC', '2024-04-01');

-- Comments
INSERT INTO comments (post_id, user_id, content) VALUES
(1, 2, 'Nice post!'),
(1, 3, 'Welcome Alice'),
(3, 1, 'Good content'),
(5, 2, 'Great post David');

-- Likes
INSERT INTO likes (post_id, user_id) VALUES
(1, 2),
(1, 3),
(3, 1),
(3, 2),
(5, 1),
(5, 3);

-- ==============================
-- END OF FILE
-- ==============================

-- CÂU 1:
CREATE VIEW view_public_user_profile AS
SELECT
    username,
    email,
    created_at
FROM users;

SELECT * FROM view_public_user_profile;

-- CÂU 2:
CREATE VIEW view_public_news_feed AS
SELECT
    u.username,
    p.content,
    p.created_at,
    COUNT(l.like_id) AS total_likes
FROM posts p
JOIN users u
    ON p.user_id = u.user_id
LEFT JOIN likes l
    ON p.post_id = l.post_id
WHERE p.privacy = 'PUBLIC'
GROUP BY
    u.username,
    p.content,
    p.created_at;

SELECT * FROM view_public_news_feed;

-- CÂU 3: 
CREATE VIEW view_public_posts_check AS
SELECT
    post_id,
    user_id,
    content,
    privacy,
    created_at
FROM posts
WHERE privacy = 'PUBLIC'
WITH CHECK OPTION;

SELECT * FROM view_public_posts_check;

INSERT INTO view_public_posts_check (user_id, content, privacy, created_at)
VALUES (1, 'Public post inserted via view', 'PUBLIC', NOW());

UPDATE view_public_posts_check
SET privacy = 'PRIVATE'
WHERE post_id = 1;

-- CÂU 4: 
EXPLAIN
SELECT *
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;

-- CÂU 5: 
CREATE INDEX idx_posts_privacy_created_at
ON posts(privacy, created_at);

CREATE INDEX idx_posts_user_id
ON posts(user_id);

EXPLAIN
SELECT *
FROM posts
WHERE privacy = 'PUBLIC'
ORDER BY created_at DESC;

EXPLAIN
SELECT *
FROM posts
WHERE user_id = 1;


