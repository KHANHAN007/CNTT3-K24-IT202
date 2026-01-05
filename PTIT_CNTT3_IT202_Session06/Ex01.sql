CREATE DATABASE SS06;

USE SS06;

CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE Orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    order_date DATE DEFAULT(CURRENT_DATE),
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO Customers(full_name, city)
	VALUE 	('Nguyễn Văn An', 'Hà Nội'),
			('Trần Thị Bình', 'TP.HCM'),
			('Lê Hoàng Cường', 'Đà Nẵng'),
			('Phạm Minh Đức', 'Hà Nội'),
			('Vũ Thu Hà', 'Hải Phòng');

INSERT INTO Orders(customer_id, order_date, status)
	VALUE	(1, '2025-10-01', 'completed'),
			(1, '2025-10-05', 'pending'),
			(2, '2025-10-03', 'completed'),
			(3, '2025-10-07', 'cancelled'),
			(4, '2025-10-08', 'completed');
            
SELECT o.order_id, c.full_name, o.order_date, o.status
	FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id;
    
SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS TOTAL_AMOUNT
    FROM Customers c
    JOIN Orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id;
    
SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS TOTAL_AMOUNT
	FROM Customers c
    JOIN Orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id
    HAVING TOTAL_AMOUNT >= 1;