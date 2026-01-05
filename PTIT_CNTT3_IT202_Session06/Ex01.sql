CREATE DATABASE Session06;

USE Session06;

CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE Orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, full_name, city) VALUES
	(1, 'Nguyen Van An', 'Hanoi'),
	(2, 'Tran Thi Binh', 'Ho Chi Minh'),
	(3, 'Le Van Cuong', 'Da Nang'),
	(4, 'Pham Thi Dao', 'Hai Phong'),
	(5, 'Hoang Van Dung', 'Can Tho');


INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
	(101, 1, '2026-01-01', 'completed'),
	(102, 2, '2026-01-02', 'pending'),
	(103, 1, '2026-01-03', 'completed'),
	(104, 3, '2026-01-04', 'cancelled'),
	(105, 4, '2026-01-05', 'completed');

            
SELECT o.order_id, c.full_name, o.order_date, o.status
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id;

    
SELECT c.full_name, COUNT(o.order_id) AS total_orders
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.full_name;

    
SELECT c.full_name, COUNT(o.order_id) AS total_orders
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.full_name
	HAVING COUNT(o.order_id) >= 1;
