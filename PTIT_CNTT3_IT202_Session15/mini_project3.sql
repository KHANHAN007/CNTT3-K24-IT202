

DROP DATABASE IF EXISTS mini_social_network;
CREATE DATABASE mini_social_network ;
USE mini_social_network;


-- 2.1 Bảng Users
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2.2 Bảng Posts
CREATE TABLE Posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0, -- Cột phục vụ bài 3
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 2.3 Bảng Comments
CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 2.4 Bảng Likes
CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, post_id), -- Khóa chính phức hợp ngăn trùng lặp
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

-- 2.5 Bảng Friends
CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) CHECK (status IN ('pending', 'accepted')) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 2.6 Bảng Logs (Phục vụ yêu cầu ghi log)
CREATE TABLE user_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. TẠO TRIGGERS & STORED PROCEDURES
-- =============================================================
DELIMITER //

/* --- BÀI 1: ĐĂNG KÝ THÀNH VIÊN --- */

-- Trigger: Ghi log khi có user mới
CREATE TRIGGER trg_after_insert_user
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_logs(user_id, action) VALUES (NEW.user_id, 'REGISTERED');
END //

-- Procedure: Đăng ký user có kiểm tra trùng
CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE username = p_username OR email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Username hoặc Email đã tồn tại!';
    ELSE
        INSERT INTO Users(username, password, email) VALUES (p_username, p_password, p_email);
    END IF;
END //

/* --- BÀI 2: ĐĂNG BÀI VIẾT --- */

-- Trigger: Ghi log khi có bài viết mới
CREATE TRIGGER trg_after_insert_post
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_logs(post_id, user_id, action) VALUES (NEW.post_id, NEW.user_id, 'CREATED_POST');
END //

-- Procedure: Đăng bài có kiểm tra rỗng
CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF TRIM(p_content) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Nội dung không được để trống!';
    ELSE
        INSERT INTO Posts(user_id, content) VALUES (p_user_id, p_content);
    END IF;
END //

/* --- BÀI 3: THÍCH BÀI VIẾT (AUTO UPDATE COUNT) --- */

-- Trigger: Tăng like_count
CREATE TRIGGER trg_after_insert_like
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count + 1 WHERE post_id = NEW.post_id;
END //

-- Trigger: Giảm like_count
CREATE TRIGGER trg_after_delete_like
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count - 1 WHERE post_id = OLD.post_id;
END //

/* --- BÀI 4: GỬI LỜI MỜI KẾT BẠN --- */

