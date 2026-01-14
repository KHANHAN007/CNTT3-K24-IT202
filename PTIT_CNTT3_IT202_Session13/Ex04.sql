create table post_history (
    history_id int auto_increment primary key,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
) engine=innodb;

delimiter $$

create trigger trg_posts_before_update
before update on posts
for each row
begin
    if old.content <> new.content then
        insert into post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        ) values (
            old.post_id,
            old.content,
            new.content,
            now(),
            old.user_id
        );
    end if;
end$$

delimiter ;

update posts
set content = 'alice updated her first post'
where post_id = 1;

update posts
set content = 'bob updated his first post'
where post_id = 3;

select * from post_history;

select post_id, like_count from posts;

select * from user_statistics;
