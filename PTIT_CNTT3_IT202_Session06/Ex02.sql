USE SS06;

ALTER TABLE Orders
	ADD COLUMN total_amount DECIMAL(10,2) CHECK(total_amount >=0);

UPDATE Orders
	SET total_amount = 25000000
    WHERE order_id = 1;
    
UPDATE Orders
	SET total_amount = 180000000
	WHERE order_id = 2;

UPDATE Orders
	SET total_amount = 320000000
	WHERE order_id = 3;

UPDATE Orders
	SET total_amount = 90000000
	WHERE order_id = 4;

UPDATE Orders
	SET total_amount = 450000000
	WHERE order_id = 5;
    
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
