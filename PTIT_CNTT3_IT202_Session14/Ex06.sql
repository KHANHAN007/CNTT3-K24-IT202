CREATE TABLE IF NOT EXISTS friend_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_user_id) REFERENCES users(user_id),
    FOREIGN KEY (to_user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (friend_id) REFERENCES users(user_id)
);

ALTER TABLE users
	ADD COLUMN friends_count INT DEFAULT 0;

DELIMITER //
CREATE PROCEDURE sp_accept_friend_request (
    IN p_request_id INT,
    IN p_to_user_id INT
)
BEGIN
    DECLARE v_from_user_id INT;
    DECLARE v_status ENUM('pending','accepted','rejected');
    DECLARE v_count INT DEFAULT 0;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    -- 1. Kiểm tra request tồn tại + khóa bản ghi
		SELECT from_user_id, status
			INTO v_from_user_id, v_status
			FROM friend_requests
			WHERE request_id = p_request_id
			  AND to_user_id = p_to_user_id;

		IF v_from_user_id IS NULL THEN
			ROLLBACK;
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Friend request does not exist or invalid user';
		END IF;

		-- 2. Kiểm tra trạng thái pending
		IF v_status <> 'pending' THEN
			ROLLBACK;
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Friend request is not pending';
		END IF;

		-- 3. Kiểm tra đã là bạn chưa
		SELECT COUNT(*) INTO v_count
			FROM friends
			WHERE user_id = p_to_user_id
			  AND friend_id = v_from_user_id;

		IF v_count > 0 THEN
			ROLLBACK;
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Users are already friends';
		END IF;

    -- 4. Thêm quan hệ bạn bè 2 chiều
		INSERT INTO friends (user_id, friend_id)
			VALUES (p_to_user_id, v_from_user_id);

		INSERT INTO friends (user_id, friend_id)
			VALUES (v_from_user_id, p_to_user_id);

		-- 5. Cập nhật số lượng bạn
		UPDATE users
			SET friends_count = friends_count + 1
			WHERE user_id IN (p_to_user_id, v_from_user_id);

		-- 6. Cập nhật trạng thái request
		UPDATE friend_requests
			SET status = 'accepted'
			WHERE request_id = p_request_id;

    COMMIT;
END//

DELIMITER ;

CALL sp_accept_friend_request(1, 2);
START TRANSACTION;
CALL sp_accept_friend_request(1, 2);


CALL sp_accept_friend_request(1, 2);

