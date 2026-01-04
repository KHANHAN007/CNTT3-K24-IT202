USE Session05;

SELECT product_id, product_name, price, stock, product_status, sold_quantity
FROM product
WHERE product_status = 'active' 
  AND price BETWEEN 1000000 AND 300000000
ORDER BY price ASC
LIMIT 10;

SELECT product_id, product_name, price, stock, product_status, sold_quantity
FROM product
WHERE product_status = 'active' 
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;