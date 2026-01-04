use Session05;

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES 
(1, 2000000, '2024-03-01', 'completed'),
(2, 6500000, '2024-03-02', 'pending'),    
(1, 150000, '2024-03-03', 'cancelled'),
(3, 8000000, '2024-03-04', 'completed'),   
(4, 500000, '2024-03-05', 'completed'),
(2, 12000000, '2024-03-06', 'pending');    

select * from orders 
where status = 'completed';

select * from orders 
where total_amount > 5000000;

select * from orders 
order by order_date desc
limit 5;

select * from orders 
where status = 'completed' 
order by total_amount desc;