USE SS06;

ALTER TABLE Orders
	ADD COLUMN total_amount DECIMAL(10,2) CHECK(total_amount >=0);

UPDATE Orders
	SET total_amount = 25000000
    WHERE order_id = 1;
    
UPDATE Orders
	SET total_amount = 180000000
	WHERE order_id = 2;

UPDATE Orders
	SET total_amount = 320000000
	WHERE order_id = 3;

UPDATE Orders
	SET total_amount = 90000000
	WHERE order_id = 4;

UPDATE Orders
	SET total_amount = 450000000
	WHERE order_id = 5;
    
SELECT c.customer_id, c.full_name, o.total_amount
	FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id;
    
SELECT c.customer_id, c.full_name, o.total_amount
	FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    ORDER BY o.total_amount DESC;