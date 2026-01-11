create database IT202_Session07;
use IT202_Session07;


-- Bài 01
create table customers (
    customer_id int primary key auto_increment,
    customer_name varchar(255) not null,
    email varchar(255) unique not null
);

create table orders (
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date date default (current_date),
    total_amount decimal(12,2) not null check (total_amount >= 0),
    foreign key (customer_id) references customers(customer_id)
);

INSERT INTO customers (customer_name, email) VALUES
('Nguyen Van An', 'an@gmail.com'),
('Tran Thi Binh', 'binh@gmail.com'),
('Le Hoang Cuong', 'cuong@gmail.com'),
('Pham Minh Duc', 'duc@gmail.com'),
('Vo Thi Hoa', 'hoa@gmail.com'),
('Dang Quang Huy', 'huy@gmail.com'),
('Bui Ngoc Lan', 'lan@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-01-01', 1500000),
(2, '2025-01-03', 2300000),
(3, '2025-01-05', 800000),
(1, '2025-01-07', 1200000),
(4, '2025-01-10', 4500000),
(5, '2025-01-12', 950000),
(6, '2025-01-15', 3200000);

select customer_id, customer_name, email
from customers where customer_id in (select customer_id from orders);


-- Bài 02
create table products (
	product_id int primary key auto_increment,
    product_name varchar(255) not null,
    price decimal(10,2) check (price>0) not null
);

create table order_items(
	order_id int ,
    product_id int,
    primary key(order_id,product_id),
    quantity int check(quantity>=0) not null,
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

INSERT INTO products (product_name, price) VALUES
('Laptop Dell', 15000000),
('Chuột Logitech', 350000),
('Bàn phím cơ', 1200000),
('Màn hình Samsung', 4200000),
('Tai nghe Sony', 1800000),
('Ổ cứng SSD 1TB', 2500000),
('USB 64GB', 280000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 1),
(4, 5, 2),
(5, 6, 1),
(6, 7, 3);

SELECT product_id, product_name
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM order_items
);

-- Bài 03
select order_id, order_date, total_amount
from orders
where total_amount > (select avg(total_amount) from orders);

-- Bài 04
SELECT
    customer_name,
    (
        SELECT COUNT(order_id)
        FROM orders
        WHERE orders.customer_id = customers.customer_id
    ) AS order_count
FROM customers;

-- Bài 05
SELECT customer_name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(total_spent)
        FROM (
            SELECT SUM(total_amount) AS total_spent
            FROM orders
            GROUP BY customer_id
        ) AS temp
    )
);
-- Bài 06
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY customer_id
    ) AS temp
);

