use social_network_pro;
-- Bài 03:
explain analyze
select *
from users
where hometown = 'Hà Nội';

create index idx_hometown
on users (hometown);

drop index idx_hometown
on users;

-- Bài 04
  
explain analyze
select
    post_id,
    content,
    created_at
from posts
where user_id = 1
  and created_at >= '2026-01-01'
  and created_at < '2027-01-01';

create index idx_created_at_user_id
on posts (user_id, created_at);

explain analyze
select
    user_id,
    username,
    email
from users
where email = 'an@gmail.com';

create unique index idx_email
on users (email);

drop index idx_created_at_user_id
on posts;

-- Bài 05:
create index idx_hometown
on users (hometown);

explain analyze
select
    u.username,
    u.hometown,
    p.post_id,
    p.content
from users u
join posts p
    on u.user_id = p.user_id
where u.hometown = 'Hà Nội'
order by u.username desc
limit 10;

-- Bài 06:
create or replace view view_users_summary as
select
    u.user_id,
    u.username,
    count(p.post_id) as total_posts
from users u
left join posts p
    on u.user_id = p.user_id
group by u.user_id, u.username;

select
    user_id,
    username,
    total_posts
from view_users_summary
where total_posts > 5;
-- Bài 07:
create or replace view view_user_activity_status as
select
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    case
        when count(distinct p.post_id) > 0
          or count(distinct c.comment_id) > 0
        then 'active'
        else 'inactive'
    end as status
from users u
left join posts p
    on u.user_id = p.user_id
left join comments c
    on u.user_id = c.user_id
group by
    u.user_id,
    u.username,
    u.gender,
    u.created_at;

select *
from view_user_activity_status;

select
    status,
    count(user_id) as user_count
from view_user_activity_status
group by status
order by user_count desc;

-- Bài 08:

create index idx_user_gender
on users (gender);

create or replace view view_popular_posts as
select
    p.post_id,
    u.username,
    p.content,
    count(distinct l.user_id) as total_likes,
    count(distinct c.comment_id) as total_comments
from posts p
join users u
    on p.user_id = u.user_id
left join likes l
    on p.post_id = l.post_id
left join comments c
    on p.post_id = c.post_id
group by
    p.post_id,
    u.username,
    p.content;

select *
from view_popular_posts;

select
    post_id,
    username,
    content,
    total_likes,
    total_comments,
    (total_likes + total_comments) as total_interactions
from view_popular_posts
where (total_likes + total_comments) > 10
order by total_interactions desc;

-- Bài 09:
create index idx_user_gender
on users (gender);

create or replace view view_user_activity as
select
    u.user_id,
    count(distinct p.post_id) as total_posts,
    count(distinct c.comment_id) as total_comments
from users u
left join posts p
    on u.user_id = p.user_id
left join comments c
    on u.user_id = c.user_id
group by u.user_id;

select *
from view_user_activity;

select
    u.user_id,
    u.username,
    u.gender,
    v.total_posts,
    v.total_comments
from users u
join view_user_activity v
    on u.user_id = v.user_id
where v.total_posts > 5
  and v.total_comments > 20
order by v.total_comments desc
limit 5;

