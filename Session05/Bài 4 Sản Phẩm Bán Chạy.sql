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

SELECT * FROM product ORDER BY sold_quantity DESC LIMIT 10 OFFSET 0;

SELECT * FROM product ORDER BY sold_quantity DESC LIMIT 5 OFFSET 10;

SELECT * FROM product WHERE price<2000000 ORDER BY sold_quantity DESC;