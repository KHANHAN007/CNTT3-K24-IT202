USE Session05;


ALTER TABLE product 
ADD COLUMN sold_quantity INT DEFAULT 0 CHECK (sold_quantity >= 0);

UPDATE product SET sold_quantity = 100 WHERE product_name = 'Laptop Dell XPS';
UPDATE product SET sold_quantity = 500 WHERE product_name = 'Chuột Logitech';
UPDATE product SET sold_quantity = 20 WHERE product_name = 'Bàn phím cơ cũ';
UPDATE product SET sold_quantity = 80 WHERE product_name = 'Màn hình LG';
UPDATE product SET sold_quantity = 5 WHERE product_name = 'Tai nghe hỏng';


SELECT product_id, product_name, price, stock, product_status, sold_quantity 
FROM product
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT product_id, product_name, price, stock, product_status, sold_quantity 
FROM product
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

SELECT product_id, product_name, price, stock, product_status, sold_quantity 
FROM product
WHERE price < 2000000
ORDER BY sold_quantity DESC;