USE SS06;

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

INSERT INTO Products (product_name, price)
	VALUES
		('Laptop Dell', 20000000),
		('Laptop HP', 18000000),
		('Chuột Logitech', 500000),
		('Bàn phím cơ', 1500000),
		('Tai nghe Sony', 3000000);

INSERT INTO Order_Items (order_id, product_id, quantity)
	VALUES
		(1, 1, 2),
		(1, 3, 3),
		(2, 2, 1),
		(2, 4, 2),
		(3, 5, 5),
		(3, 3, 2),
		(4, 1, 1),
		(5, 4, 1); 
        
SELECT p.product_id, p.product_name, SUM(i.quantity) AS total_sold
	FROM Products p
    JOIN Order_items i ON p.product_id = i.product_id
    GROUP BY p.product_id, p.product_name;
    
SELECT p.product_id, p.product_name, SUM(i.quantity) AS total_sold, SUM(i.quantity * price) AS total_revenue
	FROM Products p
    JOIN Order_items i ON p.product_id = i.product_id
    GROUP BY p.product_id, p.product_name
    HAVING total_revenue > 5000000
