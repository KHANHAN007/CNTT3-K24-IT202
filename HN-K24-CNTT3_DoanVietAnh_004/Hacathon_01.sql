-- tạo dữ liệu 
DROP DATABASE Hacathon_01;

CREATE DATABASE Hacathon_01;
USE Hacathon_01;

-- tạo bảng users 
create table users (
	user_id varchar(5) primary key not null, 
    user_name varchar(100) not null,
    user_email varchar(100) not null unique,
    user_phone varchar(15) not null unique
);

-- tạo bảng products 
create table products (
	product_id varchar(5) primary key not null,
    product_name varchar(150) not null,
    product_price decimal (10,2) not null,
    stock_quantity int not null
);

-- tạo bảng orders
 create table orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id varchar(5) NOT NULL,
    order_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL, 
    order_status VARCHAR(20) not null,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


-- tạo bảng Order_Detail
CREATE TABLE order_detail (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT not null ,
    product_id VARCHAR(5) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10 , 2),
    
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- thêm dữ liệu vào bảng users
INSERT INTO users (user_id, user_name, user_email, user_phone) VALUES
	('U001', 'Nguyễn Văn An' , 'an.nguyen@gmail.com' , '0912345678' ),
    ('U002','Trần Thị Bích','bich.tran@gmail.com', '0923456789'),
    ('U003','Lê Hoàng Minh','minh.le@gmail.com','0934567890'),
	('U004','Phạm Thu Hà','ha.pham@gmail.com','0945678901'),
	('U005','Võ Quốc Huy','huy.vo@gmail.com','0956789012');
    
-- thêm dữ liệu vào bảng products
INSERT INTO products (product_id, product_name, product_price, stock_quantity) VALUES
	('P001','Áo thun nam',199000,50),
    ('P002','Quần jean nữ',399000,40),
    ('P003','Giày sneaker',899000,30),
    ('P004','Túi xách thời trang',599000,20),
    ('P005','Đồng hồ đeo tay',1299000,15);
    
-- thêm dữ liệu vào bảng orders
INSERT INTO orders (user_id,order_date,total_price,order_status) VALUES
	('U001','2025-03-01',1098000,'Completed'),
    ('U002','2025-03-02',399000,'Completed'),
	('U003','2025-03-03',1798000,'Processing'),
	('U001','2025-03-04',599000,'Cancelled'),
	('U004','2025-03-05',1299000,'Pending');
    
-- thêm dữ liệu vào bảng order_detail
INSERT INTO order_detail (order_detail_id,order_id,product_id,quantity,unit_price) VALUES
	(1,1,'P001',2,199000),
	(2,2,'P003',1,899000),
	(3,3,'P002',1,399000),
	(4,4,'P005',1,1299000),
	(5,5,'P004',1,599000);
    
-- Cập nhật thông tin người dùng. Hãy viết câu lệnh cập nhật số điện thoại của người dùng có user_id = 'U003' thành "096532628".
update users
set user_phone = '096532628'
where user_id = 'U003';
-- cập nhật order_status thành "Cancelled".
update orders
set order_status = 'Cancelled'
where order_id = 3;
-- Viết câu lệnh xóa tất cả các bản ghi trong bảng Order có order_status là "Cancelled" và order_date trước ngày "2025-03-04".
delete  
from orders
where order_status = 'Cancelled' and order_date > "2025-03-04";

-- PHẦN 2: Truy vấn dữ liệu cơ bản
-- 6.Liệt kê danh sách các đơn hàng gồm các cột: order_id, order_date, order_status có trạng thái là 'Completed' và ngày đặt hàng sau ngày “2025-03-01”.
SELECT order_id, order_date, order_status
FROM orders
WHERE order_status = 'Completed' AND order_date > '2025-03-01';

-- 7.Lấy thông tin user_name, user_phone, user_email, của những người dùng có số điện thoại bắt đầu bằng “09”.
SELECT user_name, user_phone, user_email
FROM users
WHERE user_phone LIKE '09%';
-- 8.Hiển thị danh sách tất cả các đơn hàng gồm: order_id, user_id, order_date. Kết quả sắp xếp theo (order_date) giảm dần.
SELECT order_id, user_id, order_date
FROM orders
ORDER BY order_date DESC;
-- 9.Lấy 3 bản ghi đầu tiên trong bảng Order có order_status là 'Completed'.
SELECT order_id, user_id, order_date
FROM orders
WHERE order_status = 'Completed'
LIMIT 3;
-- 10.Hiển thị thông tin gồm mã người dùng (user_id) và tên người dùng (user_name) từ bảng User, bỏ qua 2 bản ghi đầu tiên và lấy 3 bản ghi tiếp theo (sử dụng LIMIT và OFFSET).
SELECT user_id, user_name
FROM users
LIMIT 3 OFFSET 2;

-- PHẦN 3: Truy vấn dữ liệu nâng cao
-- 11.Hiển thị danh sách đơn hàng gồm: order_id, user_name (từ bảng User), order_date và total_price. Chỉ lấy những đơn hàng có order_status = 'Completed'.
SELECT o.order_id, u.user_name, o.order_date, o.total_price
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.order_status = 'Completed';
-- 12.Liệt kê tất cả các sản phẩm trong hệ thống gồm: product_id, product_name và order_id tương ứng (nếu có). Kết quả phải bao gồm cả những sản phẩm chưa từng được bán.
SELECT p.product_id, p.product_name, od.order_id
FROM products p
LEFT JOIN Order_Detail od ON p.product_id = od.product_id;
-- 13.Tính tổng số đơn hàng theo từng (order_status). Kết quả hiển thị 2 cột: order_status và Total_Order.
SELECT order_status, COUNT(order_id) AS Total_Order
FROM orders
GROUP BY order_status;
-- 14.Thống kê số lượng đơn hàng của mỗi người dùng. Hiển thị user_id và Count_Order. Chỉ hiện những người dùng có từ 2 đơn hàng trở lên.
SELECT user_id, COUNT(order_id) AS Count_Order
FROM orders
GROUP BY user_id
HAVING Count_Order >= 2;

-- 15.Lấy thông tin các đơn hàng gồm: (order_id, order_date, total_price) có total_price lớn hơn giá trị trung bình của tất cả các đơn hàng trong bảng Order.
SELECT order_id, order_date, total_price
FROM orders
WHERE total_price > (SELECT AVG(total_price) FROM orders);


-- 16.Hiển thị user_name và user_phone ủa những người dùng đã từng mua sản phẩm có product_name là “Giày sneaker”.

-- 17.Hiển thị thông tin tổng hợp gồm: order_id, user_name, product_name, quantity và unit_price.
SELECT o.order_id, u.user_name, p.product_name, od.quantity, od.unit_price
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN Order_Detail od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;
    




