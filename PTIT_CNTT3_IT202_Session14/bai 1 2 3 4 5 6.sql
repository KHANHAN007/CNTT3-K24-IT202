
drop database if exists social_network;
create database social_network;
use social_network;

create table users(
    user_id int primary key auto_increment,
    username varchar(50) not null,
    post_count int default 0
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);


insert into users (username, post_count) values ('nguyenvana', 0);
start transaction;
    insert into posts (user_id, content) values (1, 'hom nay hoc sql');
    update users set post_count = post_count + 1 where user_id = 1;
commit;

select * from users;
select * from posts;

start transaction;
    insert into posts (user_id, content) values (999, 'bai viet nay bi loi');
    update users set post_count = post_count + 1 where user_id = 999;
rollback;


alter table posts add column likes_count int default 0;

create table if not exists likes (
    like_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id),
    unique key unique_like (post_id, user_id)
);

start transaction;
    insert into likes (post_id, user_id) values (1, 1);
    update posts set likes_count = likes_count + 1 where post_id = 1;
commit;

select * from likes;
select * from posts;

start transaction;
    insert into likes (post_id, user_id) values (1, 1);
    update posts set likes_count = likes_count + 1 where post_id = 1;
rollback;



alter table users add column following_count int default 0;
alter table users add column followers_count int default 0;

create table if not exists followers (
    follower_id int not null,
    followed_id int not null,
    created_at datetime default current_timestamp,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id),
    foreign key (followed_id) references users(user_id)
);

create table if not exists follow_log (
    log_id int primary key auto_increment,
    log_message varchar(255),
    created_at datetime default current_timestamp
);

insert into users (username) values ('nguoi_theo_doi');   
insert into users (username) values ('nguoi_noi_tieng');  

delimiter //

create procedure sp_follow_user(
    in p_follower_id int, 
    in p_followed_id int 
)
begin
    
    if p_follower_id = p_followed_id then
        insert into follow_log(log_message) values ('loi: khong the tu follow chinh minh');
        select 'that bai: tu follow chinh minh' as status;
        leave proc_label;
    end if;

    if (select count(1) from users where user_id in (p_follower_id, p_followed_id)) < 2 then
        insert into follow_log(log_message) values ('loi: user khong ton tai');
        select 'that bai: user khong ton tai' as status;
        leave proc_label;
    end if;

    if exists (select 1 from followers where follower_id = p_follower_id and followed_id = p_followed_id) then
        insert into follow_log(log_message) values ('loi: da follow truoc do roi');
        select 'that bai: da follow roi' as status;
        leave proc_label;
    end if;

    start transaction;
        
        insert into followers (follower_id, followed_id) values (p_follower_id, p_followed_id);
        
        update users set following_count = following_count + 1 where user_id = p_follower_id;
        update users set followers_count = followers_count + 1 where user_id = p_followed_id;
        
    commit;
    select 'thanh cong: da follow user' as status;

end //

delimiter ;


call sp_follow_user(2, 3);

call sp_follow_user(2, 3);

call sp_follow_user(2, 999);

select * from followers;
select * from follow_log;
select * from users;

-- bai 4 
alter table posts add column comments_count int default 0;

create table if not exists comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

delimiter //

create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text,
    in p_simulate_fail boolean 
)
begin
    start transaction;

    insert into comments (post_id, user_id, content) values (p_post_id, p_user_id, p_content);

    savepoint after_insert;

    if p_simulate_fail = true then
       
        rollback to savepoint after_insert;
        
        commit;
        select 'cảnh báo: insert thành công nhưng update thất bại (đã rollback về savepoint)' as status;
    else
        update posts set comments_count = comments_count + 1 where post_id = p_post_id;
        
        
        commit;
        select 'thành công: đã comment và update số lượng' as status;
    end if;

end //

delimiter ;

call sp_post_comment(1, 1, 'bai viet hay qua', false);


select * from comments;
select * from posts where post_id = 1;


call sp_post_comment(1, 1, 'comment nay se khong duoc dem', true);

select * from comments;
select * from posts where post_id = 1;

