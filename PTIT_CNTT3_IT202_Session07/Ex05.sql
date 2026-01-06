SELECT c.id, c.name, c.email
	FROM Customers c
    WHERE c.id = (
		SELECT o.customer_id
			FROM Orders o
			GROUP BY o.customer_id
            HAVING SUM(total_amount) = (
				SELECT MAX(total_spent)
                FROM (
					SELECT SUM(total_amount) AS total_spent
						FROM Orders o
						GROUP BY o.customer_id
                )AS T
            )
    )
