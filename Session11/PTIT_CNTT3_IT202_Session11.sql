use social_network_pro;

-- Bài 01:
DELIMITER $$
CREATE PROCEDURE get_user_post (IN id INT)
BEGIN 
	SELECT post_id, content, created_at 
    FROM posts 
    WHERE user_id=id;
END $$
DELIMITER ;
CALL get_user_post(1);

DROP PROCEDURE IF EXISTS get_user_post; 

-- Bài 02:

DELIMITER $$
CREATE PROCEDURE CalculatePostLikes (IN p_post_id INT, OUT total_likes int)
BEGIN 
	SELECT count(*) into total_likes
    FROM likes 
    WHERE post_id=p_post_id;
END $$
DELIMITER ;
SET @total_likes= 0;
CALL CalculatePostLikes(101, @total_likes);
SELECT @total_likes AS TongLike;

DROP PROCEDURE IF EXISTS CalculatePostLikes; 

-- Bài 03:
DELIMITER $$

CREATE PROCEDURE CalculateBonusPoints(
    IN    p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE v_post_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_post_count
    FROM posts
    WHERE user_id = p_user_id;
	 SET p_bonus_points = p_bonus_points +
        CASE
            WHEN v_post_count >= 20 THEN 100
            WHEN v_post_count >= 10 THEN 50
            ELSE 0
        END;
END$$

DELIMITER ;

SET @bonus_points = 100;
CALL CalculateBonusPoints(1, @bonus_points);
SELECT @bonus_points AS BonusPoints;
DROP PROCEDURE IF EXISTS CalculateBonusPoints;

-- Bài 04:
DELIMITER $$
CREATE PROCEDURE CreatePostWithValidation(IN p_user_id INT, IN p_content TEXT, OUT result_message VARCHAR(255))
BEGIN
	CASE WHEN LENGTH(p_content) < 5 THEN SET result_message='Nội dung quá ngắn' ;
    ELSE INSERT INTO posts(user_id, content) values (p_user_id, p_content) ;
    SET result_message= 'Thêm bài vết thành công';
    END CASE ;
END $$

DELIMITER ;

CALL CreatePostWithValidation(1, 'Hello! Chào mừng đến với khóa học về CSDL', @msg);
SELECT @msg;

CALL CreatePostWithValidation(1, 'Hi', @msg);
SELECT @msg;

DROP PROCEDURE IF EXISTS CreatePostWithValidation;


-- Bài 05:
delimiter $$

create procedure calculateuseractivityscore(
    in  p_user_id int,
    out activity_score int,
    out activity_level varchar(50)
)
begin
    declare v_post_count int default 0;
    declare v_comment_count int default 0;
    declare v_like_count int default 0;

    select count(*)
    into v_post_count
    from posts
    where user_id = p_user_id;

    select count(*)
    into v_comment_count
    from comments
    where user_id = p_user_id;

    select count(*)
    into v_like_count
    from likes l
    join posts p on l.post_id = p.post_id
    where p.user_id = p_user_id;

    set activity_score =
          v_post_count * 10
        + v_comment_count * 5
        + v_like_count * 3;

    set activity_level =
        case
            when activity_score > 500 then 'rất tích cực'
            when activity_score between 200 and 500 then 'tích cực'
            else 'bình thường'
        end;

end$$

delimiter ;

call calculateuseractivityscore(1, @score, @level);

select 
    @score as activity_score,
    @level as activity_level;

drop procedure if exists calculateuseractivityscore;

-- Bài 06:
delimiter $$

create procedure notifyfriendsonnewpost(
    in p_user_id int,
    in p_content text
)
begin
    declare v_post_id int;
    declare v_full_name varchar(100);
    declare v_friend_id int;
    declare done int default 0;

    declare friend_cursor cursor for
        select friend_id
        from friends
        where user_id = p_user_id
          and status = 'accepted'
        union
        select user_id
        from friends
        where friend_id = p_user_id
          and status = 'accepted';

    declare continue handler for not found set done = 1;

    select full_name
    into v_full_name
    from users
    where user_id = p_user_id;

    insert into posts(user_id, content, created_at)
    values (p_user_id, p_content, now());

    set v_post_id = last_insert_id();

    open friend_cursor;

    read_loop: loop
        fetch friend_cursor into v_friend_id;

        if done = 1 then
            leave read_loop;
        end if;

        if v_friend_id <> p_user_id then
            insert into notifications(
                user_id,
                type,
                content,
                is_read,
                created_at
            )
            values (
                v_friend_id,
                'new_post',
                concat(v_full_name, ' đã đăng một bài viết mới'),
                0,
                now()
            );
        end if;

    end loop;

    close friend_cursor;

    select v_post_id as new_post_id;

end$$

delimiter ;

call notifyfriendsonnewpost(1, 'hello erd mysql');

select n.notification_id,
       u.full_name,
       n.content,
       n.created_at
from notifications n
join users u on n.user_id = u.user_id
where n.type = 'new_post'
order by n.created_at desc;

drop procedure if exists notifyfriendsonnewpost;
