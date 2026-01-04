USE Session05;

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    stock INT NOT NULL,
    sold_quantity INT NOT NULL DEFAULT 0,
    status ENUM('active', 'inactive') NOT NULL
);

SELECT product_id, product_name, price, sold_quantity, status
	FROM products
	ORDER BY sold_quantity DESC
	LIMIT 10;

SELECT product_id, product_name, price, sold_quantity, status
	FROM products
	ORDER BY sold_quantity DESC
	LIMIT 5 OFFSET 10;

SELECT product_id, product_name, price, sold_quantity, status
	FROM products
	WHERE price < 2000000
	ORDER BY sold_quantity DESC;
