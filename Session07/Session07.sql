CREATE DATABASE Session07;
USE Session07;

-- Bai 1

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (name, email) VALUES
('Nguyen Van A', 'a@gmail.com'),
('Tran Thi B', 'b@gmail.com'),
('Le Van C', 'c@gmail.com'),
('Pham Thi D', 'd@gmail.com'),
('Hoang Van E', 'e@gmail.com'),
('Nguyen Thi F', 'f@gmail.com'),
('Dang Van G', 'g@gmail.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2026-01-01', 500000),
(2, '2026-01-02', 750000),
(1, '2026-01-03', 300000),
(3, '2026-01-04', 450000),
(4, '2026-01-05', 600000),
(5, '2026-01-06', 800000),
(2, '2026-01-07', 200000);

SELECT id, name, email
FROM customers
WHERE id IN (SELECT customer_id FROM orders);

-- SELECT id, name, email
-- FROM customers
-- WHERE id NOT IN (SELECT customer_id FROM orders);

-- Bai 2

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name, price) VALUES
('Laptop Dell', 15000000),
('Chuột Logitech', 500000),
('Bàn phím cơ', 1200000),
('Màn hình LG', 4000000),
('Tai nghe Sony', 2000000),
('USB Sandisk 32GB', 300000),
('Laptop HP', 14000000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(2, 4, 1),
(3, 1, 1),
(3, 5, 1),
(4, 6, 3),
(4, 2, 1);

SELECT id, name, price
FROM products
WHERE id IN (SELECT product_id FROM order_items);

-- Bai 3 : 
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- Bai 4 : 
SELECT 
    name,
    (SELECT COUNT(*) 
     FROM orders o
     WHERE o.customer_id = customers.id) AS so_luong_don_hang
FROM customers;

-- Bai 5 : 
SELECT name
FROM customers
WHERE id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) = (
        SELECT MAX(tong)
        FROM (
            SELECT SUM(total_amount) AS tong
            FROM orders
            GROUP BY customer_id
        ) AS sub
    )
);

-- Bai 6 :
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(tong)
    FROM (
        SELECT SUM(total_amount) AS tong
        FROM orders
        GROUP BY customer_id
    ) AS sub
);

