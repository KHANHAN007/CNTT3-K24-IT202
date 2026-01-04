USE Session05;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) CHECK (total_amount > 0),
    order_date DATE NOT NULL,
    status ENUM('pending', 'completed', 'cancelled') NOT NULL
);

SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	WHERE status = 'completed';


SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	WHERE total_amount > 5000000;

	
SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	ORDER BY order_date DESC
	LIMIT 5;

	
SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	WHERE status = 'completed'
	ORDER BY total_amount DESC;
