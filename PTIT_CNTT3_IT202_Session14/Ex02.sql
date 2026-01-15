USE Session14;

CREATE TABLE Likes(
	like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
	UNIQUE(post_id, user_id)
);

ALTER TABLE Posts
	ADD COLUMN likes_count INT DEFAULT(0);
    
START TRANSACTION;
	INSERT INTO Likes (post_id, user_id)
		VALUES	(1,1);
	
    UPDATE Posts
		SET like_count = likes_count + 1
        WHERE post_id = 1;
	
    COMMIT;


START TRANSACTION;
	INSERT INTO Likes (post_id, user_id)
		VALUES	(1,1);
	
    UPDATE Posts
		SET like_count = likes_count + 1
        WHERE post_id = 1;
	
    ROLLBACK;

SELECT * FROM likes;
SELECT post_id, likes_count FROM posts;

