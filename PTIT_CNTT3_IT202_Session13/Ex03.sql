delimiter $$

create trigger trg_likes_before_insert
before insert on likes
for each row
begin
    if new.user_id = (select user_id from posts where post_id = new.post_id) then
        signal sqlstate '45000'
        set message_text = 'khong duoc like bai dang cua chinh minh';
    end if;
end$$

create trigger trg_likes_after_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$

create trigger trg_likes_after_delete
after delete on likes
for each row
begin
    update posts
    set like_count = like_count - 1
    where post_id = old.post_id;
end$$

create trigger trg_likes_after_update
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
end$$

delimiter ;

insert into likes (user_id, post_id, liked_at)
values (1, 1, now());

insert into likes (user_id, post_id, liked_at)
values (2, 1, now());

select post_id, like_count from posts where post_id = 1;

update likes
set post_id = 4
where user_id = 2 and post_id = 1;

select post_id, like_count from posts where post_id in (1, 4);

delete from likes
where user_id = 2 and post_id = 4;

select post_id, like_count from posts where post_id in (1, 4);

select * from user_statistics;
