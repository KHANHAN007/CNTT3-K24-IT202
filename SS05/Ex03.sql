USE SS05;

CREATE TABLE Orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount > 0),
    order_date DATE DEFAULT(current_date),
    status ENUM('pending', 'completed', 'cancellted') DEFAULT('pending')
);

SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders as o
	WHERE status = 'completed';
    
SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders o
    WHERE total_amount > 5000000;
    
SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders as o
	ORDER BY order_date DESC
    LIMIT 5;

SELECT *
	FROM orders
	WHERE status = 'completed'
	ORDER BY total_amount DESC;