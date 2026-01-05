USE Session06;

CREATE TABLE Products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK(price >= 0)
);

CREATE TABLE Order_items(
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    quantity INT check(quantity > 0)
);

INSERT INTO products (product_id, product_name, price) VALUES
	(1, 'Laptop Asus', 15000000),
	(2, 'Điện thoại Samsung', 8000000),
	(3, 'Tai nghe Sony', 2000000),
	(4, 'Bàn phím cơ', 1500000),
	(5, 'Chuột Logitech', 700000);


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(101, 3, 2),
(102, 2, 1),
(103, 1, 1),
(103, 4, 1),
(104, 5, 3),
(105, 1, 2),
(105, 2, 1),
(105, 3, 1);

SELECT p.product_name, SUM(oi.quantity) AS total_sold
	FROM products p
	JOIN order_items oi ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name
	ORDER BY total_sold DESC;

    
SELECT p.product_name, 
       SUM(oi.quantity * p.price) AS total_revenue
	FROM products p
	JOIN order_items oi ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name
	ORDER BY total_revenue DESC;

SELECT p.product_name, 
       SUM(oi.quantity * p.price) AS total_revenue
	FROM products p
	JOIN order_items oi ON p.product_id = oi.product_id
	GROUP BY p.product_id, p.product_name
	HAVING SUM(oi.quantity * p.price) > 5000000
	ORDER BY total_revenue DESC;

