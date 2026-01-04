CREATE DATABASE SS05;

USE SS05;

CREATE TABLE Products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK(price > 0),
    stock INT NOT NULL,
    status ENUM('active', 'inactive') DEFAULT('active')
);

SELECT * FROM Products;

SELECT * FROM Products
	WHERE status = 'active';
    
SELECT * FROM Products
	WHERE price > 1000000;

SELECT * FROM Products
	WHERE status = 'active'
    ORDER BY price ASC;