CREATE DATABASE Session07;

USE Session07;

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO customers (name, email) VALUES
	('Nguyen Van An', 'an@gmail.com'),
	('Tran Thi Binh', 'binh@gmail.com'),
	('Le Van Cuong', 'cuong@gmail.com'),
	('Pham Thi Dao', 'dao@gmail.com'),
	('Hoang Van Em', 'em@gmail.com'),
	('Do Thi Hoa', 'hoa@gmail.com'),
	('Vu Van Kien', 'kien@gmail.com');



INSERT INTO orders (customer_id, order_date, total_amount) VALUES
	(1, '2025-01-01', 150000),
	(1, '2025-01-10', 250000),
	(2, '2025-01-05', 300000),
	(3, '2025-01-07', 180000),
	(4, '2025-01-08', 220000),
	(2, '2025-01-12', 400000),
	(5, '2025-01-15', 500000);



SELECT c.id, c.name, c.email
	FROM customers c
	WHERE id IN (
		SELECT customer_id
		FROM orders
	);
            
