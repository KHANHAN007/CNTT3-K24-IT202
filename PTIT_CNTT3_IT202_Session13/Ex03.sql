DELIMITER //

CREATE TRIGGER trg_before_insert_like
BEFORE INSERT ON Likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    SELECT user_id
		INTO post_owner
		FROM Posts
		WHERE post_id = NEW.post_id;

    IF post_owner = NEW.user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không được like bài đăng của chính mình';
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_before_update_like
BEFORE UPDATE ON Likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    IF NEW.post_id <> OLD.post_id THEN
        SELECT user_id
			INTO post_owner
			FROM Posts
			WHERE post_id = NEW.post_id;

        IF post_owner = NEW.user_id THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không được like bài đăng của chính mình';
        END IF;
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_after_update_like
AFTER UPDATE ON Likes
FOR EACH ROW
BEGIN
    IF NEW.post_id <> OLD.post_id THEN
        -- Giảm like bài cũ
        UPDATE Posts
			SET like_count = like_count - 1
			WHERE post_id = OLD.post_id;

        -- Tăng like bài mới
        UPDATE Posts
			SET like_count = like_count + 1
			WHERE post_id = NEW.post_id;
    END IF;
END//

DELIMITER ;

INSERT INTO Likes(user_id, post_id)
VALUES (1, 1);


INSERT INTO Likes(user_id, post_id)
VALUES (2, 1);

SELECT post_id, like_count FROM Posts WHERE post_id = 1;


UPDATE Likes
	SET post_id = 4
	WHERE user_id = 2 AND post_id = 1
	LIMIT 1;
SELECT post_id, like_count FROM Posts WHERE post_id IN (1,4);

DELETE FROM Likes
WHERE user_id = 2 AND post_id = 4
	ORDER BY like_id DESC
	LIMIT 1;
SELECT post_id, like_count FROM Posts WHERE post_id = 4;

SELECT * FROM vw_user_statistics;