-- bai 5 

create table if not exists delete_log (
    log_id int primary key auto_increment,
    post_id int not null,      
    deleted_by int not null,   
    deleted_at datetime default current_timestamp
);


drop procedure if exists sp_delete_post;

delimiter //

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    
    declare exit handler for sqlexception
    begin
        rollback;
        select 'loi he thong: da rollback toan bo' as status;
    end;

    start transaction;

    if not exists (select 1 from posts where post_id = p_post_id and user_id = p_user_id) then
        rollback;
        select 'that bai: bai viet khong ton tai hoac sai chu so huu' as status;
        leave proc_label;
    end if;

    delete from likes where post_id = p_post_id;

    delete from comments where post_id = p_post_id;

    delete from posts where post_id = p_post_id;

    update users set post_count = post_count - 1 where user_id = p_user_id;

    insert into delete_log(post_id, deleted_by) values (p_post_id, p_user_id);
    commit;
    select 'thanh cong: da xoa bai viet va du lieu lien quan' as status;

end //

delimiter ;

insert into posts (user_id, content) values (1, 'bai viet sap bi xoa');

set @id_bai_moi = last_insert_id();

insert into comments (post_id, user_id, content) values (@id_bai_moi, 1, 'comment test');
insert into likes (post_id, user_id) values (@id_bai_moi, 1);

select * from posts where post_id = @id_bai_moi;


call sp_delete_post(@id_bai_moi, 2);

select * from posts where post_id = @id_bai_moi;

call sp_delete_post(@id_bai_moi, 1);

select * from posts where post_id = @id_bai_moi;
select * from comments where post_id = @id_bai_moi;
select * from delete_log order by log_id desc limit 1;

-- bai 6 
create table if not exists friend_requests (
    request_id int primary key auto_increment,
    from_user_id int not null,
    to_user_id int not null,
    status enum('pending','accepted','rejected') default 'pending',
    created_at datetime default current_timestamp,
    foreign key (from_user_id) references users(user_id),
    foreign key (to_user_id) references users(user_id)
);

create table if not exists friends (
    user_id int not null,
    friend_id int not null,
    created_at datetime default current_timestamp,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);


alter table users add column friends_count int default 0;


drop procedure if exists sp_accept_friend_request;

delimiter //

create procedure sp_accept_friend_request(
    in p_request_id int,
    in p_to_user_id int -- id của người bấm chấp nhận
)
 begin
    declare v_from_user_id int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        select 'loi he thong: da rollback' as status;
    end;

    set transaction isolation level repeatable read;

    start transaction;

    select from_user_id into v_from_user_id
    from friend_requests
    where request_id = p_request_id 
      and to_user_id = p_to_user_id 
      and status = 'pending'
    for update;

    if v_from_user_id is null then
        rollback;
        select 'that bai: yeu cau khong ton tai hoac da duoc xu ly' as status;
        leave proc_label;
    end if;

    insert into friends (user_id, friend_id) values (v_from_user_id, p_to_user_id);
    insert into friends (user_id, friend_id) values (p_to_user_id, v_from_user_id);

    update users set friends_count = friends_count + 1 where user_id = v_from_user_id;
    update users set friends_count = friends_count + 1 where user_id = p_to_user_id;

    update friend_requests set status = 'accepted' where request_id = p_request_id;

    commit;
    select 'thanh cong: da tro thanh ban be' as status;

end //

delimiter ;




insert into users (username) select 'user_a' where not exists (select * from users where user_id = 1);
insert into users (username) select 'user_b' where not exists (select * from users where user_id = 2);

insert into friend_requests (from_user_id, to_user_id, status) values (1, 2, 'pending');
set @req_id = last_insert_id();

select * from friend_requests where request_id = @req_id;
select * from users where user_id in (1, 2);


call sp_accept_friend_request(@req_id, 999);

call sp_accept_friend_request(@req_id, 2);

select * from friends;
select * from users where user_id in (1, 2);
select * from friend_requests where request_id = @req_id;

call sp_accept_friend_request(@req_id, 2);