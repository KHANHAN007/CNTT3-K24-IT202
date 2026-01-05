create database Session06;
use Session06;

-- Bai 1: 
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
     order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (full_name, city) VALUES
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Hồ Chí Minh'),
('Lê Văn C', 'Đà Nẵng'),
('Phạm Thị D', 'Hà Nội'),
('Hoàng Văn E', 'Cần Thơ');

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-01-01', 'completed'),
(1, '2025-01-05', 'pending'),
(2, '2025-01-03', 'completed'),
(3, '2025-01-07', 'cancelled'),
(2, '2025-01-10', 'completed');

SELECT 
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;

-- Bai 2: 
ALTER TABLE orders
ADD COLUMN total_amount DECIMAL(10,2);

UPDATE orders SET total_amount = 5000000 WHERE order_id = 1;
UPDATE orders SET total_amount = 3000000 WHERE order_id = 2;
UPDATE orders SET total_amount = 8000000 WHERE order_id = 3;
UPDATE orders SET total_amount = 2000000 WHERE order_id = 4;
UPDATE orders SET total_amount = 10000000 WHERE order_id = 5;

SELECT
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT
    c.customer_id,
    c.full_name,
    MAX(o.total_amount) AS max_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;


-- Bai 3: 
SELECT
    order_date,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

SELECT
    order_date,
    COUNT(order_id) AS total_orders
FROM orders
WHERE status = 'completed'
GROUP BY order_date;

SELECT
    order_date,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'completed'
GROUP BY order_date
HAVING SUM(total_amount) > 10000000;

-- Bai 4: 
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price) VALUES
('Laptop Dell', 15000000),
('Chuột Logitech', 500000),
('Bàn phím Cơ', 2000000),
('Màn hình LG', 7000000),
('Tai nghe Sony', 3000000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 1, 1),
(5, 4, 1),
(5, 5, 2);

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
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name;

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;

-- Bai 5:
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name
HAVING 
    COUNT(o.order_id) >= 3
    AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;

-- Bai 6 : 
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue,
    AVG(p.price) AS avg_price
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY total_revenue DESC
LIMIT 5;






