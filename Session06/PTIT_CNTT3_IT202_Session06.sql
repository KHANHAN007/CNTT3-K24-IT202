CREATE DATABASE it202_session06;
USE it202_session06;
-- Bài 01
CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255),
    city VARCHAR(255)
);

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    order_date DATE DEFAULT(CURRENT_DATE),
    order_status ENUM('pending','completed','cancelled')
);

INSERT INTO customers (full_name, city) VALUES
('Nguyễn Văn An', 'Hà Nội'),
('Trần Thị Bình', 'TP. Hồ Chí Minh'),
('Lê Văn Cường', 'Đà Nẵng'),
('Phạm Thị Dung', 'Hải Phòng'),
('Hoàng Văn Em', 'Cần Thơ');

INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1, '2025-01-01', 'pending'),
(2, '2025-01-02', 'completed'),
(3, '2025-01-03', 'cancelled'),
(4, CURRENT_DATE, 'pending'),
(5, CURRENT_DATE, 'completed');

SELECT o.order_id,c.full_name , o.order_date, o.order_status FROM orders o JOIN customers c on o.customer_id=c.customer_id;
SELECT c.customer_id, c.full_name, c.city, COUNT(o.order_id) as total_order FROM customers c 
LEFT JOIN orders o on c.customer_id=o.customer_id
GROUP BY c.customer_id, c.full_name;
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;
-- Bài 02
ALTER TABLE orders
ADD total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount>=0) ;
UPDATE orders SET total_amount = 500000 WHERE order_id = 1;
UPDATE orders SET total_amount = 1200000 WHERE order_id = 2;
UPDATE orders SET total_amount = 0 WHERE order_id = 3;
UPDATE orders SET total_amount = 750000 WHERE order_id = 4;
UPDATE orders SET total_amount = 2300000 WHERE order_id = 5;

SELECT 
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;
-- Bài 03
SELECT 
    order_date,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE order_status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;
-- Bài  04:
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price) VALUES
('Laptop Dell', 20000000),
('Chuột Logitech', 500000),
('Bàn phím cơ', 1500000),
('Màn hình Samsung', 4500000),
('Tai nghe Sony', 2500000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 3),
(2, 4, 1),
(3, 5, 2),
(4, 1, 1),
(4, 3, 2),
(5, 4, 2);

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;
-- Bài 05
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.customer_id, c.full_name
HAVING 
    COUNT(o.order_id) >= 3
    AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;
--  Bài 06
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue,
    AVG(oi.quantity * p.price) AS avg_sale_value
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY total_revenue DESC
LIMIT 5;

