SELECT name
	FROM customers
	WHERE (
		SELECT SUM(total_amount)
		FROM orders
		WHERE orders.customer_id = customers.id
	) = (
		SELECT MAX(total_spent)
		FROM (
			SELECT SUM(total_amount) AS total_spent
			FROM orders
			GROUP BY customer_id
		) AS temp
	);
