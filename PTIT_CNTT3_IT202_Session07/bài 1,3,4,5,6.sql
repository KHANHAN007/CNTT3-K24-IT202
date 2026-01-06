create database session_07_db;
use session_07_db;

create table customers (
	customer_id int primary key auto_increment,
    customer_name varchar(255) NOT NULL,
    email varchar(255) UNIQUE
);

create table orders(
	order_id int primary key auto_increment,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_name, email) VALUES 
('Nguyễn Văn An', 'an.nguyen@example.com'),
('Trần Thị Bình', 'binh.tran@example.com'),
('Lê Văn Cường', 'cuong.le@example.com'),
('Phạm Mỹ Duyên', 'duyen.pham@example.com'),
('Hoàng Văn Em', 'em.hoang@example.com'),
('Đỗ Thị Phương', 'phuong.do@example.com'),
('Vũ Văn Giang', 'giang.vu@example.com');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES 
(1, '2023-10-01', 1500000.00),  
(2, '2023-10-02', 500000.00),  
(1, '2023-10-05', 200000.00),   
(3, '2023-10-06', 7500000.00),  
(4, '2023-10-07', 120000.00),  
(5, '2023-10-08', 3400000.00), 
(2, '2023-10-09', 900000.00),
(6, '2023-10-10', 650000.00),   
(7, '2023-10-11', 2200000.00),  
(1, '2023-10-12', 450000.00),   
(3, '2023-10-14', 1250000.00),  
(6, '2023-10-15', 300000.00); 

-- bai 1
select  customer_id,customer_name,email
from customers 
WHERE customer_id IN (SELECT customer_id FROM orders);

-- bai 3 
select order_id, customer_id,order_date,total_amount
from orders
where total_amount > (select avg(total_amount) from orders);

-- bai 4 
select c.customer_name, (select count(*)
						from orders o
                        where o.customer_id = c.customer_id) as order_number
from customers c;
					
-- bai 5 
select  customer_id,customer_name,email
from customers 
where customer_id in (
-- Subquery cấp 1: Lấy ra customer_id có tổng tiền bằng với mức cao nhất
	select customer_id 
    from orders
    group by customer_id
    having sum(total_amount) =(
    -- Subquery cấp 2: Tìm con số tổng tiền lớn nhất (MAX) trong tất cả các khách
		select max(tong_tien)
        from(
        -- Subquery cấp 3 : Tính tổng tiền của từng khách
			select sum(total_amount) as tong_tien
            from orders
            group by customer_id
        ) as bang_tam
    )
);

-- bai 6 

SELECT customer_id, SUM(total_amount) AS tong_tien
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    -- Subquery tính trung bình cộng số tiền chi tiêu của các khách hàng
    SELECT AVG(tong_chi_tieu_moi_khach)
    FROM (
        -- Subquery con: Tính tổng tiền riêng của từng khách để làm dữ liệu tính AVG
        SELECT SUM(total_amount) AS tong_chi_tieu_moi_khach
        FROM orders
        GROUP BY customer_id
    ) AS bang_tam
);





