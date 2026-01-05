CREATE TABLE orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount>0),
    order_date DATE DEFAULT(CURRENT_DATE), 
    order_status ENUM('pending','completed','cancelled')
);

INSERT INTO orders (customer_id, total_amount, order_date, order_status) VALUES
(1, 1200000, '2025-01-01', 'completed'),
(2, 2500000, '2025-01-02', 'pending'),
(3, 800000,  '2025-01-03', 'completed'),
(4, 6000000, '2025-01-04', 'completed'),
(5, 1500000, '2025-01-05', 'cancelled'),
(6, 3200000, '2025-01-06', 'pending'),
(7, 900000,  '2025-01-07', 'completed'),
(8, 4500000, '2025-01-08', 'pending'),
(9, 7000000, '2025-01-09', 'completed'),
(10,1800000, '2025-01-10', 'completed'),
(11,2100000, '2025-01-11', 'pending'),
(12,500000,  '2025-01-12', 'completed'),
(13,3300000, '2025-01-13', 'cancelled'),
(14,4100000, '2025-01-14', 'completed'),
(15,2600000, '2025-01-15', 'pending');
SELECT *
FROM orders
WHERE order_status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;
SELECT *
FROM orders
WHERE order_status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;
SELECT *
FROM orders
WHERE order_status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;
