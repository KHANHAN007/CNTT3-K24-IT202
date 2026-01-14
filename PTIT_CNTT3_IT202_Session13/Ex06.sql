create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending','accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
) engine=innodb;

delimiter $$

create trigger trg_friendships_after_insert
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users
        set follower_count = follower_count + 1
        where user_id = new.followee_id;
    end if;
end$$

create trigger trg_friendships_after_delete
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users
        set follower_count = follower_count - 1
        where user_id = old.followee_id;
    end if;
end$$

create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending','accepted')
)
begin
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'khong duoc tu follow chinh minh';
    end if;

    if exists (
        select 1 from friendships
        where follower_id = p_follower_id
          and followee_id = p_followee_id
    ) then
        signal sqlstate '45000'
        set message_text = 'da ton tai quan he follow';
    end if;

    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end$$

delimiter ;

create view user_profile as
select
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    coalesce(sum(p.like_count),0) as total_likes,
    group_concat(
        concat(p.post_id, ': ', p.content)
        order by p.created_at desc
        separator ' | '
    ) as recent_posts
from users u
left join posts p on u.user_id =_
