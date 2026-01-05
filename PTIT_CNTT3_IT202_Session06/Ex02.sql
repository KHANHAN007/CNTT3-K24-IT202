USE Session06;

ALTER TABLE orders
	ADD COLUMN total_amount DECIMAL(10,2);


UPDATE orders SET total_amount = 250.50 WHERE order_id = 101;
UPDATE orders SET total_amount = 120.00 WHERE order_id = 102;
UPDATE orders SET total_amount = 300.75 WHERE order_id = 103;
UPDATE orders SET total_amount = 80.00  WHERE order_id = 104;
UPDATE orders SET total_amount = 500.00 WHERE order_id = 105;
    
SELECT c.full_name, SUM(o.total_amount) AS total_spent
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.full_name
	ORDER BY total_spent DESC;

    
SELECT c.full_name, MAX(o.total_amount) AS max_order_value
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.full_name
	ORDER BY max_order_value DESC;
