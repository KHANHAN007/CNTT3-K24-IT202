DROP DATABASE IF EXISTS product_db;
CREATE DATABASE product_db;
USE product_db;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT,
    status VARCHAR(20) 
);

INSERT INTO products (product_name, category, price, stock, status) VALUES
('Laptop', 'Electronics', 1500, 10, 'ACTIVE'),
('Mouse', 'Accessories', 20, 100, 'ACTIVE'),
('Keyboard', 'Accessories', 50, 50, 'ACTIVE'),
('Monitor', 'Electronics', 300, 20, 'ACTIVE'),
('Printer', 'Electronics', 200, 0, 'INACTIVE'),
('USB Cable', 'Accessories', 10, 200, 'ACTIVE'),
('Webcam', 'Electronics', 80, 15, 'ACTIVE'),
('Headphone', 'Accessories', 120, 0, 'INACTIVE'),
('Tablet', 'Electronics', 600, 8, 'ACTIVE'),
('Speaker', 'Accessories', 150, 12, 'ACTIVE');

select * from products;

select * from products
where status = 'ACTIVE';

select product_name, price 
from products
where price > 100;

select * from products
where price >=50 and price <=300;

select * from products
where category = 'Electronics';

select * from products
where stock = 0;

select * from products
where product_name like '%o%';

select * from products
order by price asc;

select * from products
order by stock desc;

select * from products
where status = 'ACTIVE'
limit 5;

