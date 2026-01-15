drop database if exists social_network;
create database if not exists social_network;
use social_network;

-- Bài 01:
create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null,
    posts_count int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

insert into users (username) values
('alice'),
('bob');

start transaction;

-- insert post moi (user_id ton tai)
insert into posts (user_id, content)
values (1, 'bai viet dau tien cua alice');

-- cap nhat posts_count
update users
set posts_count = posts_count + 1
where user_id = 1;

commit;

select * from posts;
select * from users;

start transaction;

-- loi khoa ngoai: user_id = 999 khong ton tai
insert into posts (user_id, content)
values (999, 'bai viet loi');

-- dong nay se khong bao gio duoc commit
update users
set posts_count = posts_count + 1
where user_id = 999;

rollback;

select * from posts;
select * from users;

-- Bài 02:
create table likes (
    like_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id),
    unique key unique_like (post_id, user_id)
);

alter table posts
add column likes_count int default 0;

select * from users;
select * from posts;

start transaction;

-- them like (lan dau)
insert into likes (post_id, user_id)
values (1, 1);

-- tang likes_count cho post
update posts
set likes_count = likes_count + 1
where post_id = 1;

commit;

start transaction;

-- vi pham unique (post_id, user_id)
insert into likes (post_id, user_id)
values (1, 1);

-- dong nay se khong duoc commit
update posts
set likes_count = likes_count + 1
where post_id = 1;

rollback;

select * from likes;
select post_id, likes_count from posts where post_id = 1;
-- Bài 03:
create table if not exists followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

alter table users
add column following_count int default 0,
add column followers_count int default 0;

delimiter $$

create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare v_exists int;

    start transaction;

    -- khong cho tu follow
    if p_follower_id = p_followed_id then
        insert into follow_log (follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'khong the tu follow chinh minh');
        rollback;
        leave proc_end;
    end if;

    -- kiem tra follower ton tai
    select count(*) into v_exists from users where user_id = p_follower_id;
    if v_exists = 0 then
        insert into follow_log (follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'follower khong ton tai');
        rollback;
        leave proc_end;
    end if;

    -- kiem tra followed ton tai
    select count(*) into v_exists from users where user_id = p_followed_id;
    if v_exists = 0 then
        insert into follow_log (follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'followed khong ton tai');
        rollback;
        leave proc_end;
    end if;

    -- kiem tra da follow truoc do chua
    select count(*) into v_exists
    from followers
    where follower_id = p_follower_id
      and followed_id = p_followed_id;

    if v_exists > 0 then
        insert into follow_log (follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'da follow truoc do');
        rollback;
        leave proc_end;
    end if;

    -- them follow
    insert into followers (follower_id, followed_id)
    values (p_follower_id, p_followed_id);

    -- cap nhat so dang follow
    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;

    -- cap nhat so nguoi theo doi
    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;

    commit;

    proc_end: begin end;
end $$

delimiter ;

call sp_follow_user(1, 2);

select user_id, following_count, followers_count from users where user_id in (1, 2);

call sp_follow_user(1, 1);

select * from follow_log;

call sp_follow_user(1, 999);

call sp_follow_user(1, 2);

select * from followers;
select user_id, following_count, followers_count from users;
select * from follow_log;
-- Bài 04:

create table if not exists comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

alter table posts
add column comments_count int default 0;

delimiter $$

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- insert comment
    insert into comments (post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);

    -- tao savepoint sau khi insert
    savepoint after_insert;

    -- cap nhat comments_count
    update posts
    set comments_count = comments_count + 1
    where post_id = p_post_id;

    -- neu update that bai (post khong ton tai)
    if row_count() = 0 then
        rollback to after_insert;
        commit;
    else
        commit;
    end if;

end $$

delimiter ;

call sp_post_comment(1, 1, 'day la binh luan thanh cong');

call sp_post_comment(999, 1, 'binh luan bi loi update');

select * from comments where post_id = 999;
select * from posts where post_id = 999;
-- Bài 05:
create table if not exists delete_log (
    log_id int auto_increment primary key,
    post_id int not null,
    deleted_at datetime default current_timestamp,
    deleted_by int not null
);
delimiter $$

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_owner_id int;

    -- bat loi
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    -- kiem tra bai viet ton tai va dung chu
    select user_id
    into v_owner_id
    from posts
    where post_id = p_post_id
    for update;

    -- neu khong ton tai hoac khong phai chu bai viet
    if v_owner_id is null or v_owner_id <> p_user_id then
        rollback;
        leave proc_end;
    end if;

    -- xoa likes
    delete from likes
    where post_id = p_post_id;

    -- xoa comments
    delete from comments
    where post_id = p_post_id;

    -- xoa post
    delete from posts
    where post_id = p_post_id;

    -- cap nhat posts_count
    update users
    set posts_count = posts_count - 1
    where user_id = p_user_id;

    -- ghi log xoa bai
    insert into delete_log(post_id, deleted_by)
    values (p_post_id, p_user_id);

    commit;

    proc_end: begin end;

end $$

delimiter ;

call sp_delete_post(1, 1);

select * from posts where post_id = 1;
select * from likes where post_id = 1;
select * from comments where post_id = 1;
select posts_count from users where user_id = 1;
select * from delete_log;

call sp_delete_post(2, 999);

select * from posts where post_id = 2;
select * from delete_log;
-- Bài 06:

create table if not exists friend_requests (
    request_id int auto_increment primary key,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending','accepted','rejected') default 'pending',

    foreign key (from_user_id) references users(user_id) on delete cascade,
    foreign key (to_user_id) references users(user_id) on delete cascade
);

create table if not exists friends (
    user_id int not null,
    friend_id int not null,
    primary key (user_id, friend_id),

    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (friend_id) references users(user_id) on delete cascade
);

alter table users
add column friends_count int default 0;

delimiter $$

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int
)
begin
    declare v_from_user_id int;
    declare v_status varchar(20);

    declare exit handler for sqlexception
    begin
        rollback;
    end;

    set transaction isolation level repeatable read;
    start transaction;

    -- khoa request de tranh xu ly dong thoi
    select from_user_id, status
    into v_from_user_id, v_status
    from friend_requests
    where request_id = p_request_id
      and to_user_id = p_to_user_id
    for update;

    -- kiem tra ton tai + pending
    if v_from_user_id is null or v_status <> 'pending' then
        rollback;
        leave proc_end;
    end if;

    -- kiem tra da la ban chua
    if exists (
        select 1 from friends
        where user_id = v_from_user_id
          and friend_id = p_to_user_id
    ) then
        rollback;
        leave proc_end;
    end if;

    -- them quan he ban be 2 chieu
    insert into friends(user_id, friend_id)
    values
        (v_from_user_id, p_to_user_id),
        (p_to_user_id, v_from_user_id);

    -- cap nhat so ban
    update users
    set friends_count = friends_count + 1
    where user_id in (v_from_user_id, p_to_user_id);

    -- cap nhat trang thai request
    update friend_requests
    set status = 'accepted'
    where request_id = p_request_id;

    commit;

    proc_end: begin end;

end $$

delimiter ;

insert into friend_requests(from_user_id, to_user_id)
values (1, 2);

call sp_accept_friend_request(1, 2);

select * from friends;
select friends_count from users where user_id in (1,2);
select * from friend_requests where request_id = 1;

call sp_accept_friend_request(1, 2);

