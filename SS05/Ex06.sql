USE SS05;

SELECT p.product_id, p.product_name, p.price, p.stock, p.status
	FROM Products p
    WHERE p.status = 'active' and p.price BETWEEN 1000000 AND 3000000
    ORDER BY p.price ASC
    LIMIT 10;
    
SELECT p.product_id, p.product_name, p.price, p.stock, p.status
	FROM Products p
    WHERE p.status = 'active' and p.price BETWEEN 1000000 AND 3000000
    ORDER BY p.price ASC
    LIMIT 10 OFFSET 10;