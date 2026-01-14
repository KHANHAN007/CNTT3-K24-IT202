DROP DATABASE IF EXISTS db_session13; -- Xóa db cũ nếu có để làm lại từ đầu
create database db_session13;
use db_session13;

create table users(
	user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(255) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0

);

create table posts (
	post_id int primary key auto_increment,
    user_id int, 
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table likes (
	like_id int primary key auto_increment,
    user_id int,
    post_id int,
    liked_at datetime,
    foreign key(user_id) references users(user_id)  on delete cascade,
    foreign key(post_id) references posts(post_id) on delete cascade
);

CREATE TABLE post_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    -- Ràng buộc: Xóa bài gốc thì xóa luôn lịch sử
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    created_at datetime default current_timestamp,
    primary key (follower_id, followee_id), -- khóa chính tổ hợp để tránh trùng lặp
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

-- bài 1 
            
DELIMITER //
 CREATE trigger update_post_count__insert 
 after insert on posts 
 for each row 
 begin 
	update users
    set post_count = post_count +1
    where user_id = new.user_id;
end //
DELIMITER ;

DELIMITER //
create trigger update_post_count_delete
after delete on posts 
for each row 
begin 
	 update users 
     set post_count = post_count -1 
     where user_id = old.user_id;
	end //
DELIMITER ;

insert into users( username, email, created_at) values
			('alicu', 'alicu@gmail.com', '2024-12-07'),
			('bob', 'bob@gmail.com', '2024-09-10'),
			('charlie lam', 'lam@gmail.com', '2024-09-07');

INSERT INTO posts (user_id, content, created_at) VALUES

(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),

(1, 'Second post by Alice', '2025-01-10 12:00:00'),

(2, 'Bob first post', '2025-01-11 09:00:00'),

(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

SELECT * FROM users;

delete from posts 
where post_id = 2;

SELECT * FROM posts;


-- bài 2 
INSERT INTO likes (user_id, post_id, liked_at) VALUES

(2, 1, '2025-01-10 11:00:00'),

(3, 1, '2025-01-10 13:00:00'),

(1, 3, '2025-01-11 10:00:00'),

(3, 4, '2025-01-12 16:00:00');

DELIMITER //
create trigger like_count_insert
after insert on likes
for each row
begin 
	update posts 
    set like_count = like_count +1
    where post_id = new.post_id;
end //
DELIMITER ;

DELIMITER //
create trigger like_count_delete
after delete on likes
for each row
begin 
	update  posts 
    set like_count = like_count - 1
    where post_id= old.post_id;
end //
DELIMITER ;

create view user_statistics as
select u.user_id, u.username, u.post_count,
		coalesce(sum(p.like_count), 0) AS total_likes
from users u 
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.post_count;

INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 4, NOW());

SELECT * FROM posts WHERE post_id = 4;

SELECT * FROM user_statistics;

delete from likes where user_id =2 and post_id =4;

select * from user_statistics;

-- bài 3 
DELIMITER //
create trigger check_self_like_insert
before insert on likes
for each row
begin
    declare post_owner_id int;
    
    select user_id into post_owner_id 
    from posts 
    where post_id = new.post_id;
    
    if post_owner_id = new.user_id then
        signal sqlstate '45000' 
        set message_text = 'lỗi: bạn không thể tự like bài viết của chính mình';
    end if;
end //

create trigger update_like_count_insert
after insert on likes
for each row
begin
    update posts 
    set like_count = like_count + 1
    where post_id = new.post_id;
end //

create trigger update_like_count_delete
after delete on likes
for each row
begin
    update posts 
    set like_count = like_count - 1
    where post_id = old.post_id;
end //

create trigger update_like_count_update
after update on likes
for each row
begin
    if old.post_id <> new.post_id then
        update posts 
        set like_count = like_count - 1
        where post_id = old.post_id;
        
        update posts 
        set like_count = like_count + 1
        where post_id = new.post_id;
    end if;
end //

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
update posts set like_count = 0;
delete from likes;


insert into likes (user_id, post_id, liked_at) values (2, 1, now());

select * from posts where post_id = 1;

update likes set post_id = 4 where user_id = 2 and post_id = 1;

select * from posts;

delete from likes where user_id = 2 and post_id = 4;

select * from posts where post_id = 4;

select * from user_statistics;


-- bài 4
DELIMITER //

CREATE TRIGGER log_post_update
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (
            post_id, 
            old_content, 
            new_content, 
            changed_at, 
            changed_by_user_id
        )
        VALUES (
            OLD.post_id, 
            OLD.content, 
            NEW.content, 
            NOW(), 
            OLD.user_id 
        );
    END IF;
END //

DELIMITER ;


SELECT * FROM posts;

UPDATE posts 
SET content = 'Hello world from Alice (Updated v1)' 
WHERE post_id = 1;

UPDATE posts 
SET content = 'Bob post has been changed' 
WHERE post_id = 3;

SELECT * FROM post_history;

SELECT * FROM posts;

INSERT INTO likes (user_id, post_id, liked_at) VALUES (3, 1, NOW());

SELECT * FROM posts WHERE post_id = 1;

-- bai 5 

DELIMITER //
create trigger check_user_data_before_insert
before insert on users
for each row
begin
    if new.email not like '%@%' then
        signal sqlstate '45000'
        set message_text = 'lỗi: email thiếu @';
    end if;

    if new.username regexp '[^a-zA-Z0-9_]' then
        signal sqlstate '45000'
        set message_text = 'lỗi: username chứa ký tự đặc biệt';
    end if;
end //
delimiter ;

drop procedure if exists add_user;

delimiter //
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end //
DELIMITER ;

call add_user('david_01', 'david@mail.com', curdate());

 call add_user('david-02', 'davidmail.com', curdate());


-- bai 6 
SET SQL_SAFE_UPDATES = 0;
DELIMITER //

create trigger update_follower_count_insert
after insert on friendships
for each row
begin
    update users 
    set follower_count = follower_count + 1
    where user_id = new.followee_id;
end //

create trigger update_follower_count_delete
after delete on friendships
for each row
begin
    update users 
    set follower_count = follower_count - 1
    where user_id = old.followee_id;
end //

DELIMITER ;

drop procedure if exists follow_user;

DELIMITER //
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int
)
begin
    if p_follower_id = p_followee_id then
        signal sqlstate '45000' set message_text = 'lỗi: không thể tự follow mình';
    end if;

    if not exists (select 1 from friendships where follower_id = p_follower_id and followee_id = p_followee_id) then
        insert into friendships (follower_id, followee_id) values (p_follower_id, p_followee_id);
    else
        signal sqlstate '45000' set message_text = 'lỗi: đã follow rồi';
    end if;
end //
DELIMITER ;

drop view if exists user_profile;

create view user_profile as
select 
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    group_concat(p.content separator '; ') as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

update users set follower_count = 0;
delete from friendships;

call follow_user(1, 2);

call follow_user(3, 2);

select * from users;

select * from user_profile;

delete from friendships where follower_id = 1 and followee_id = 2;

select * from users;