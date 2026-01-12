USE social_network_pro;

DELIMITER //
CREATE PROCEDURE calculate_post_likes(	IN p_post_id INT,
										OUT total_likes INT)
	BEGIN
		SELECT COUNT(*) INTO total_likes
        FROM Likes
        WHERE post_id = p_post_id;
	END //
DELIMITER ;

CALL calculate_post_likes(5, @total_likes);

SELECT @total_likes;
DROP PROCEDURE calculate_post_likes;
