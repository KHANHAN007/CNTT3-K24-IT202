use IT202_Session05;

CREATE TABLE product(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) CHECK(price>0) NOT NULL,
    stock INT NOT NULL CHECK (stock>=0),
    product_status ENUM('active','inactive'),
    sold_quantity INT NOT NULL CHECK(sold_quantity>=0)
);

INSERT INTO product (product_name, price, stock, product_status, sold_quantity)
VALUES
('Laptop Dell Inspiron', 15000000.00, 10, 'active', 5),
('Laptop HP Pavilion', 16500000.00, 8, 'active', 3),
('Laptop Asus VivoBook', 14000000.00, 12, 'active', 7),
('MacBook Air M1', 23500000.00, 5, 'active', 9),
('MacBook Pro M2', 32000000.00, 3, 'active', 4),

('Chuột Logitech M331', 350000.00, 50, 'active', 20),
('Bàn phím Logitech K380', 750000.00, 30, 'active', 15),
('Tai nghe Sony WH-1000XM4', 6500000.00, 6, 'active', 2),
('Tai nghe AirPods Pro', 5900000.00, 7, 'active', 6),
('Loa JBL Charge 5', 4200000.00, 9, 'active', 4),

('Màn hình LG 24 inch', 4200000.00, 11, 'active', 5),
('Màn hình Dell 27 inch', 6900000.00, 4, 'active', 2),
('Ổ cứng SSD Samsung 1TB', 2800000.00, 20, 'active', 12),
('Ổ cứng HDD WD 2TB', 1900000.00, 18, 'active', 10),
('USB Kingston 64GB', 180000.00, 100, 'active', 40),

('Sạc nhanh Anker 65W', 950000.00, 25, 'active', 13),
('Cáp USB-C Anker', 250000.00, 60, 'active', 22),
('Webcam Logitech C920', 2200000.00, 7, 'inactive', 6),
('Máy in Canon LBP2900', 3500000.00, 2, 'inactive', 8),
('Router Wifi TP-Link AX1500', 1800000.00, 10, 'active', 5);

CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount>0),
    order_date DATE DEFAULT(CURRENT_DATE), 
    order_status ENUM('pending','completed','cancelled')
);

INSERT INTO orders (customer_id, total_amount, order_date, order_status) VALUES
(1, 1200000, '2025-01-01', 'completed'),
(2, 2500000, '2025-01-02', 'pending'),
(3, 800000,  '2025-01-03', 'completed'),
(4, 6000000, '2025-01-04', 'completed'),
(5, 1500000, '2025-01-05', 'cancelled'),
(6, 3200000, '2025-01-06', 'pending'),
(7, 900000,  '2025-01-07', 'completed'),
(8, 4500000, '2025-01-08', 'pending'),
(9, 7000000, '2025-01-09', 'completed'),
(10,1800000, '2025-01-10', 'completed'),
(11,2100000, '2025-01-11', 'pending'),
(12,500000,  '2025-01-12', 'completed'),
(13,3300000, '2025-01-13', 'cancelled'),
(14,4100000, '2025-01-14', 'completed'),
(15,2600000, '2025-01-15', 'pending');

SELECT *
FROM product
WHERE product_status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;

SELECT *
FROM product
WHERE product_status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;

