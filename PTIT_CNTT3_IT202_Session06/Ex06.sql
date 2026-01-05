USE SS06;

SELECT p.product_name, SUM(i.quantity) AS total_sold, SUM(i.quantity * price) AS total_revenue, AVG(p.price) AS avg_price
	FROM Products p
    JOIN Order_Items i ON p.product_id = i.product_id
	GROUP BY p.product_id, p.product_name
	HAVING SUM(i.quantity) >= 10
	ORDER BY total_revenue DESC
	LIMIT 5;     