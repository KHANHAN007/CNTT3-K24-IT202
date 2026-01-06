USE SS07;

CREATE TABLE Products(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) CHECK(price >= 0)
);

CREATE TABLE Order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK(quantity > 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

INSERT INTO Products (id, name, price) VALUES
	(1, 'Laptop Asus', 15000000),
	(2, 'Điện thoại Samsung', 8000000),
	(3, 'Tai nghe Sony', 2000000),
	(4, 'Bàn phím cơ', 1500000),
	(5, 'Chuột Logitech', 700000),
	(6, 'Màn hình Dell', 5000000),
	(7, 'USB 16GB', 200000);

INSERT INTO Order_items (order_id, product_id, quantity) VALUES
	(101, 1, 1),
	(101, 3, 2),
	(102, 2, 1),
	(103, 1, 1),
	(103, 4, 1),
	(104, 5, 3),
	(105, 1, 2),
	(105, 2, 1),
	(105, 3, 1);
    

SELECT p.id, p.name
	FROM Products p
    WHERE p.id IN (
		SELECT DISTINCT oi.product_id
			FROM Order_items oi
    );
