DELIMITER //
CREATE PROCEDURE calculate_bounus_points(	IN p_user_id INT,
											INOUT p_bonus_points INT)
	BEGIN
		DECLARE total_posts INT DEFAULT 0;
        SELECT COUNT(*) INTO total_posts
        FROM posts
        WHERE user_id = p_user_id;
        
        IF total_posts >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF total_posts >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    END IF;
    END //
DELIMITER ;

SET @bonus = 100;
CALL calculate_bounus_points(1, @bonus);

SELECT @bonus AS final_bonus_points;
DROP PROCEDURE IF EXISTS CalculateBonusPoints;


