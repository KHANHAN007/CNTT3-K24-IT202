use Session05;

create table product (
		product_id int primary key auto_increment,
        product_name varchar(255) not null,
        price decimal(10,2) not null,
        stock int, 
        product_status enum('active', 'inactive')
);
INSERT INTO product (product_name, price, stock, product_status) VALUES 
('Laptop Dell XPS', 25000000, 10, 'active'),
('Chuột Logitech', 500000, 50, 'active'),
('Bàn phím cơ cũ', 800000, 0, 'inactive'),
('Màn hình LG', 3500000, 5, 'active'),
('Tai nghe hỏng', 200000, 2, 'inactive');

select * from product
where product_status = 'active' and price >1000000
order by price asc;


