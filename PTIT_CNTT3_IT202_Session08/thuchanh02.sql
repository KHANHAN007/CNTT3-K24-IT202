CREATE DATABASE thuchanh02;

USE thuchanh02;

CREATE TABLE Customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone CHAR(10) NOT NULL UNIQUE CHECK (phone REGEXP '^[0-9]{10}$')
);

CREATE TABLE Categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Products(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK(price > 0),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(id)
);

CREATE TABLE Orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT(CURRENT_DATE),
    status ENUM('Pending', 'Completed', 'Cancel'),
    FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

CREATE TABLE Order_items(
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity int NOT NULL CHECK(quantity > 0),

    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);


INSERT INTO Customers (name, email, phone) VALUES
	('Nguyen Van An', 'an@gmail.com', '0912345678'),
	('Tran Thi Binh', 'binh@gmail.com', '0987654321'),
	('Le Minh Chau', 'chau@gmail.com', '0901122334'),
	('Pham Quoc Dung', 'dung@gmail.com', '0933445566'),
	('Hoang Thi Lan', 'lan@gmail.com', '0977889900');

INSERT INTO Categories (name) VALUES
	('Điện thoại'),
	('Laptop'),
	('Phụ kiện');


INSERT INTO products (name, price, category_id) VALUES
	('iPhone 15', 25000000, 1),
	('Samsung Galaxy S23', 20000000, 1),
	('Xiaomi Redmi Note 13', 7000000, 1),

	('MacBook Air M2', 28000000, 2),
	('Dell XPS 13', 26000000, 2),

	('Tai nghe Bluetooth', 1500000, 3),
	('Chuột không dây', 800000, 3),
	('Bàn phím cơ', 2000000, 3);



INSERT INTO orders (customer_id, status) VALUES
	(1, 'Completed'),
	(1, 'Completed'),
	(2, 'Pending'),
	(3, 'Completed'),
	(4, 'Cancel'),
	(5, 'Completed');


INSERT INTO order_items (order_id, product_id, quantity) VALUES
	-- Order 1
	(1, 1, 2),   -- iPhone 15
	(1, 6, 1),   -- Tai nghe

	-- Order 2
	(2, 2, 1),   -- Samsung S23
	(2, 7, 2),   -- Chuột không dây

	-- Order 3
	(3, 3, 3),   -- Xiaomi
	(3, 6, 2),   -- Tai nghe

	-- Order 4
	(4, 4, 1),   -- MacBook
	(4, 8, 1),   -- Bàn phím cơ

	-- Order 5 (bị huỷ)
	(5, 5, 1),   -- Dell XPS

	-- Order 6
	(6, 1, 1),
	(6, 2, 1),
	(6, 6, 3);

-- Danh sách khách hàng
SELECT c.id, c.name, c.email, c.phone
	FROM Customers c;
    
-- Danh sách sản phẩm
SELECT p.id, p.name, p.price, (SELECT c.name
								FROM Categories c
								WHERE p.category_id = c.id) as category_name
	FROM Products p;

-- Danh sách đơn hàng
SELECT o.id, 
		(SELECT c.name
			FROM Customers c
			WHERE c.id= o.customer_id) AS customer_name,
		o.order_date,
        o.status
	FROM Orders o;

-- Danh sách danh mục sản phẩm
SELECT id, name
	FROM Categories;

-- Danh sách đơn hàng có trạng thái Completed
SELECT o.id, 
		(SELECT c.name
			FROM Customers c
			WHERE c.id= o.customer_id) AS customer_name,
		o.order_date,
        o.status
	FROM Orders o
    WHERE status = 'Completed';
    
-- Thống kê số lương đơn hàng
SELECT COUNT(o.id), o.status
	FROM Orders o
    GROUP BY o.status;
    
-- Thống kê số lương đơn hàng bán ra
SELECT p.id, p.name, (SELECT SUM(oi.quantity)
						FROM Order_items oi
						WHERE p.id = oi.product_id) AS total_quantity
	FROM Products p;
    
-- Thống kê sản phẩm có giá cao nhất
SELECT p.id, p.name
	FROM Products p
    WHERE p.price = (SELECT MAX(p.price)
						FROM Products p);
                        
-- Thống kê sản phẩm có giá thấp nhất
SELECT p.id, p.name
	FROM Products p
    WHERE p.price = (SELECT MIN(p.price)
						FROM Products p);
					
-- Thống kê sản phẩm có giá thấp nhất
SELECT AVG(p.price)
	FROM Products p;

-- Danh sách sản phầm cà sắp xếp theo giá giảm dần
SELECT p.id, p.name, p.price
	FROM Products p
	ORDER BY price DESC;

-- Lấy 5 sản phầm có giá cao nhất, bỏ qua 2 sản phẩm đầu
SELECT p.id, p.name, p.price
	FROM Products p
	ORDER BY price DESC
	LIMIT 5 OFFSET 2;

