DELIMITER $$
CREATE PROCEDURE CalculateBonusPoints(
    IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE v_total_posts INT DEFAULT 0;

    -- Đếm số lượng bài viết của user
    SELECT COUNT(post_id)
    INTO v_total_posts
    FROM posts
    WHERE user_id = p_user_id;

    -- Cộng điểm theo điều kiện
    IF v_total_posts >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF v_total_posts >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    ELSE
        SET p_bonus_points = p_bonus_points;
    END IF;

END$$
DELIMITER ;
SET @bonus = 100;
CALL CalculateBonusPoints(3, @bonus);
SELECT @bonus AS final_bonus_points;
DROP PROCEDURE IF EXISTS CalculateBonusPoints;
