-- 2.1 Tạo cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS quanlybanhang;
USE quanlybanhang;

-- 2.2 Tạo các bảng
-- Bảng Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255) NULL
);

-- Bảng Products
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(50) NOT NULL
);

-- Bảng Employees
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    revenue DECIMAL(10,2) DEFAULT 0
);

-- Bảng Orders
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Bảng OrderDetails
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 3.1 Thêm cột email vào bảng Customers
-- Lưu ý: Vì bảng chưa có dữ liệu nên thêm NOT NULL không gây lỗi.
ALTER TABLE Customers
ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;

-- 3.2 Xóa cột birthday khỏi bảng Employees
ALTER TABLE Employees
DROP COLUMN birthday;

-- Chèn dữ liệu Customers (5 bản ghi)
INSERT INTO Customers (customer_name, phone, address, email) VALUES
('Nguyen Van A', '0901234567', 'Ha Noi', 'vana@example.com'),
('Tran Thi B', '0902345678', 'Ho Chi Minh', 'thib@example.com'),
('Le Van C', '0903456789', 'Da Nang', 'vanc@example.com'),
('Pham Thi D', '0904567890', 'Can Tho', 'thid@example.com'),
('Hoang Van E', '0905678901', 'Hai Phong', 'vane@example.com');

-- Chèn dữ liệu Products (5 bản ghi)
INSERT INTO Products (product_name, price, quantity, category) VALUES
('Laptop Dell XPS', 1500.00, 50, 'Laptop'), -- Sẽ dùng cho câu 5.2
('iPhone 15 Pro', 1200.00, 200, 'Phone'),
('Samsung Galaxy S24', 1100.00, 150, 'Phone'),
('Macbook Air M2', 1300.00, 30, 'Laptop'),
('Sony WH-1000XM5', 300.00, 100, 'Accessories');

-- Chèn dữ liệu Employees (5 bản ghi) - Không có cột birthday
INSERT INTO Employees (employee_name, position, salary, revenue) VALUES
('Nguyen Nhan Vien 1', 'Sales', 1000.00, 0),
('Tran Nhan Vien 2', 'Manager', 2000.00, 0),
('Le Nhan Vien 3', 'Sales', 1100.00, 0),
('Pham Nhan Vien 4', 'Marketing', 1200.00, 0),
('Do Nhan Vien 5', 'Intern', 500.00, 0);

-- Chèn dữ liệu Orders (5 bản ghi)
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 1, NOW(), 2700.00),
(2, 1, NOW(), 1200.00),
(3, 2, '2023-12-01 10:00:00', 300.00), -- Đơn hàng năm ngoái để test thống kê
(1, 3, NOW(), 1300.00),
(4, 2, NOW(), 0.00); -- Đơn hàng chưa tính tiền

-- Chèn dữ liệu OrderDetails (5 bản ghi)
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1500.00),
(1, 2, 1, 1200.00),
(2, 2, 1, 1200.00),
(3, 5, 1, 300.00),
(4, 4, 1, 1300.00);

-- 5.1 Lấy danh sách khách hàng
SELECT customer_id, customer_name, email, phone, address 
FROM Customers;

-- 5.2 Sửa thông tin sản phẩm (product_id = 1)
UPDATE Products
SET product_name = 'Laptop Dell XPS', price = 99.99
WHERE product_id = 1;

-- 5.3 Lấy thông tin đơn hàng chi tiết
SELECT 
    o.order_id, 
    c.customer_name, 
    e.employee_name, 
    o.total_amount, 
    o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id;

-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng
SELECT 
    c.customer_id, 
    c.customer_name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại
-- Lưu ý: Tính doanh thu dựa trên bảng Orders mà nhân viên đó phụ trách
SELECT 
    e.employee_id, 
    e.employee_name, 
    COALESCE(SUM(o.total_amount), 0) AS yearly_revenue
FROM Employees e
LEFT JOIN Orders o ON e.employee_id = o.employee_id 
    AND YEAR(o.order_date) = YEAR(CURDATE())
GROUP BY e.employee_id, e.employee_name;

-- 6.3 Thống kê sản phẩm có số lượng đặt hàng > 100 trong tháng hiện tại
-- Do dữ liệu mẫu ít, bạn có thể chỉnh điều kiện > 100 thành > 0 để test kết quả
SELECT 
    p.product_id, 
    p.product_name, 
    SUM(od.quantity) AS total_ordered
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
JOIN Orders o ON od.order_id = o.order_id
WHERE MONTH(o.order_date) = MONTH(CURDATE()) 
  AND YEAR(o.order_date) = YEAR(CURDATE())
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) > 100
ORDER BY total_ordered DESC;

