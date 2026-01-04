USE SS05;

SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders as o
	ORDER BY order_date DESC
    LIMIT 5;

SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders as o
	ORDER BY order_date DESC
    LIMIT 5 OFFSET 5;
    
SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders as o
	ORDER BY order_date DESC
    LIMIT 5 OFFSET 10;
    
SELECT o.order_id, o.customer_id, total_amount, order_date, status
	FROM Orders as o
	WHERE status <> 'cancellted';