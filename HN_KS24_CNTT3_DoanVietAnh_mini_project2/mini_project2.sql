CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), 
(1, 3, '2024-03-05', '2024-03-10'), 
(2, 2, '2024-02-01', '2024-02-03'), 
(2, 5, '2024-04-15', '2024-04-18'), 
(3, 4, '2023-12-20', '2023-12-25'), 
(3, 6, '2024-05-01', '2024-05-06'), 
(4, 1, '2024-06-10', '2024-06-11'); 

-- PHẦN I – TRUY VẤN DỮ LIỆU CƠ BẢN 
-- ● Liệt kê tên khách và số điện thoại của tất cả khách hàng 
	select guest_name, phone
    from guests;
-- ● Liệt kê các loại phòng khác nhau trong khách sạn 
	select room_type from rooms;
-- ● Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần 
	select room_type, price_per_day from rooms 
    order by price_per_day asc;
-- ● Hiển thị các phòng có giá thuê lớn hơn 1.000.000 
	select room_type,price_per_day from rooms
    WHERE price_per_day > 1000000;
-- ● Liệt kê các lần đặt phòng diễn ra trong năm 2024 
	select guest_id,room_id,check_in,check_out from bookings
    WHERE year(check_in) = 2024;

-- PHẦN II – TRUY VẤN NÂNG CAO 
-- ● Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy 
-- hiển thị: 
-- ○ Tên khách hàng 
-- ○ Loại phòng đã đặt 
-- ○ Ngày nhận phòng (check_in) 
select  
		g.guest_name,
		r.room_type,
		b.check_in
from guests g 
join bookings b
	on g.guest_id = b.guest_id
join rooms r
	on b.room_id = r.room_id;
    
-- ● Cho biết mỗi khách đã đặt phòng bao nhiêu lần 
select  COUNT(g.guest_name) as 'TongSoLanDatPhong'
from  guests g
join booking b 
	on g.guest_id = b.guest_id
group by g.guest_name;
	
-- ● Tính doanh thu của mỗi phòng, với công thức: “Doanh thu = số ngày ở 
-- × giá thuê theo ngày” 

-- ● Hiển thị tổng doanh thu của từng loại phòng 

-- ● Tìm những khách đã đặt phòng từ 2 lần trở lên 
select g.guest_name, COUNT(g.guest_name) as 'TongSoLanDatPhong'
from  guests g
join booking b 
	on g.guest_id = b.guest_id
group by g.guest_name
having  TongSoLanDatPhong >= 2;
-- ● Tìm loại phòng có số lượt đặt phòng nhiều nhất
	
-- ● Cho biết số lượng phòng của từng loại phòng

-- PHẦN III – TRUY VẤN LỒNG 
-- ● Hiển thị những phòng có giá thuê cao hơn giá trung bình của tất cả 
-- các phòng 
-- ● Hiển thị những khách chưa từng đặt phòng 
-- ● Tìm phòng được đặt nhiều lần nhất