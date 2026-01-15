CREATE TABLE Followers(
	follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY(follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id),
	FOREIGN KEY (followed_id) REFERENCES Users(user_id)
);

ALTER TABLE Users
	ADD COLUMN following_count INT DEFAULT 0,
    ADD COLUMN followers_count INT DEFAULT 0;
    
DELIMITER //
CREATE PROCEDURE sp_follow_user (
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;
    START TRANSACTION;

		-- 1. Không cho tự follow chính mình
		IF p_follower_id = p_followed_id THEN
			INSERT INTO follow_log (follower_id, followed_id, error_message)
			VALUES (p_follower_id, p_followed_id, 'Cannot follow yourself');
			ROLLBACK;
		END IF;

		-- 2. Kiểm tra follower tồn tại
		SELECT COUNT(user_id) INTO v_count
		FROM users WHERE user_id = p_follower_id;

		IF v_count = 0 THEN
			INSERT INTO follow_log (follower_id, followed_id, error_message)
			VALUES (p_follower_id, p_followed_id, 'Follower does not exist');
			ROLLBACK;
		END IF;

		-- 3. Kiểm tra followed tồn tại
		SELECT COUNT(user_id) INTO v_count
		FROM users WHERE user_id = p_followed_id;

		IF v_count = 0 THEN
			INSERT INTO follow_log (follower_id, followed_id, error_message)
			VALUES (p_follower_id, p_followed_id, 'Followed user does not exist');
			ROLLBACK;
		END IF;

		-- 4. Kiểm tra đã follow chưa
		SELECT COUNT(follower_id) INTO v_count
		FROM followers
		WHERE follower_id = p_follower_id
		  AND followed_id = p_followed_id;

		IF v_count > 0 THEN
			INSERT INTO follow_log (follower_id, followed_id, error_message)
			VALUES (p_follower_id, p_followed_id, 'Already followed');
			ROLLBACK;
		END IF;

		-- 5. Thực hiện follow
		INSERT INTO followers (follower_id, followed_id)
		VALUES (p_follower_id, p_followed_id);

		UPDATE users
		SET following_count = following_count + 1
		WHERE user_id = p_follower_id;

		UPDATE users
		SET followers_count = followers_count + 1
		WHERE user_id = p_followed_id;

		COMMIT;
END//
DELIMITER ;

CALL sp_follow_user(1, 2);

CALL sp_follow_user(1, 2);

CALL sp_follow_user(1, 1);

CALL sp_follow_user(1, 999);

SELECT * FROM followers;
SELECT user_id, following_count, followers_count FROM users;
