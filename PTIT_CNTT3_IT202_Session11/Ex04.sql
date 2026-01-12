DELIMITER //
CREATE PROCEDURE create_post_with_validation( 	p_user_id INT,
												p_content TEXT,
                                                OUT result_message VARCHAR(255)
												)
	BEGIN
		IF CHAR_LENGTH(p_content) < 5 THEN
			SET result_message = 'Nội dung quá ngắn';
		ELSE
			INSERT INTO posts(user_id, content, created_at)
            VALUES (p_user_id, p_content, NOW());
            
            SET result_message = 'Thêm bài viết thành công';
		END IF;
	END //
DELIMITER ;

CALL create_post_with_validation(1, 'Hi', @msg);
SELECT @msg;

CALL create_post_with_validation(1, 'Hôm nay tôi học Stored Procedure', @msg);
SELECT @msg;


DROP PROCEDURE IF EXISTS create_post_with_validation;
