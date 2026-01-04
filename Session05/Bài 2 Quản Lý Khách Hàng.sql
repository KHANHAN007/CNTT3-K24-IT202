CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    city VARCHAR(255) NOT NULL,
    customer_status ENUM('active','inactive')
);

SELECT * FROM customers;
SELECT * FROM customers WHERE city='TP.HCM';
SELECT * FROM customers WHERE city='Hà Nội' AND customer_status='active';
SELECT * FROM customers ORDER BY full_name ASC;