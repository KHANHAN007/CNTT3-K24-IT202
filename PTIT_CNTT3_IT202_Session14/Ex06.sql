USE social_network;

CREATE TABLE IF NOT EXISTS friend_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
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
CREATE PROCEDURE sp_accept_friend_request(
    IN p_request_id INT,
    IN p_to_user_id INT
)
BEGIN
    DECLARE v_from_user_id INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_cnt INT;

    START TRANSACTION;
		SELECT from_user_id, status
			INTO v_from_user_id, v_status
			FROM friend_requests
			WHERE request_id = p_request_id
			  AND to_user_id = p_to_user_id;

		IF v_from_user_id IS NULL OR v_status <> 'pending' THEN
			ROLLBACK;
		ELSE
			SELECT COUNT(*) INTO v_cnt
				FROM friends
				WHERE user_id = v_from_user_id
				  AND friend_id = p_to_user_id;

			IF v_cnt > 0 THEN
				ROLLBACK;
			ELSE
				INSERT INTO friends(user_id, friend_id)
					VALUES (v_from_user_id, p_to_user_id);

				INSERT INTO friends(user_id, friend_id)
					VALUES (p_to_user_id, v_from_user_id);

				UPDATE users
					SET friends_count = friends_count + 1
					WHERE user_id IN (v_from_user_id, p_to_user_id);

				UPDATE friend_requests
					SET status = 'accepted'
					WHERE request_id = p_request_id;
				COMMIT;
			END IF;
		END IF;
END //

DELIMITER ;

INSERT INTO friend_requests(from_user_id, to_user_id)
VALUES (1, 2);

CALL sp_accept_friend_request(1, 2);

CALL sp_accept_friend_request(1, 2);

SELECT * FROM friends;
SELECT user_id, friends_count FROM users;
SELECT * FROM friend_requests;
