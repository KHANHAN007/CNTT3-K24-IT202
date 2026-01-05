USE SS06;

SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
	FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.full_name
    HAVING COUNT(o.order_id) >= 3
			AND SUM(o.total_amount) > 1000000
	ORDER BY total_spent DESC;  