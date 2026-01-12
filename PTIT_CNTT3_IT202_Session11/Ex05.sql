DELIMITER //
CREATE PROCEDURE CalculateUserActivityScore(
    IN p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE total_posts INT DEFAULT 0;
    DECLARE total_comments INT DEFAULT 0;
    DECLARE total_likes INT DEFAULT 0;

    SELECT COUNT(*) INTO total_posts
    FROM posts
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO total_comments
    FROM comments
    WHERE user_id = p_user_id;

    SELECT COUNT(*) INTO total_likes
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    SET activity_score = total_posts * 10
                        + total_comments * 5
                        + total_likes * 3;

    IF activity_score > 500 THEN
        SET activity_level = 'Rất tích cực';
    ELSEIF activity_score BETWEEN 200 AND 500 THEN
        SET activity_level = 'Tích cực';
    ELSE
        SET activity_level = 'Bình thường';
    END IF;

END //
DELIMITER ;
CALL CalculateUserActivityScore(1, @score, @level);

SELECT @score AS activity_score,
       @level AS activity_level;
       
DROP PROCEDURE IF EXISTS CalculateUserActivityScore;
