SELECT o.id, 
		(
		SELECT c.name
			FROM Customers c
            WHERE o.customer_id = c.id) AS Customer_name,
		o.total_amount
	FROM Orders o
    WHERE total_amount > (SELECT AVG(o.total_amount)
							FROM Orders o);