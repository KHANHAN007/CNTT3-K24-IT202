USE SS05;

CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    city VARCHAR(255) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT('active')
);

SELECT * FROM Customers;

SELECT * FROM Customers
	WHERE city = 'TP.HCM';

SELECT * FROM Customers
	WHERE status = 'active' AND city = 'Hà Nội';

SELECT * FROM Customers
	ORDER BY SUBSTRING(fullname, ' ',-1 );