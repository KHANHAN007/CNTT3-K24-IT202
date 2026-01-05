use session_06_db;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,        -- Mã khách hàng
    customer_name VARCHAR(100),            -- Tên khách hàng
    email         VARCHAR(100),            -- Email
    city          VARCHAR(50)               -- Thành phố
);


/* =========================================================
   3. TẠO BẢNG SẢN PHẨM
   ========================================================= */

CREATE TABLE products (
    product_id   INT PRIMARY KEY,          -- Mã sản phẩm
    product_name VARCHAR(100),              -- Tên sản phẩm
    price        DECIMAL(12,2),              -- Giá bán
    category     VARCHAR(50)                -- Loại sản phẩm
);


/* =========================================================
   4. TẠO BẢNG ĐƠN HÀNG
   ========================================================= */

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,            -- Mã đơn hàng
    customer_id INT,                        -- Khách hàng đặt
    order_date  DATE,                       -- Ngày đặt hàng
    status      VARCHAR(30),                -- Trạng thái đơn
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


/* =========================================================
   5. TẠO BẢNG CHI TIẾT ĐƠN HÀNG
   ========================================================= */

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,          -- Mã chi tiết đơn
    order_id      INT,                      -- Mã đơn hàng
    product_id    INT,                      -- Mã sản phẩm
    quantity      INT,                      -- Số lượng
    unit_price    DECIMAL(12,2),             -- Giá bán tại thời điểm đặt
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


/* =========================================================
   6. DỮ LIỆU MẪU - KHÁCH HÀNG
   ========================================================= */

INSERT INTO customers VALUES
(1, 'Nguyen Van An',  'an@gmail.com',   'Ha Noi'),
(2, 'Tran Thi Binh',  'binh@gmail.com', 'Da Nang'),
(3, 'Le Van Cuong',   'cuong@gmail.com','Ho Chi Minh'),
(4, 'Pham Thi Dao',   'dao@gmail.com',  'Ha Noi'),
(5, 'Hoang Van Em',   'em@gmail.com',   'Can Tho');


/* =========================================================
   7. DỮ LIỆU MẪU - SẢN PHẨM
   ========================================================= */

INSERT INTO products VALUES
(1, 'Laptop Dell',          20000000, 'Electronics'),
(2, 'iPhone 15',            25000000, 'Electronics'),
(3, 'Tai nghe Bluetooth',    1500000, 'Accessories'),
(4, 'Chuột không dây',        500000, 'Accessories'),
(5, 'Bàn phím cơ',           2000000, 'Accessories');


/* =========================================================
   8. DỮ LIỆU MẪU - ĐƠN HÀNG
   ========================================================= */

INSERT INTO orders VALUES
(101, 1, '2025-01-05', 'Completed'),
(102, 2, '2025-01-06', 'Completed'),
(103, 3, '2025-01-07', 'Completed'),
(104, 1, '2025-01-08', 'Completed'),
(105, 4, '2025-01-09', 'Completed'),
(106, 5, '2025-01-10', 'Completed'),
(107, 2, '2025-01-11', 'Completed'),
(108, 3, '2025-01-12', 'Completed');


/* =========================================================
   9. DỮ LIỆU MẪU - CHI TIẾT ĐƠN HÀNG
   ========================================================= */

INSERT INTO order_items VALUES
-- Đơn 101
(1, 101, 1, 1, 20000000),
(2, 101, 3, 2, 1500000),

-- Đơn 102
(3, 102, 2, 1, 25000000),
(4, 102, 4, 1, 500000),

-- Đơn 103
(5, 103, 5, 2, 2000000),
(6, 103, 3, 1, 1500000),

-- Đơn 104
(7, 104, 1, 1, 20000000),
(8, 104, 5, 1, 2000000),

-- Đơn 105
(9, 105, 4, 3, 500000),

-- Đơn 106
(10, 106, 3, 5, 1500000),

-- Đơn 107
(11, 107, 2, 1, 25000000),
(12, 107, 3, 2, 1500000),

-- Đơn 108
(13, 108, 1, 1, 20000000),
(14, 108, 4, 2, 500000);

-- Câu 1.
SELECT 
    o.order_id, 
    c.customer_name, 
    o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Câu 2. 
SELECT 
    oi.order_id, 
    p.product_name, 
    oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id;

-- Câu 3. 
SELECT COUNT(order_id) AS total_orders 
FROM orders;

-- Câu 4.
SELECT SUM(quantity * unit_price) AS system_total_revenue 
FROM order_items;

-- Câu 5. 
SELECT 
    order_id, 
    SUM(quantity * unit_price) AS order_total_amount
FROM order_items
GROUP BY order_id;

-- Câu 6. 
SELECT 
    c.customer_id,
    c.customer_name, 
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name;

-- Câu 7. 
SELECT 
    p.product_id,
    p.product_name, 
    SUM(oi.quantity * oi.unit_price) AS product_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Câu 8. 
SELECT 
    c.customer_name, 
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(oi.quantity * oi.unit_price) > 5000000;

-- Câu 9. 
SELECT 
    p.product_name, 
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) > 100;

-- Câu 10. 
SELECT 
    c.city, 
    COUNT(o.order_id) AS total_orders_per_city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING COUNT(o.order_id) > 5;
