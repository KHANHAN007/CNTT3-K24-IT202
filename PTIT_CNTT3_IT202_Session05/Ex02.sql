USE Session05;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(255),
    status ENUM('active', 'inactive') NOT NULL
);

SELECT customer_id, full_name, email, city, status
	FROM customers;

SELECT customer_id, full_name, email, city, status
	FROM customers
	WHERE city = 'TP.HCM';
    
SELECT customer_id, full_name, email, city, status
	FROM customers
	WHERE status = 'active'
	  AND city = 'Hà Nội';
      
SELECT customer_id, full_name, email, city, status
	FROM customers
	ORDER BY full_name ASC;