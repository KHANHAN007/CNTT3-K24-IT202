DELIMITER //
CREATE PROCEDURE add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_created_at DATE
)
	BEGIN
		INSERT INTO Users(username, email, created_at)
		VALUES (p_username, p_email, p_created_at);
	END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_before_insert_user
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email không hợp lệ';
    END IF;
    IF NEW.username NOT REGEXP '^[a-zA-Z0-9_]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username chứa ký tự không hợp lệ';
    END IF;
END//
DELIMITER ;

CALL add_user('valid_user_123', 'valid@example.com', '2025-01-15');
CALL add_user('user2', 'invalidemail', '2025-01-15');
CALL add_user('user2', 'invalidemail', '2025-01-15');
CALL add_user('user name', 'space@example.com', '2025-01-15');
SELECT user_id, username, email, created_at
FROM Users;
