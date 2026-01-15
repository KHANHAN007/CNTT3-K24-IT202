CREATE DATABASE Session14;
USE Session14;

-- Bai 1 : 
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL,
    balance DECIMAL(10,2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO accounts (account_name, balance) VALUES
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

DELIMITER //
CREATE PROCEDURE transfer_money (
    IN from_account INT,
    IN to_account INT,
    IN amount DECIMAL(10,2)
)
BEGIN
    DECLARE from_balance DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT balance
    INTO from_balance
    FROM accounts
    WHERE account_id = from_account
    FOR UPDATE;

    IF from_balance IS NULL THEN
        ROLLBACK;
    ELSEIF from_balance < amount THEN
        ROLLBACK;
    ELSE
        UPDATE accounts
        SET balance = balance - amount
        WHERE account_id = from_account;

        UPDATE accounts
        SET balance = balance + amount
        WHERE account_id = to_account;

        COMMIT;
    END IF;
END //

DELIMITER ;

CALL transfer_money(1, 2, 200.00);

SELECT account_id, account_name, balance FROM accounts;

-- Bai 2 :
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, stock) VALUES
('Laptop', 10),
('Chuột máy tính', 20);

DELIMITER //

CREATE PROCEDURE place_order (
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE current_stock INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT stock
    INTO current_stock
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF current_stock IS NULL THEN
        ROLLBACK;
    ELSEIF current_stock < p_quantity THEN
        ROLLBACK;
    ELSE
        INSERT INTO orders (product_id, quantity)
        VALUES (p_product_id, p_quantity);

        UPDATE products
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        COMMIT;
    END IF;
END //

DELIMITER ;

CALL place_order(1, 3);

SELECT product_id, product_name, stock FROM products;
SELECT order_id, product_id, quantity, order_date FROM orders;

-- Bai 3 :
CREATE TABLE company_funds (
    fund_id INT AUTO_INCREMENT PRIMARY KEY,
    balance DECIMAL(12,2) NOT NULL
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

CREATE TABLE payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    salary_paid DECIMAL(10,2) NOT NULL,
    paid_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO company_funds (balance) VALUES (5000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn A', 1000.00),
('Trần Thị B', 1500.00);

DELIMITER //

CREATE PROCEDURE pay_salary (
    IN p_emp_id INT
)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(12,2);
    DECLARE bank_status INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT salary
    INTO v_salary
    FROM employees
    WHERE emp_id = p_emp_id;

    SELECT balance
    INTO v_balance
    FROM company_funds
    WHERE fund_id = 1
    FOR UPDATE;

    IF v_balance < v_salary THEN
        ROLLBACK;
    ELSE
        UPDATE company_funds
        SET balance = balance - v_salary
        WHERE fund_id = 1;

        INSERT INTO payroll (emp_id, salary_paid)
        VALUES (p_emp_id, v_salary);

        SET bank_status = 1;

        IF bank_status = 0 THEN
            ROLLBACK;
        ELSE
            COMMIT;
        END IF;
    END IF;
END //

DELIMITER ;

CALL pay_salary(1);

SELECT fund_id, balance FROM company_funds;
SELECT emp_id, emp_name, salary FROM employees;
SELECT payroll_id, emp_id, salary_paid, paid_date FROM payroll;

-- Bai 4 : 

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enroll_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (student_name) VALUES
('Nguyễn Văn A'),
('Trần Thị B');

INSERT INTO courses (course_name, available_seats) VALUES
('Cơ sở dữ liệu', 2),
('Lập trình Java', 0);

DELIMITER //

CREATE PROCEDURE register_course (
    IN p_student_name VARCHAR(50),
    IN p_course_name VARCHAR(100)
)
BEGIN
    DECLARE v_student_id INT;
    DECLARE v_course_id INT;
    DECLARE v_seats INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT student_id
    INTO v_student_id
    FROM students
    WHERE student_name = p_student_name;

    SELECT course_id, available_seats
    INTO v_course_id, v_seats
    FROM courses
    WHERE course_name = p_course_name
    FOR UPDATE;

    IF v_seats > 0 THEN
        INSERT INTO enrollments (student_id, course_id)
        VALUES (v_student_id, v_course_id);

        UPDATE courses
        SET available_seats = available_seats - 1
        WHERE course_id = v_course_id;

        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END //

DELIMITER ;

CALL register_course('Nguyễn Văn A', 'Cơ sở dữ liệu');

SELECT student_id, student_name FROM students;
SELECT course_id, course_name, available_seats FROM courses;
SELECT enrollment_id, student_id, course_id, enroll_date FROM enrollments;

-- Bai 5 : 
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username) VALUES
('user_a'),
('user_b');

START TRANSACTION;

INSERT INTO posts (user_id, content)
VALUES (1, 'Bài viết đầu tiên của user_a');

UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 1;

COMMIT;

START TRANSACTION;

INSERT INTO posts (user_id, content)
VALUES (999, 'Bài viết lỗi do user không tồn tại');

UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 999;

ROLLBACK;

SELECT user_id, username, posts_count FROM users;
SELECT post_id, user_id, content, created_at FROM posts;

-- Bai 6 :  
ALTER TABLE posts
ADD COLUMN likes_count INT DEFAULT 0;

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    UNIQUE KEY unique_like (post_id, user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

START TRANSACTION;

INSERT INTO likes (post_id, user_id)
VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

COMMIT;

START TRANSACTION;

INSERT INTO likes (post_id, user_id)
VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

ROLLBACK;

SELECT post_id, content, likes_count FROM posts;
SELECT like_id, post_id, user_id FROM likes;

-- Bai 7 : 
ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN followers_count INT DEFAULT 0;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE follow_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_follow_user (
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_count
    FROM users
    WHERE user_id IN (p_follower_id, p_followed_id);

    IF v_count < 2 THEN
        INSERT INTO follow_log (follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'User không tồn tại');
        ROLLBACK;

    ELSEIF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log (follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Không thể tự follow chính mình');
        ROLLBACK;

    ELSE
        SELECT COUNT(*)
        INTO v_count
        FROM followers
        WHERE follower_id = p_follower_id
          AND followed_id = p_followed_id;

        IF v_count > 0 THEN
            INSERT INTO follow_log (follower_id, followed_id, error_message)
            VALUES (p_follower_id, p_followed_id, 'Đã follow trước đó');
            ROLLBACK;
        ELSE
            INSERT INTO followers (follower_id, followed_id)
            VALUES (p_follower_id, p_followed_id);

            UPDATE users
            SET following_count = following_count + 1
            WHERE user_id = p_follower_id;

            UPDATE users
            SET followers_count = followers_count + 1
            WHERE user_id = p_followed_id;

            COMMIT;
        END IF;
    END IF;
END //

DELIMITER ;

CALL sp_follow_user(1, 2);

CALL sp_follow_user(1, 1);

CALL sp_follow_user(1, 2);

CALL sp_follow_user(1, 999);

SELECT user_id, username, following_count, followers_count FROM users;
SELECT follower_id, followed_id FROM followers;
SELECT log_id, follower_id, followed_id, error_message, log_time FROM follow_log;

-- Bai 8 : 
ALTER TABLE posts
ADD COLUMN comments_count INT DEFAULT 0;

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_post_comment (
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT,
    IN p_force_error INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO comments (post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    IF p_force_error = 1 THEN
        UPDATE posts
        SET comments_count = comments_count + 1
        WHERE post_id = -1;
    ELSE
        UPDATE posts
        SET comments_count = comments_count + 1
        WHERE post_id = p_post_id;
    END IF;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK TO after_insert;
        COMMIT;
    ELSE
        COMMIT;
    END IF;
END //

DELIMITER ;

CALL sp_post_comment(1, 1, 'Bình luận hợp lệ', 0);

CALL sp_post_comment(1, 1, 'Bình luận lỗi update count', 1);

SELECT post_id, content, comments_count FROM posts;
SELECT comment_id, post_id, user_id, content, created_at FROM comments;

-- Bai 9: 
CREATE TABLE delete_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    deleted_by INT NOT NULL,
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_delete_post (
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT user_id
    INTO v_owner_id
    FROM posts
    WHERE post_id = p_post_id;

    IF v_owner_id IS NULL OR v_owner_id <> p_user_id THEN
        ROLLBACK;
    ELSE
        DELETE FROM likes
        WHERE post_id = p_post_id;

        DELETE FROM comments
        WHERE post_id = p_post_id;

        DELETE FROM posts
        WHERE post_id = p_post_id;

        UPDATE users
        SET posts_count = posts_count - 1
        WHERE user_id = p_user_id;

        INSERT INTO delete_log (post_id, deleted_by)
        VALUES (p_post_id, p_user_id);

        COMMIT;
    END IF;
END //

DELIMITER ;

CALL sp_delete_post(1, 1);

CALL sp_delete_post(2, 1);

SELECT user_id, username, posts_count FROM users;
SELECT post_id, user_id, content FROM posts;
SELECT like_id, post_id, user_id FROM likes;
SELECT comment_id, post_id, user_id, content FROM comments;
SELECT log_id, post_id, deleted_by, deleted_at FROM delete_log;

-- Bai 10 : 
ALTER TABLE users
ADD COLUMN friends_count INT DEFAULT 0;

CREATE TABLE friend_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    from_user_id INT NOT NULL,
    to_user_id INT NOT NULL,
    status ENUM('pending','accepted','rejected') DEFAULT 'pending',
    FOREIGN KEY (from_user_id) REFERENCES users(user_id),
    FOREIGN KEY (to_user_id) REFERENCES users(user_id)
);

CREATE TABLE friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (friend_id) REFERENCES users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_accept_friend_request (
    IN p_request_id INT,
    IN p_to_user_id INT
)
BEGIN
    DECLARE v_from_user_id INT;
    DECLARE v_status VARCHAR(10);
    DECLARE v_count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    START TRANSACTION;

    SELECT from_user_id, status
    INTO v_from_user_id, v_status
    FROM friend_requests
    WHERE request_id = p_request_id
      AND to_user_id = p_to_user_id
    FOR UPDATE;

    IF v_from_user_id IS NULL OR v_status <> 'pending' THEN
        ROLLBACK;
    ELSE
        SELECT COUNT(*)
        INTO v_count
        FROM friends
        WHERE user_id = v_from_user_id
          AND friend_id = p_to_user_id;

        IF v_count > 0 THEN
            ROLLBACK;
        ELSE
            INSERT INTO friends (user_id, friend_id)
            VALUES (v_from_user_id, p_to_user_id);

            INSERT INTO friends (user_id, friend_id)
            VALUES (p_to_user_id, v_from_user_id);

            UPDATE users
            SET friends_count = friends_count + 1
            WHERE user_id IN (v_from_user_id, p_to_user_id);

            UPDATE friend_requests
            SET status = 'accepted'
            WHERE request_id = p_request_id;

            COMMIT;
        END IF;
    END IF;
END //

DELIMITER ;

INSERT INTO friend_requests (from_user_id, to_user_id)
VALUES (1, 2);

CALL sp_accept_friend_request(1, 2);

CALL sp_accept_friend_request(1, 2);

SELECT user_id, username, friends_count FROM users;
SELECT user_id, friend_id FROM friends;
SELECT request_id, from_user_id, to_user_id, status FROM friend_requests;