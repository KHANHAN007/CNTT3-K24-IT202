use session_06_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    city VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


INSERT INTO customers (customer_id, full_name, city) VALUES
(1, 'Nguyễn Văn A', 'Hà Nội'),
(2, 'Trần Thị B', 'Hồ Chí Minh'),
(3, 'Lê Văn C', 'Đà Nẵng'),
(4, 'Phạm Thị D', 'Cần Thơ'),      
(5, 'Hoàng Văn E', 'Hải Phòng');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(101, 1, '2023-10-01', 'completed'), 
(102, 1, '2023-10-05', 'pending'),   
(103, 2, '2023-10-10', 'completed'), 
(104, 3, '2023-10-12', 'cancelled'), 
(105, 5, '2023-10-15', 'completed'); 

SELECT 
    o.order_id, 
    c.full_name, 
    o.order_date, 
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;


SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.customer_id, c.full_name,COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;