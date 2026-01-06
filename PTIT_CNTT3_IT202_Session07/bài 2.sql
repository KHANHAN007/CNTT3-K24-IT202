use session_07_db;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(id)
);


INSERT INTO products (name, price) VALUES 
('Laptop Dell XPS', 25000000.00),     
('Chuột không dây', 150000.00),      
('Bàn phím cơ', 850000.00),           
('Tai nghe Gaming', 1200000.00),      
('Màn hình LG 24"', 3500000.00);      

INSERT INTO order_items (order_id, product_id, quantity) VALUES 
(1, 1, 1),  
(1, 2, 2),  
(2, 3, 1),  
(3, 1, 1);  

-- bai 2 
SELECT id, name, price
FROM products
WHERE id IN (
    SELECT  product_id 
    FROM order_items
);