CREATE PROCEDURE sp_send_friend_request(
    IN p_sender_id INT,
    IN p_receiver_id INT
)
BEGIN
    IF p_sender_id = p_receiver_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không thể kết bạn với chính mình!';
    ELSEIF EXISTS (
        SELECT 1 FROM Friends 
        WHERE (user_id = p_sender_id AND friend_id = p_receiver_id)
           OR (user_id = p_receiver_id AND friend_id = p_sender_id)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Đã tồn tại lời mời hoặc mối quan hệ!';
    ELSE
        INSERT INTO Friends(user_id, friend_id, status) VALUES (p_sender_id, p_receiver_id, 'pending');
    END IF;
END //

/* --- BÀI 5: CHẤP NHẬN KẾT BẠN (TỰ ĐỘNG TẠO CHIỀU NGƯỢC) --- */

CREATE TRIGGER trg_after_update_friend
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' AND OLD.status != 'accepted' THEN
        INSERT IGNORE INTO Friends(user_id, friend_id, status)
        VALUES (NEW.friend_id, NEW.user_id, 'accepted');
    END IF;
END //

/* --- BÀI 6: QUẢN LÝ BẠN BÈ (TRANSACTION) --- */

CREATE PROCEDURE sp_unfriend(
    IN p_user1 INT,
    IN p_user2 INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Lỗi hệ thống: Giao dịch bị hủy bỏ' AS Message;
    END;

    START TRANSACTION;
        DELETE FROM Friends WHERE user_id = p_user1 AND friend_id = p_user2;
        DELETE FROM Friends WHERE user_id = p_user2 AND friend_id = p_user1;
    COMMIT;
END //

/* --- BÀI 7: XÓA BÀI VIẾT (TRANSACTION) --- */

CREATE PROCEDURE sp_delete_post_transaction(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Lỗi: Không thể xóa bài viết' AS Message;
    END;

    START TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM Posts WHERE post_id = p_post_id AND user_id = p_user_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Bài viết không tồn tại hoặc không có quyền!';
        END IF;

        DELETE FROM Likes WHERE post_id = p_post_id;
        DELETE FROM Comments WHERE post_id = p_post_id;
        DELETE FROM Posts WHERE post_id = p_post_id;
    COMMIT;
END //

/* --- BÀI 8: XÓA TÀI KHOẢN (TRANSACTION FULL) --- */

CREATE PROCEDURE sp_delete_user_transaction(
    IN p_user_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Lỗi: Không thể xóa tài khoản' AS Message;
    END;

    START TRANSACTION;
        DELETE FROM user_logs WHERE user_id = p_user_id;
        DELETE FROM post_logs WHERE user_id = p_user_id;
        DELETE FROM Likes WHERE user_id = p_user_id;
        DELETE FROM Comments WHERE user_id = p_user_id;
        DELETE FROM Friends WHERE user_id = p_user_id OR friend_id = p_user_id;
        DELETE FROM Posts WHERE user_id = p_user_id; -- Cascade sẽ xóa con của posts này nếu còn sót
        DELETE FROM Users WHERE user_id = p_user_id;
    COMMIT;
END //

DELIMITER ;

-- =============================================================
-- 4. KỊCH BẢN DEMO (TEST CASES)
-- =============================================================
-- Chạy từng dòng lệnh dưới đây để kiểm tra

-- --- TEST BÀI 1: Đăng ký ---
CALL sp_register_user('nguyenvana', 'pass1', 'a@email.com'); -- User ID 1
CALL sp_register_user('tranthib', 'pass2', 'b@email.com');   -- User ID 2
CALL sp_register_user('leccc', 'pass3', 'c@email.com');      -- User ID 3
-- Kiểm tra Log
SELECT * FROM Users; 
SELECT * FROM user_logs;

-- --- TEST BÀI 2: Đăng bài ---
CALL sp_create_post(1, 'Hello World! Bài đầu tiên.'); -- Post ID 1
CALL sp_create_post(1, 'Hôm nay trời đẹp.');          -- Post ID 2
CALL sp_create_post(2, 'Tôi là người dùng mới.');     -- Post ID 3
-- Kiểm tra Log bài viết
SELECT * FROM Posts;
SELECT * FROM post_logs;

-- --- TEST BÀI 3: Thích bài viết ---
INSERT INTO Likes(user_id, post_id) VALUES (2, 1); -- User 2 thích bài 1
INSERT INTO Likes(user_id, post_id) VALUES (3, 1); -- User 3 thích bài 1
-- Kiểm tra like_count của post_id=1 (kết quả = 2)
SELECT post_id, content, like_count FROM Posts WHERE post_id = 1;

-- --- TEST BÀI 4 & 5: Kết bạn ---
CALL sp_send_friend_request(1, 2); -- 1 gửi cho 2
CALL sp_send_friend_request(1, 3); -- 1 gửi cho 3
-- Chấp nhận lời mời (2 chấp nhận 1)
UPDATE Friends SET status = 'accepted' WHERE user_id = 1 AND friend_id = 2;
-- Kiểm tra: Phải có 2 dòng (1,2) và (2,1) status accepted
SELECT * FROM Friends;

-- --- TEST BÀI 6: Hủy kết bạn ---
CALL sp_unfriend(1, 2);
-- Kiểm tra: Cả 2 dòng bạn bè biến mất
SELECT * FROM Friends;

-- --- TEST BÀI 7: Xóa bài viết (Transaction) ---
-- Xóa bài 1 của user 1
CALL sp_delete_post_transaction(1, 1);
-- Kiểm tra: Bài 1 mất, Like trong bảng Likes cũng mất
SELECT * FROM Posts;
SELECT * FROM Likes;

-- --- TEST BÀI 8: Xóa tài khoản ---
-- Xóa User 3
CALL sp_delete_user_transaction(3);
-- Kiểm tra: User 3 mất, Like của user 3 mất, friend request liên quan user 3 mất
SELECT * FROM Users;
SELECT * FROM Likes;
SELECT * FROM Friends;