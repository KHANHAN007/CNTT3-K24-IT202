DELIMITER $$
CREATE PROCEDURE CalculatePostLikes(
    IN p_post_id INT,
    OUT total_likes INT
)
BEGIN
    SELECT 
        COUNT(l.user_id)
    INTO total_likes
    FROM likes l
    WHERE l.post_id = p_post_id;
END$$
DELIMITER ;

CALL CalculatePostLikes(5, @total_likes);
SELECT @total_likes AS total_likes;

DROP PROCEDURE IF EXISTS CalculatePostLikes;