-- 7.1 Khách hàng chưa từng đặt hàng
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM Orders);

-- 7.2 Sản phẩm có giá cao hơn giá trung bình
SELECT * FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- 7.3 Khách hàng có mức chi tiêu cao nhất (xử lý trường hợp đồng hạng)
WITH CustomerSpending AS (
    SELECT 
        c.customer_id, 
        c.customer_name, 
        SUM(o.total_amount) AS total_spending
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_spending
FROM CustomerSpending
WHERE total_spending = (SELECT MAX(total_spending) FROM CustomerSpending);

-- 8.1 View view_order_list
CREATE VIEW view_order_list AS
SELECT 
    o.order_id, 
    c.customer_name, 
    e.employee_name, 
    o.total_amount, 
    o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC;

-- 8.2 View view_order_detail_product
CREATE VIEW view_order_detail_product AS
SELECT 
    od.order_detail_id, 
    p.product_name, 
    od.quantity, 
    od.unit_price
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
ORDER BY od.quantity DESC;

DELIMITER //

-- 9.1 Thêm nhân viên mới và trả về ID
CREATE PROCEDURE proc_insert_employee(
    IN p_name VARCHAR(100),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    OUT p_new_id INT
)
BEGIN
    INSERT INTO Employees (employee_name, position, salary, revenue)
    VALUES (p_name, p_position, p_salary, 0);
    
    SET p_new_id = LAST_INSERT_ID();
END //

-- 9.2 Lấy chi tiết đơn hàng theo mã đơn hàng
CREATE PROCEDURE proc_get_orderdetails(IN p_order_id INT)
BEGIN
    SELECT * FROM OrderDetails WHERE order_id = p_order_id;
END //

-- 9.3 Đếm số lượng loại sản phẩm trong đơn hàng
-- Lưu ý: Đề bài yêu cầu "trả về số lượng loại sản phẩm", dù tên hàm là "cal_total_amount"
CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT,
    OUT p_product_type_count INT
)
BEGIN
    SELECT COUNT(DISTINCT product_id) INTO p_product_type_count
    FROM OrderDetails
    WHERE order_id = p_order_id;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    -- Lấy số lượng tồn kho hiện tại
    SELECT quantity INTO current_stock 
    FROM Products 
    WHERE product_id = NEW.product_id;
    
    -- Kiểm tra tồn kho
    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        -- Cập nhật kho (Nếu là BEFORE trigger thì ta update ở đây luôn để đảm bảo logic)
        -- Tuy nhiên đề bài yêu cầu tên trigger là "after_insert...",
        -- nhưng để ngăn chặn chèn (hủy thao tác) thì dùng BEFORE là tốt nhất.
        -- Nếu bắt buộc dùng AFTER, ta phải dùng SIGNAL để rollback transaction.
        -- Ở đây tôi dùng BEFORE để tối ưu logic ngăn chặn.
        UPDATE Products 
        SET quantity = quantity - NEW.quantity 
        WHERE product_id = NEW.product_id;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    -- Khai báo biến để xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Nếu có lỗi, rollback và thông báo
        ROLLBACK;
        SELECT 'Lỗi: Đã xảy ra lỗi trong quá trình xử lý (Transaction Rollback)' AS Message;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- 1. Kiểm tra mã hóa đơn tồn tại
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE order_id = p_order_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
    END IF;

    -- 2. Chèn dữ liệu vào bảng order_details
    -- (Trigger ở câu 10 sẽ tự động chạy để trừ kho hoặc báo lỗi nếu thiếu hàng)
    INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
    VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);

    -- 3. Cập nhật tổng tiền của đơn hàng
    UPDATE Orders
    SET total_amount = total_amount + (p_quantity * p_unit_price)
    WHERE order_id = p_order_id;

    -- Nếu mọi thứ ok, commit
    COMMIT;
    SELECT 'Thêm chi tiết đơn hàng thành công' AS Message;

END //

DELIMITER ;
-- Giả sử Order ID 1 tồn tại, Product ID 1 còn hàng
CALL proc_insert_order_details(1, 1, 1, 1500.00); 
-- Kiểm tra lại bảng Orders xem total_amount có tăng lên không và bảng Products xem quantity có giảm không.

-- Thử mua số lượng lớn hơn tồn kho (ví dụ 1000 cái)
CALL proc_insert_order_details(1, 1, 1000, 1500.00); 
-- Kết quả mong đợi: Thông báo lỗi "Số lượng sản phẩm trong kho không đủ". 