-- Tìm khách hàng mua nhiều đơn hàng
SELECT c.name
	FROM Customers c
    WHERE c.id = (SELECT o.customer_id
					FROM Orders o
					GROUP BY o.customer_id
                    ORDER BY COUNT(o.id) DESC 
                    LIMIT 1);
                    
SELECT c.name
	FROM Customers c
    WHERE c.id IN (SELECT o.customer_id
					FROM Orders o 
                    GROUP BY o.customer_id
                    HAVING COUNT(o.id) = (SELECT MAX(order_count)
											FROM(SELECT COUNT(o.id) AS order_count
													FROM Orders o
                                                    GROUP BY o.customer_id
                                            ) t
										)
				);
                
-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN
-- Lấy danh sách tất cả danh mục sản phẩm
SELECT id, name
	FROM Categories;
    
-- Danh sách đơn hàng có trạng thái Completed
SELECT o.id, 
		(SELECT c.name
			FROM Customers c
			WHERE c.id= o.customer_id) AS customer_name,
		o.order_date,
        o.status
	FROM Orders o
    WHERE status = 'Completed';
    
-- Danh sách sản phầm cà sắp xếp theo giá giảm dần
SELECT p.id, p.name, p.price
	FROM Products p
	ORDER BY price DESC;
    
-- Lấy 5 sản phầm có giá cao nhất, bỏ qua 2 sản phẩm đầu
SELECT p.id, p.name, p.price
	FROM Products p
	ORDER BY price DESC
	LIMIT 5 OFFSET 2;
    
    
    
    
-- PHẦN B – TRUY VẤN NÂNG CAO

-- Lấy danh sách sản phẩm kèm tên danh mục
SELECT p.id, p.name, p.price, c.name AS category_name
	FROM Products p
	JOIN Categories c ON p.category_id = c.id;

-- Lấy danh sách đơn hàng gồm order_id, order_date, customer_name, status
SELECT o.id AS order_id,
       o.order_date,
       c.name AS customer_name,
       o.status
	FROM Orders o
	JOIN Customers c ON o.customer_id = c.id;

-- Tính tổng số lượng sản phẩm trong từng đơn hàng
SELECT o.id AS order_id,
       SUM(oi.quantity) AS total_quantity
	FROM Orders o
	JOIN Order_items oi ON o.id = oi.order_id
	GROUP BY o.id;

-- Thống kê số đơn hàng của mỗi khách hàng
SELECT c.id, c.name, COUNT(o.id) AS total_orders
	FROM Customers c
	LEFT JOIN Orders o ON c.id = o.customer_id
	GROUP BY c.id, c.name;

-- Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
SELECT c.id, c.name
	FROM Customers c
	JOIN Orders o ON c.id = o.customer_id
	GROUP BY c.id, c.name
	HAVING COUNT(o.id) >= 2;


-- Thống kê giá trung bình, thấp nhất, cao nhất theo danh mục
SELECT c.name AS category_name,
       AVG(p.price) AS avg_price,
       MIN(p.price) AS min_price,
       MAX(p.price) AS max_price
	FROM Categories c
	JOIN Products p ON c.id = p.category_id
	GROUP BY c.id, c.name;


-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY)
-- Sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT p.id, p.name, p.price
	FROM Products p
	WHERE p.price > (
		SELECT AVG(p.price)
		FROM Products p
	);

-- Khách hàng đã từng đặt ít nhất một đơn hàng
SELECT c.name
	FROM Customers c
	WHERE c.id IN (
		SELECT DISTINCT o.customer_id
		FROM Orders o
	);

-- Đơn hàng có tổng số lượng sản phẩm lớn nhất
SELECT oi.order_id
	FROM Order_items oi
	GROUP BY oi.order_id
	HAVING SUM(oi.quantity) = (
		SELECT MAX(total_qty)
		FROM (
			SELECT SUM(oi.quantity) AS total_qty
			FROM Order_items oi
			GROUP BY oi.order_id
		) t
	);

-- Tên khách hàng mua sản phẩm thuộc danh mục có GIÁ TRUNG BÌNH CAO NHẤT
SELECT DISTINCT c.name
	FROM Customers c
	JOIN Orders o ON c.id = o.customer_id
	JOIN Order_items oi ON o.id = oi.order_id
	JOIN Products p ON oi.product_id = p.id
	WHERE p.category_id = (
		SELECT category_id
		FROM Products
		GROUP BY category_id
		HAVING AVG(price) = (
			SELECT MAX(avg_price)
			FROM (
				SELECT AVG(price) AS avg_price
				FROM Products
				GROUP BY category_id
			) x
		)
	);

-- Từ bảng tạm, thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
SELECT customer_id, SUM(total_quantity) AS total_products
	FROM (
		SELECT o.customer_id, oi.quantity AS total_quantity
		FROM Orders o
		JOIN Order_items oi ON o.id = oi.order_id
	) t
	GROUP BY customer_id;


-- Viết lại truy vấn sản phẩm có giá cao nhất
SELECT p.id, p.name, p.price
	FROM Products p
	WHERE p.price = (
		SELECT MAX(p.price)
		FROM Products p
	);
