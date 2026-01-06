SELECT c.id, c.name, (
						SELECT COUNT(o.id)
							FROM Orders o
                            WHERE c.id = o.customer_id
						) AS total_quantity
	FROM Customers c