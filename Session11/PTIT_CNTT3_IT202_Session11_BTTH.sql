create database if not exists SocialLab;
use SocialLab;

create table posts(
post_id INT Primary Key Auto_Increment,
content TEXT,
author VARCHAR(200),
likes_count INT Default 0
);

DELIMITER $$ 

create procedure sp_createPost(in content text, in author varchar(200))
begin
	case when LENGTH(content) > 5 then INSERT INTO posts(content, author) values (content, author);
    END CASE ;
end $$

create procedure sp_searchPost(in keyword text)
begin
	select post_id, content, author, likes_count
    from posts
    where content like concat(concat('%', keyword),'%');
end $$

create procedure sp_increaseLike(in p_post_id int, inout p_likes_count int)
begin 
update posts
set likes_count =p_likes_count+1
where post_id=p_post_id;

select likes_count 
into p_likes_count
from posts where post_id=p_post_id;

end $$

create procedure sp_DeletePost(in p_post_id int)
begin
delete
from posts
where post_id = p_post_id;

end $$

DELIMITER ;

CALL sp_createPost('hello mysql world', 'Admin');
CALL sp_createPost('hello stored procedure', 'Admin');

CALL sp_searchPost('hello');

SET @likes = 0;

CALL sp_increaseLike(@post_id_1, @likes);

SELECT @likes AS LikesAfterIncrease;

select * from posts;

CALL sp_DeletePost(@post_id_2);

drop procedure if exists sp_createPost;
drop procedure if exists sp_searchPost;
drop procedure if exists sp_increaseLike;
drop procedure if exists sp_DeletePost;

