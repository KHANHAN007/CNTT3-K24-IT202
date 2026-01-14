create database if not exists it202_session13;
use it202_session13;

create table users(
	user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at datetime,
    follower_count int default 0,
    post_count int default 0
);

create table posts(
	post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at date,
    like_count int default 0,
    
    foreign key (user_id) references users(user_id) on delete cascade
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter $$
create trigger after_insert_post after insert on posts for each row
begin
	update users
    set post_count=post_count+1
    where user_id=new.user_id;
end $$

create trigger after_delete_post after delete on posts for each row
begin
	update users
    set post_count=post_count-1
    where user_id=old.user_id;
end $$

delimiter ;

SELECT * FROM users;
INSERT INTO posts (user_id, content, created_at) VALUES

(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),

(1, 'Second post by Alice', '2025-01-10 12:00:00'),

(2, 'Bob first post', '2025-01-11 09:00:00'),

(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

delete from posts where post_id=2;
-- Bài 02:

create table likes (
    like_id int auto_increment primary key,
    user_id int not null,
    post_id int not null,
    liked_at datetime default now(),
    foreign key (user_id) references users(user_id) on delete cascade,
	foreign key (post_id) references posts(post_id) on delete cascade
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

delimiter $$
create trigger after_insert_likes after insert on likes for each row
begin
	update posts
    set like_count=like_count+1
    where post_id=new.post_id;
end $$

create trigger after_delete_likes after delete on likes for each row
begin
	update posts
    set like_count=like_count-1
    where post_id=old.post_id;
end $$

delimiter ;

create or replace view user_statistics as
select u.user_id, u.username, post_count, count(like_id) as total_likes
		from users u join posts p on u.user_id=p.user_id
					join likes l on l.user_id=u.user_id
group by u.user_id;

select * from user_statistics;

INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 4, NOW());

SELECT * FROM posts WHERE post_id = 4;

SELECT * FROM user_statistics;

delete from likes where user_id=2 and post_id=4;

-- Bài 03:
insert into users (username, email, created_at)
values ('david', 'david@example.com', '2025-01-04');

insert into posts (user_id, content, created_at)
values (4, 'post cua david', now());

delimiter $$

create trigger before_insert_likes
before insert on likes
for each row
begin
    declare post_owner int;

    select user_id
    into post_owner
    from posts
    where post_id = new.post_id;

    if post_owner = new.user_id then
        signal sqlstate '45000'
        set message_text = 'khong the like bai viet cua chinh minh';
    end if;
end $$

delimiter ;

delimiter $$

create trigger after_update_likes
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
end $$

delimiter ;

insert into likes (user_id, post_id)
values (1, 1);

insert into likes (user_id, post_id)
values (2, 1);

select post_id, like_count from posts where post_id = 1;

update likes
set post_id = 3
where user_id = 2 and post_id = 1;

select post_id, like_count
from posts
where post_id in (1, 3);

delete from likes
where user_id = 2 and post_id = 3;

select post_id, like_count from posts where post_id = 3;

select post_id, user_id, content, like_count
from posts;

select * from user_statistics;

-- Bài 04:
create table post_history (
    history_id int auto_increment primary key,
    post_id int not null,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id)
        references posts(post_id)
        on delete cascade
);

delimiter $$

create trigger before_update_posts_log
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        values ( old.post_id, old.content, new.content, now(), old.user_id );
    end if;
end $$

delimiter ;

update posts
set content = 'noi dung sau khi chinh sua lan 1'
where post_id = 1;

update posts
set content = 'noi dung sau khi chinh sua lan 2'
where post_id = 1;

select *
from post_history
where post_id = 1
order by changed_at;

insert into likes (user_id, post_id)
values (2, 1);

select post_id, like_count
from posts
where post_id = 1;
-- Bài 05:
delimiter $$

create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end $$

delimiter ;

delimiter $$

create trigger before_insert_users_validate
before insert on users
for each row
begin
    if new.email not like '%@%' or new.email not like '%.%' then
        signal sqlstate '45000'
        set message_text = 'email khong hop le';
    end if;

    if new.username not regexp '^[a-za-z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'username chi duoc chua chu cai, so va underscore';
    end if;
end $$

delimiter ;

call add_user('valid_user_01', 'valid_user01@example.com', '2025-01-20');

call add_user('invalidemail', 'invalidemail_example.com', '2025-01-20');

call add_user('user!@#', 'user@example.com', '2025-01-20');

select * from users;
-- Bài 06:
create table friendships (
    follower_id int not null,
    followee_id int not null,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

delimiter $$

create trigger after_insert_friendships
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end $$

delimiter ;

delimiter $$

create trigger after_delete_friendships
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end $$

delimiter ;

delimiter $$

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending', 'accepted')
)
begin
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'khong the tu follow chinh minh';
    end if;

    if exists (
        select 1
        from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'da ton tai quan he follow';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end $$

delimiter ;

create or replace view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    count(l.like_id) as total_likes
from users u
left join posts p on u.user_id = p.user_id
left join likes l on l.post_id = p.post_id
group by u.user_id, u.username, u.follower_count, u.post_count;

select p.post_id, p.content, p.created_at
from posts p
where p.user_id = 1
order by p.created_at desc
limit 5;

call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');

call follow_user(4, 1, 'pending');

delete from friendships
where follower_id = 2 and followee_id = 1;

select * from user_profile where user_id = 1;




