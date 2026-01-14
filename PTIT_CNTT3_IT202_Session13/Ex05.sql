delimiter $$

create trigger trg_users_before_insert
before insert on users
for each row
begin
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'email khong hop le';
    end if;

    if new.username not regexp '^[a-zA-Z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'username chua ky tu khong hop le';
    end if;
end$$

create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end$$

delimiter ;

call add_user('valid_user_1', 'valid1@example.com', '2025-02-01');

call add_user('invalid-user', 'invalid2@example.com', '2025-02-02');

call add_user('invaliduser2', 'invalidemail', '2025-02-03');

select * from users;
