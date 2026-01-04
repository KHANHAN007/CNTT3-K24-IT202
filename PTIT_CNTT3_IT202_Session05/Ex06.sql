SELECT product_id, product_name, price, stock, sold_quantity, status
	FROM products
	WHERE status = 'active'
	  AND price BETWEEN 1000000 AND 3000000
	ORDER BY price ASC
	LIMIT 10 OFFSET 0;

SELECT product_id, product_name, price, stock, sold_quantity, status
	FROM products
	WHERE status = 'active'
	  AND price BETWEEN 1000000 AND 3000000
	ORDER BY price ASC
	LIMIT 10 OFFSET 10;
