create database if not exists socialnetworkdb;
use socialnetworkdb;

create table users (
    user_id int auto_increment primary key,
    username varchar(100) not null,
    total_posts int default 0
);

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text,
    created_at datetime,
	foreign key (user_id) references users(user_id) on delete cascade
);

create table post_audits (
    audit_id int auto_increment primary key,
    post_id int not null,
    old_content text,
    new_content text,
    changed_at datetime,
	foreign key (post_id) references posts(post_id) on delete cascade
);

insert into users (username) values
('alice'),
('bob'),
('charlie'),
('david'),
('emma');

delimiter $$
create trigger tg_checkPostContent before insert on posts
for each row 
begin
	if length(trim(NEW.content))=0 then 
    signal sqlstate '45000'
    set message_text = 'Nội dung bài viết không được để trống!';
    end if;
end $$

delimiter ;

insert into posts(user_id, content, created_at)
values(1,'', current_date);

select * from posts;

delimiter $$
create trigger after_insert_post after insert on posts for each row
begin
	update users
    set total_posts=total_posts+1
    where user_id=new.user_id;
end $$

delimiter ;

insert into posts(user_id, content, created_at)
values(1,'Xin chào CSDL', current_date);

select * from users;

delimiter $$
create trigger tg_LogPostChanges after update on posts for each row
begin
	insert into post_audits(post_id,old_content, new_content, changed_at)
	values (new.post_id, old.content, new.content, current_date);
end $$

delimiter ;	

update posts
set content = 'Tạm biệt CSDL'
where post_id=1;

select * from post_audits;

delimiter $$
create trigger tg_UpdatePostCountAfterDelete after delete on posts for each row
begin
	update users
    set total_posts=total_posts-1
    where user_id=old.user_id;
end $$
delimiter ;

delete
from posts
where post_id =1;

drop trigger if exists tg_checkPostContent;
drop trigger if exists after_insert_post;
drop trigger if exists tg_LogPostChanges;
drop trigger if exists tg_UpdatePostCountAfterDelete;