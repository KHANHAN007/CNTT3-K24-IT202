use Session05;
create table customers(
	customer_id int primary key auto_increment,
    full_name varchar(255),
    email varchar(255) not null,
    city varchar(255) not null,
    customer_status enum('active', 'inactive')
);
INSERT INTO customers (full_name, email, city, customer_status) VALUES 
('Nguyễn Văn An', 'an.nguyen@email.com', 'Ha Noi', 'active'),
('Trần Thị Bích', 'bich.tran@email.com', 'TP.HCM', 'active'),
('Lê Hoàng Cường', 'cuong.le@email.com', 'Ha Noi', 'inactive'),
('Phạm Minh Đức', 'duc.pham@email.com', 'TP.HCM', 'inactive'),
('Võ Thị Ánh', 'anh.vo@email.com', 'Da Nang', 'active'),
('Hoàng Văn Em', 'em.hoang@email.com', 'Ha Noi', 'active');

select * from customers 
where city = 'TP.HCM';
select * from customers
where customer_status = 'active' and city = 'Ha Noi';
select * from customers
order by full_name asc;