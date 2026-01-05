use session_06_db;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10, 2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);



INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop Dell', 15000000),
(2, 'Chuột Logitech', 500000),
(3, 'Bàn phím cơ', 1200000),
(4, 'Màn hình LG', 4500000),
(5, 'Tai nghe Sony', 2000000);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 10),  
(101, 2, 2),  
(102, 3, 1),  
(103, 4, 7),  
(105, 1, 4);

-- Hiển thị mỗi sản phẩm đã bán được bao nhiêu cái
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Tính doanh thu của từng sản phẩm (Giá * Số lượng)
SELECT p.product_name, SUM(oi.quantity * p.price) AS product_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Chỉ hiển thị các sản phẩm có doanh thu > 5.000.000
SELECT p.product_name, SUM(oi.quantity * p.price) AS product_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000;

-- Tìm khách hàng VIP (>= 3 đơn hàng VÀ tổng tiền > 10 triệu)
SELECT c.customer_id, c.full_name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent, AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 3 
   AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;

-- Báo cáo tổng hợp tình hình kinh doanh 
SELECT p.product_name, SUM(oi.quantity) AS total_quantity_sold, SUM(oi.quantity * p.price) AS total_revenue, AVG(p.price) AS average_price -- Vì bảng order_items không lưu giá lúc bán, nên giá trung bình chính là giá hiện tại
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.price
HAVING SUM(oi.quantity) >= 4
ORDER BY total_revenue DESC
LIMIT 5;