SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	WHERE status <> 'cancelled'
	ORDER BY order_date DESC
	LIMIT 5 OFFSET 0;

SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	WHERE status <> 'cancelled'
	ORDER BY order_date DESC
	LIMIT 5 OFFSET 5;

SELECT order_id, customer_id, total_amount, order_date, status
	FROM orders
	WHERE status <> 'cancelled'
	ORDER BY order_date DESC
	LIMIT 5 OFFSET 10;
