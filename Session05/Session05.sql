CREATE DATABASE Session05;
USE Session05;

-- Bai 1 :
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO Product (product_name, price, stock, status) VALUES
('Laptop Dell', 15000000, 10, 'active'),
('Chuột Logitech', 500000, 50, 'active'),
('Bàn phím cơ', 1200000, 20, 'active'),
('Màn hình Samsung', 3500000, 15, 'inactive'),
('Tai nghe Bluetooth', 900000, 30, 'active'),
('USB 32GB', 200000, 100, 'inactive');

SELECT * 
FROM Product;

SELECT *
FROM Product
WHERE status = 'active';

SELECT *
FROM Product
WHERE price > 1000000;

SELECT *
FROM Product
WHERE status = 'active'
ORDER BY price ASC;

-- Bai 2 :
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

INSERT INTO customers (full_name, email, city, status) VALUES
('Nguyen Van An', 'an@gmail.com', 'Hà Nội', 'active'),
('Tran Thi Binh', 'binh@gmail.com', 'TP.HCM', 'active'),
('Le Hoang Cuong', 'cuong@gmail.com', 'Đà Nẵng', 'inactive'),
('Pham Minh Duc', 'duc@gmail.com', 'Hà Nội', 'active'),
('Vo Thi Hoa', 'hoa@gmail.com', 'TP.HCM', 'inactive'),
('Dang Quoc Khanh', 'khanh@gmail.com', 'Hà Nội', 'inactive');

SELECT *
FROM customers;

SELECT *
FROM customers
WHERE city = 'TP.HCM';

SELECT *
FROM customers
WHERE status = 'active'
  AND city = 'Hà Nội';

SELECT *
FROM customers
ORDER BY full_name ASC;

-- Bai 3 : 
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL
);

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 3200000, '2024-07-10', 'completed'),
(2, 7800000, '2024-07-12', 'pending'),
(3, 12500000, '2024-07-15', 'completed'),
(1, 4500000, '2024-07-18', 'cancelled'),
(4, 9800000, '2024-07-20', 'completed'),
(2, 1500000, '2024-07-22', 'pending'),
(5, 6200000, '2024-07-25', 'completed');

SELECT *
FROM orders
WHERE status = 'completed';

SELECT *
FROM orders
WHERE total_amount > 5000000;

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;

-- Bai 4 :
ALTER TABLE Product
ADD sold_quantity INT NOT NULL DEFAULT 0;
UPDATE Product 
SET sold_quantity = 120
WHERE product_id = 1; 

UPDATE Product 
SET sold_quantity = 300 
WHERE product_id = 2;

UPDATE Product 
SET sold_quantity = 180 
WHERE product_id = 3;

UPDATE Product 
SET sold_quantity = 90  
WHERE product_id = 4;

UPDATE Product 
SET sold_quantity = 210 
WHERE product_id = 5;

UPDATE Product 
SET sold_quantity = 400 
WHERE product_id = 6;

SELECT *
FROM Product
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT *
FROM Product
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

SELECT *
FROM Product
WHERE price < 2000000
ORDER BY sold_quantity DESC;

-- Bai 5 : 
SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT *
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;

-- Bai 6 : 
SELECT *
FROM Product
WHERE status = 'active'
AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;

SELECT *
FROM Product
WHERE status = 'active'
AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;



