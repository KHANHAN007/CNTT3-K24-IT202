SELECT o.customer_id, 
		(
			SELECT c.name
				FROM Customers c
				WHERE o.customer_id = c.id
		) AS Name
	FROM Orders o
    GROUP BY o.customer_id
    HAVING SUM(total_amount) > (
								SELECT AVG(o.total_amount)
									FROM Orders o
								)