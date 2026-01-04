CREATE DATABASE Session05;

USE Session05;

CREATE TABLE Product(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK(price > 0),
    stock INT NOT NULL,
    status ENUM('active', 'inactive')
);

SELECT * FROM Product;

SELECT * FROM Product 
	WHERE status = 'active';
    
SELECT * FROM Product
	WHERE price > 1000000;

SELECT * FROM Product
	WHERE status = 'active'
	ORDER BY price ASC;