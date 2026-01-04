USE SS05;

ALTER TABLE Products
	ADD sold_quantity INT DEFAULT 0 CHECK(sold_quantity >= 0);
    
SELECT s.product_id, s.product_name, s.price, s.stock, s.status, s.sold_quantity
	FROM Products s
    ORDER BY sold_quantity DESC
    LIMIT 10;

SELECT s.product_id, s.product_name, s.price, s.stock, s.status, s.sold_quantity
	FROM Products s
    ORDER BY sold_quantity DESC
    LIMIT 10 OFFSET 5;

SELECT s.product_id, s.product_name, s.price, s.stock, s.status, s.sold_quantity
	FROM Products s
    WHERE price <2000000
    ORDER BY sold_quantity DESC;