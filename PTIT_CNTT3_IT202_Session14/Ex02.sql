USE social_network;

CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT unique_like UNIQUE (post_id, user_id)
);

ALTER TABLE posts
	ADD COLUMN likes_count INT DEFAULT 0;

START TRANSACTION;
	INSERT INTO likes (post_id, user_id)
		VALUES (1, 2);

	UPDATE posts
		SET likes_count = likes_count + 1
		WHERE post_id = 1;
COMMIT;

SELECT * FROM likes;
SELECT * FROM posts;

START TRANSACTION;
	INSERT INTO likes (post_id, user_id)
		VALUES (1, 2);

	UPDATE posts
		SET likes_count = likes_count + 1
		WHERE post_id = 1;
ROLLBACK;

