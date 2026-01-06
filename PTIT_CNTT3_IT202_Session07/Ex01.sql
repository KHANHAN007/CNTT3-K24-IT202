DROP DATABASE SS07;
CREATE DATABASE SS07;

USE SS07;

CREATE TABLE Customers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(id),
    order_date DATE DEFAULT(CURRENT_DATE),
    total_amount INT CHECK(total_amount > 0)
);

INSERT INTO customers (id, name, email) VALUES
	(1, 'Nguyen Van An', 'an.nguyen@gmail.com'),
	(2, 'Tran Thi Binh', 'binh.tran@yahoo.com'),
	(3, 'Le Van Cuong', 'cuong.le@gmail.com'),
	(4, 'Pham Thi Dao', 'dao.pham@gmail.com'),
	(5, 'Hoang Van Dung', 'dung.hoang@gmail.com'),
	(6, 'Nguyen Thi Hoa', 'hoa.nguyen@gmail.com'),
	(7, 'Tran Van Kien', 'kien.tran@gmail.com');


INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
	(101, 1, '2026-01-01', 1500000),
	(102, 2, '2026-01-02', 2000000),
	(103, 1, '2026-01-03', 500000),
	(104, 3, '2026-01-04', 1200000),
	(105, 4, '2026-01-05', 800000),
	(106, 2, '2026-01-06', 700000),
	(107, 5, '2026-01-07', 900000);


SELECT c.id, c.name, c.email
	FROM Customers c
    WHERE id IN (
		SELECT DISTINCT customer_id
			FROM Orders
            );
            
