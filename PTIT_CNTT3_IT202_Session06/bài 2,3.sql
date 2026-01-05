use session_06_db;

ALTER TABLE orders 
ADD COLUMN total_amount DECIMAL(10, 2);

UPDATE orders SET total_amount = 1500000 WHERE order_id = 101; 
UPDATE orders SET total_amount = 550000  WHERE order_id = 102; 
UPDATE orders SET total_amount = 2200000 WHERE order_id = 103; 
UPDATE orders SET total_amount = 0       WHERE order_id = 104; 
UPDATE orders SET total_amount = 3500000 WHERE order_id = 105; 


-- Hiển thị tổng tiền mà mỗi khách hàng đã chi tiêu
SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Hiển thị giá trị đơn hàng cao nhất của từng khách
SELECT c.customer_id, c.full_name, MAX(o.total_amount) AS highest_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Sắp xếp danh sách khách hàng theo tổng tiền giảm dần
SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- Tính tổng doanh thu và số lượng đơn hàng theo từng ngày
SELECT order_date, SUM(total_amount) AS total_revenue,COUNT(order_id) AS order_count
FROM orders
GROUP BY order_date;

-- Chỉ hiển thị các ngày có doanh thu > 100000
SELECT order_date, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY order_date
HAVING SUM(total_amount) > 100000;