CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount>0),
    order_date DATE DEFAULT(CURRENT_DATE), 
    order_status ENUM('pending','completed','cancelled')
);

SELECT * FROM orders WHERE order_status='completed';
SELECT * FROM orders WHERE total_amount>5000000;
SELECT * FROM orders ORDER BY order_date DESC LIMIT 5 OFFSET 0;
SELECT * FROM orders WHERE order_status='completed' ORDER BY total_amount DESC;
