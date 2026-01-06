USE Session07;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

INSERT INTO products (name, price) VALUES
	('Laptop', 15000000),
	('Mouse', 200000),
	('Keyboard', 500000),
	('Monitor', 3000000),
	('Printer', 2500000),
	('Webcam', 800000),
	('Headphone', 1200000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
	(1, 1, 1),
	(1, 2, 2),
	(2, 3, 1),
	(2, 4, 1),
	(3, 2, 3),
	(3, 5, 1),
	(4, 1, 1);

SELECT p.id, p.name
	FROM Products p
    WHERE p.id IN (
		SELECT DISTINCT oi.product_id
			FROM Order_items oi
    );
