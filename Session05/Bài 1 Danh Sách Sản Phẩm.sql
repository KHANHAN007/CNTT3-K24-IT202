CREATE DATABASE it202_session05;
USE it202_session05;

-- Bài 01: Danh Sách sản phẩm trong cửa hàng
CREATE TABLE product(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) CHECK(price>0) NOT NULL,
    stock INT NOT NULL CHECK (stock>=0),
    product_status ENUM('active','inactive')
);

SELECT * FROM product;
SELECT * FROM product WHERE product_status='active';
SELECT * FROM product WHERE price>1000000;
SELECT * FROM product ORDER BY price ASC;