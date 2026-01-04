USE Session05;

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES 
(1, 100000, '2024-03-07', 'pending'),
(3, 200000, '2024-03-08', 'completed'),
(2, 5000000, '2024-03-09', 'pending'),
(4, 300000, '2024-03-10', 'completed'),
(1, 450000, '2024-03-11', 'pending'),
(5, 600000, '2024-03-12', 'completed'),
(2, 700000, '2024-03-13', 'completed'),
(3, 150000, '2024-03-14', 'cancelled'), 
(4, 900000, '2024-03-15', 'pending'),
(1, 2500000, '2024-03-16', 'completed');


SELECT order_id, customer_id, total_amount, order_date, status
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5;

SELECT order_id, customer_id, total_amount, order_date, status
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT order_id, customer_id, total_amount, order_date, status
FROM orders
WHERE status != 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;