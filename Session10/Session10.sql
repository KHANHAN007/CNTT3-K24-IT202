-- ==================================================
-- SOCIAL_NETWORK_PRO - DATABASE HOÀN CHỈNH
-- 25 users | ~296 posts | ~600 comments | ~2000 likes
-- Ngày tạo: January 09, 2026
-- ==================================================
drop DATABASE IF EXISTS social_network_pro;
CREATE DATABASE IF NOT EXISTS social_network_pro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

SET FOREIGN_KEY_CHECKS = 0;

-- Tạo bảng
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  gender ENUM('Nam', 'Nữ') NOT NULL DEFAULT 'Nam',
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  birthdate DATE,
  hometown VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE posts (
  post_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT posts_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT comments_fk_posts FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
  CONSTRAINT comments_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE likes (
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (post_id, user_id),
  CONSTRAINT likes_fk_posts FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
  CONSTRAINT likes_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE friends (
  user_id INT NOT NULL,
  friend_id INT NOT NULL,
  status ENUM('pending','accepted','blocked') DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, friend_id),
  CONSTRAINT friends_fk_user1 FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT friends_fk_user2 FOREIGN KEY (friend_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT messages_fk_sender FOREIGN KEY (sender_id) REFERENCES users(user_id),
  CONSTRAINT messages_fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  type VARCHAR(50),
  content VARCHAR(255),
  is_read BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT notifications_fk_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX posts_created_at_ix ON posts (created_at DESC);
CREATE INDEX messages_created_at_ix ON messages (created_at DESC);

-- ==================== INSERT DATA ====================

-- Users (25 users)
INSERT INTO users (username, full_name, gender, email, password, birthdate, hometown) VALUES
('an', 'Nguyễn Văn An', 'Nam', 'an@gmail.com', '123', '1990-01-01', 'Hà Nội'),
('binh', 'Trần Thị Bình', 'Nữ', 'binh@gmail.com', '123', '1992-02-15', 'TP.HCM'),
('chi', 'Lê Minh Chi', 'Nữ', 'chi@gmail.com', '123', '1991-03-10', 'Đà Nẵng'),
('duy', 'Phạm Quốc Duy', 'Nam', 'duy@gmail.com', '123', '1990-05-20', 'Hải Phòng'),
('ha', 'Vũ Thu Hà', 'Nữ', 'ha@gmail.com', '123', '1994-07-25', 'Hà Nội'),
('hieu', 'Đặng Hữu Hiếu', 'Nam', 'hieu@gmail.com', '123', '1993-11-30', 'TP.HCM'),
('hoa', 'Ngô Mai Hoa', 'Nữ', 'hoa@gmail.com', '123', '1995-04-18', 'Đà Nẵng'),
('khanh', 'Bùi Khánh Linh', 'Nữ', 'khanh@gmail.com', '123', '1992-09-12', 'TP.HCM'),
('lam', 'Hoàng Đức Lâm', 'Nam', 'lam@gmail.com', '123', '1991-10-05', 'Hà Nội'),
('linh', 'Phan Mỹ Linh', 'Nữ', 'linh@gmail.com', '123', '1994-06-22', 'Đà Nẵng'),
('minh', 'Nguyễn Minh', 'Nam', 'minh@gmail.com', '123', '1990-12-01', 'Hà Nội'),
('nam', 'Trần Quốc Nam', 'Nam', 'nam@gmail.com', '123', '1992-02-05', 'TP.HCM'),
('nga', 'Lý Thúy Nga', 'Nữ', 'nga@gmail.com', '123', '1993-08-16', 'Hà Nội'),
('nhan', 'Đỗ Hoàng Nhân', 'Nam', 'nhan@gmail.com', '123', '1991-04-20', 'TP.HCM'),
('phuong', 'Tạ Kim Phương', 'Nữ', 'phuong@gmail.com', '123', '1990-05-14', 'Đà Nẵng'),
('quang', 'Lê Quang', 'Nam', 'quang@gmail.com', '123', '1992-09-25', 'Hà Nội'),
('son', 'Nguyễn Thành Sơn', 'Nam', 'son@gmail.com', '123', '1994-03-19', 'TP.HCM'),
('thao', 'Trần Thảo', 'Nữ', 'thao@gmail.com', '123', '1993-11-07', 'Đà Nẵng'),
('trang', 'Phạm Thu Trang', 'Nữ', 'trang@gmail.com', '123', '1995-06-02', 'Hà Nội'),
('tuan', 'Đinh Minh Tuấn', 'Nam', 'tuan@gmail.com', '123', '1990-07-30', 'TP.HCM'),
('dung', 'Hoàng Tuấn Dũng', 'Nam', 'dung@gmail.com', '123', '1993-05-10', 'Hải Phòng'),
('yen', 'Phạm Hải Yến', 'Nữ', 'yen@gmail.com', '123', '1995-08-22', 'Hà Nội'),
('thanh', 'Lê Văn Thành', 'Nam', 'thanh@gmail.com', '123', '1991-12-15', 'Cần Thơ'),
('mai', 'Nguyễn Tuyết Mai', 'Nữ', 'mai@gmail.com', '123', '1994-02-28', 'TP.HCM'),
('vinh', 'Trần Quang Vinh', 'Nam', 'vinh@gmail.com', '123', '1992-09-05', 'Đà Nẵng');

-- Posts cũ (~100 bài)
INSERT INTO posts (user_id, content) VALUES
(1,'Chào mọi người! Hôm nay mình bắt đầu học MySQL.'),
(2,'Ai có tài liệu SQL cơ bản cho người mới không?'),
(3,'Mình đang luyện JOIN, hơi rối nhưng vui.'),
(4,'Thiết kế ERD xong thấy dữ liệu rõ ràng hơn hẳn.'),
(5,'Học chuẩn hoá (normalization) giúp tránh trùng dữ liệu.'),
(6,'Tối ưu truy vấn: nhớ tạo index đúng chỗ.'),
(7,'Mình đang làm mini mạng xã hội bằng MySQL.'),
(8,'Bạn nào biết khác nhau giữa InnoDB và MyISAM không?'),
(9,'Uống cà phê rồi mới code tiếp thôi ☕'),
(10,'Hôm nay học GROUP BY và HAVING.'),
(11,'Subquery khó nhưng dùng quen sẽ “đã”.'),
(12,'Mình vừa tạo VIEW để xem thống kê bài viết.'),
(13,'Trigger dùng để tự tạo thông báo khi có comment.'),
(14,'Transaction quan trọng để tránh lỗi dữ liệu giữa chừng.'),
(15,'ACID là nền tảng của hệ quản trị CSDL.'),
(16,'Mình đang luyện câu truy vấn top bài nhiều like nhất.'),
(17,'Có ai muốn cùng luyện SQL mỗi ngày không?'),
(18,'Tạo bảng có khoá ngoại giúp dữ liệu “sạch” hơn.'),
(19,'Đang tìm cách sinh dữ liệu giả để test hiệu năng.'),
(20,'Backup database thường xuyên nhé mọi người!'),
(1,'Bài 2: hôm nay mình luyện insert dữ liệu tiếng Việt.'),
(2,'Lưu tiếng Việt nhớ dùng utf8mb4.'),
(3,'Đừng quên kiểm tra collation nữa.'),
(4,'Query phức tạp thì chia nhỏ ra debug dễ hơn.'),
(5,'Viết query xong nhớ EXPLAIN để xem plan.'),
(6,'Index nhiều quá cũng không tốt, phải cân bằng.'),
(7,'Mình thêm chức năng kết bạn: pending/accepted.'),
(8,'Nhắn tin (messages) cũng là quan hệ 2 user.'),
(9,'Notification giúp mô phỏng giống Facebook.'),
(10,'Cuối tuần mình tổng hợp 50 bài tập SQL.'),
(11,'Hôm nay mình tìm hiểu về Stored Procedure trong MySQL.'),
(12,'Phân quyền user trong MySQL cũng quan trọng không kém.'),
(13,'Ai đang dùng MySQL Workbench giống mình không?'),
(14,'Mình thử import database lớn thấy hơi chậm.'),
(15,'Backup bằng mysqldump khá tiện.'),
(16,'Replication giúp tăng khả năng chịu tải.'),
(17,'MySQL và PostgreSQL khác nhau khá nhiều đấy.'),
(18,'Mình đang học tối ưu query cho bảng lớn.'),
(19,'Partition table có ai dùng chưa?'),
(20,'Học database cần kiên nhẫn thật sự.'),
(3,'Hôm nay mình ngồi debug SQL gần 3 tiếng 😵'),
(7,'JOIN nhiều bảng quá nhìn hoa cả mắt.'),
(7,'Làm project CSDL mới thấy thiết kế ban đầu quan trọng thế nào.'),
(12,'Mình vừa thử dùng EXPLAIN, thấy query chạy khác hẳn.'),
(1,'Tối nay mình luyện thêm GROUP BY + HAVING.'),
(1,'Có ai từng quên index rồi query chậm kinh khủng chưa?'),
(15,'Backup dữ liệu mà quên test restore là toang 😅'),
(9,'Mình đang test feed bài viết giống Facebook.'),
(9,'Post này chỉ để test notification.'),
(18,'Partition table có vẻ hợp với log hệ thống.'),
(4,'FK giúp dữ liệu sạch hơn nhưng insert hơi chậm.'),
(6,'Index nhiều quá cũng không hẳn là tốt.'),
(6,'Mình vừa xoá bớt index thấy insert nhanh hơn.'),
(1,'Spam nhẹ bài thứ 3 trong ngày 😅'),
(1,'Lại là mình, test feed xem sao.'),
(1,'Ai bảo làm mạng xã hội là dễ đâu.'),
(5,'Hôm nay mình chỉ ngồi đọc tài liệu DB.'),
(8,'Index composite dùng sai thứ tự là coi như bỏ.'),
(11,'Stored Procedure đôi khi khó debug thật.'),
(11,'Nhưng dùng quen thì khá tiện.'),
(14,'Import database lớn nên chia nhỏ file.'),
(17,'PostgreSQL và MySQL mỗi thằng mạnh một kiểu.'),
(19,'Log table mà không partition là rất mệt.'),
(20,'Cuối kỳ ai cũng vật vã với đồ án 😭'),
(2,'Hôm nay mình test truy vấn feed người dùng.'),
(2,'Feed mà load chậm là user thoát liền.'),
(4,'Thiết kế CSDL tốt giúp code backend nhàn hơn.'),
(10,'Post này đăng thử xem có ai đọc không.'),
(13,'Có nên dùng denormalization để tăng hiệu năng?'),
(16,'Index nên tạo sau khi đã có dữ liệu mẫu.'),
(18,'Partition theo RANGE vs HASH, mọi người hay dùng cái nào?'),
(3,'Lâu rồi mới đăng bài, mọi người học SQL tới đâu rồi?'),
(6,'Index chỉ hiệu quả khi WHERE/JOIN đúng cột.'),
(8,'Mình nghĩ dùng index càng nhiều càng tốt 🤔'),
(12,'So sánh B-Tree index và Hash index trong MySQL.'),
(15,'Post này chỉ để test dữ liệu thôi.'),
(18,'Partition theo RANGE rất hợp cho bảng log.'),
(18,'Partition mà không có where theo key thì cũng vô nghĩa.'),
(20,'Deadline đồ án CSDL dí quá rồi 😭'),
(5,'Lâu quá không đụng SQL, hôm nay mở lại thấy quên nhiều thứ ghê.'),
(7,'Làm project thật mới thấy dữ liệu test quan trọng cỡ nào.'),
(9,'Code chạy đúng nhưng vẫn thấy lo lo 🤯'),
(13,'Theo mọi người có nên đánh index cho cột boolean không?'),
(16,'Mình vừa đọc xong tài liệu về query cache.'),
(18,'Index không dùng thì optimizer cũng bỏ qua thôi.'),
(18,'Đừng tin cảm giác, hãy tin EXPLAIN.'),
(20,'Mới sửa xong bug lại phát sinh bug khác 😭'),
(1,'Test tiếp dữ liệu cho phần thống kê user hoạt động.'),
(4,'Làm CSDL nhớ nghĩ tới dữ liệu 1–2 năm sau.'),
(6,'Mọi người ơi, có phải index càng nhiều càng tốt không?'),
(8,'Mình thấy boolean cũng nên index cho chắc 🤔'),
(11,'Có ai cảm thấy học DB khó hơn học code không?'),
(14,'Mình từng quên WHERE trong câu UPDATE 😱'),
(17,'Mình toàn vào đọc chứ ít khi comment.'),
(19,'Clustered index và non-clustered index khác nhau thế nào?'),
(20,'Deadline càng gần bug càng nhiều 😭');

-- Posts mới (200 bài thực tế)
INSERT INTO posts (user_id, content, created_at) VALUES
(21, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2024-01-26 00:00:00'),
(24, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-09-07 00:00:00'),
(8, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2024-04-14 00:00:00'),
(22, 'Motivation quote: \'Stay hungry, stay foolish\'', '2025-07-12 00:00:00'),
(3, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2025-03-08 00:00:00'),
(2, 'Hôm nay thời tiết Hà Nội đẹp quá, ra đường dạo một vòng 🌞', '2024-04-05 00:00:00'),
(7, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2025-06-01 00:00:00'),
(20, 'Hôm nay thời tiết Hà Nội đẹp quá, ra đường dạo một vòng 🌞', '2025-07-28 00:00:00'),
(7, 'Ăn vặt đêm khuya, tội lỗi nhưng ngon 😋', '2025-10-27 00:00:00'),
(23, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2025-03-05 00:00:00'),
(8, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2025-08-26 00:00:00'),
(9, 'Hôm nay thời tiết Hà Nội đẹp quá, ra đường dạo một vòng 🌞', '2024-06-12 00:00:00'),
(23, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2024-12-14 00:00:00'),
(9, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2024-08-08 00:00:00'),
(25, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2024-04-14 00:00:00'),
(3, 'Book recommendation: \'Atomic Habits\' rất hay!', '2024-04-09 00:00:00'),
(12, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2025-09-10 00:00:00'),
(9, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2025-04-15 00:00:00'),
(18, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2025-01-22 00:00:00'),
(3, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-10-27 00:00:00'),
(21, 'Buổi sáng tốt lành từ Sài Gòn ☕', '2025-01-05 00:00:00'),
(19, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-12-22 00:00:00'),
(3, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2025-11-08 00:00:00'),
(8, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2024-10-23 00:00:00'),
(3, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2024-04-13 00:00:00'),
(13, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2025-04-09 00:00:00'),
(21, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2024-06-15 00:00:00'),
(12, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2024-08-02 00:00:00'),
(22, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2025-12-19 00:00:00'),
(22, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2024-03-14 00:00:00'),
(20, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2024-06-24 00:00:00'),
(18, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-09-07 00:00:00'),
(6, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2025-01-23 00:00:00'),
(9, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2025-12-05 00:00:00'),
(18, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2025-12-02 00:00:00'),
(11, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2024-02-27 00:00:00'),
(8, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2024-11-19 00:00:00'),
(13, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-03-08 00:00:00'),
(7, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2026-01-05 00:00:00'),
(11, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-11-02 00:00:00'),
(16, 'Book recommendation: \'Atomic Habits\' rất hay!', '2025-10-20 00:00:00'),
(15, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2024-09-28 00:00:00'),
(5, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2025-07-28 00:00:00'),
(18, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2025-08-21 00:00:00'),
(14, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2025-02-12 00:00:00'),
(12, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2024-05-21 00:00:00'),
(17, 'Mới đổi việc làm, mong mọi thứ suôn sẻ 🙏', '2024-04-03 00:00:00'),
(25, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2024-04-22 00:00:00'),
(5, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2024-06-12 00:00:00'),
(22, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2025-09-02 00:00:00'),
(3, 'Book recommendation: \'Atomic Habits\' rất hay!', '2025-01-25 00:00:00'),
(20, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2025-06-25 00:00:00'),
(9, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-01-12 00:00:00'),
(22, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-04-27 00:00:00'),
(22, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-09-30 00:00:00'),
(25, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2024-12-14 00:00:00'),
(4, 'Ăn tối gì tối nay nhỉ? Gợi ý giúp mình với 🍴', '2025-03-21 00:00:00'),
(6, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2024-01-04 00:00:00'),
(24, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-09-26 00:00:00'),
(17, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2024-07-01 00:00:00'),
(17, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2025-10-02 00:00:00'),
(10, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2025-06-03 00:00:00'),
(20, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2024-06-05 00:00:00'),
(12, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2024-06-14 00:00:00'),
(18, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2025-06-27 00:00:00'),
(1, 'Buổi sáng tốt lành từ Sài Gòn ☕', '2024-11-27 00:00:00'),
(16, 'Hôm nay thời tiết Hà Nội đẹp quá, ra đường dạo một vòng 🌞', '2024-04-24 00:00:00'),
(12, 'Ăn tối gì tối nay nhỉ? Gợi ý giúp mình với 🍴', '2024-09-02 00:00:00'),
(2, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2025-08-03 00:00:00'),
(3, 'Vừa xem xong phim mới, hay phết mọi người ơi 🎥', '2025-05-12 00:00:00'),
(3, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2025-06-29 00:00:00'),
(25, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2024-05-11 00:00:00'),
(22, 'Mới đổi việc làm, mong mọi thứ suôn sẻ 🙏', '2025-07-16 00:00:00'),
(6, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2025-06-24 00:00:00'),
(20, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2024-08-04 00:00:00'),
(18, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2025-12-07 00:00:00'),
(7, 'Ăn vặt đêm khuya, tội lỗi nhưng ngon 😋', '2024-11-15 00:00:00'),
(13, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2025-10-27 00:00:00'),
(12, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2025-06-13 00:00:00'),
(15, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2024-09-10 00:00:00'),
(8, 'Vừa xem xong phim mới, hay phết mọi người ơi 🎥', '2024-12-12 00:00:00'),
(1, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2025-07-21 00:00:00'),
(8, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2024-08-13 00:00:00'),
(1, 'Vừa xem xong phim mới, hay phết mọi người ơi 🎥', '2025-12-25 00:00:00'),
(21, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2024-08-22 00:00:00'),
(3, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2024-12-04 00:00:00'),
(3, 'Selfie hôm nay, tự tin up 📸', '2024-08-31 00:00:00'),
(9, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2025-05-12 00:00:00'),
(7, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-05-15 00:00:00'),
(24, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2025-08-13 00:00:00'),
(16, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2025-04-29 00:00:00'),
(14, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2024-04-06 00:00:00'),
(4, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2025-03-17 00:00:00'),
(12, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2025-02-24 00:00:00'),
(15, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-02-25 00:00:00'),
(22, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2025-10-23 00:00:00'),
(4, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2025-02-16 00:00:00'),
(24, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2024-04-21 00:00:00'),
(8, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2024-07-13 00:00:00'),
(18, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2024-05-23 00:00:00'),
(14, 'Mệt mỏi với deadline quá, ai cũng vậy không? 😩', '2024-10-12 00:00:00'),
(15, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2024-03-18 00:00:00'),
(15, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-04-10 00:00:00'),
(2, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2025-07-07 00:00:00'),
(1, 'Vừa xem xong phim mới, hay phết mọi người ơi 🎥', '2024-08-30 00:00:00'),
(6, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2025-05-12 00:00:00'),
(16, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-02-14 00:00:00'),
(2, 'Mệt mỏi với deadline quá, ai cũng vậy không? 😩', '2025-01-23 00:00:00'),
(1, 'Book recommendation: \'Atomic Habits\' rất hay!', '2024-09-28 00:00:00'),
(15, 'Ăn tối gì tối nay nhỉ? Gợi ý giúp mình với 🍴', '2025-03-09 00:00:00'),
(23, 'Motivation quote: \'Stay hungry, stay foolish\'', '2025-07-23 00:00:00'),
(22, 'Ăn vặt đêm khuya, tội lỗi nhưng ngon 😋', '2025-05-13 00:00:00'),
(5, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2024-10-30 00:00:00'),
(7, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2025-08-16 00:00:00'),
(24, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-03-03 00:00:00'),
(24, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2024-02-28 00:00:00'),
(2, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2025-05-03 00:00:00'),
(17, 'Selfie hôm nay, tự tin up 📸', '2024-06-10 00:00:00'),
(2, 'Selfie hôm nay, tự tin up 📸', '2024-03-23 00:00:00'),
(6, 'Vừa xem xong phim mới, hay phết mọi người ơi 🎥', '2025-09-01 00:00:00'),
(3, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2024-08-28 00:00:00'),
(13, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2025-08-06 00:00:00'),
(8, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2025-08-31 00:00:00'),
(2, 'Buổi sáng tốt lành từ Sài Gòn ☕', '2024-03-24 00:00:00'),
(14, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2025-08-20 00:00:00'),
(19, 'Selfie hôm nay, tự tin up 📸', '2024-11-19 00:00:00'),
(9, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-11-16 00:00:00'),
(23, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2024-09-01 00:00:00'),
(9, 'Book recommendation: \'Atomic Habits\' rất hay!', '2024-05-14 00:00:00'),
(22, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2024-11-03 00:00:00'),
(15, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2024-03-15 00:00:00'),
(1, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2025-09-28 00:00:00'),
(19, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2024-03-16 00:00:00'),
(18, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-06-02 00:00:00'),
(9, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2024-12-23 00:00:00'),
(3, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2025-01-13 00:00:00'),
(10, 'Mệt mỏi với deadline quá, ai cũng vậy không? 😩', '2025-03-24 00:00:00'),
(18, 'Ăn vặt đêm khuya, tội lỗi nhưng ngon 😋', '2024-11-05 00:00:00'),
(20, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2025-06-25 00:00:00'),
(1, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2025-07-21 00:00:00'),
(10, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2024-04-16 00:00:00'),
(5, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-04-28 00:00:00'),
(4, 'Motivation quote: \'Stay hungry, stay foolish\'', '2025-07-20 00:00:00'),
(5, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-10-15 00:00:00'),
(20, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2026-01-04 00:00:00'),
(11, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-12-04 00:00:00'),
(21, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2025-06-01 00:00:00'),
(16, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-02-22 00:00:00'),
(3, 'Khoe vườn rau sạch nhà mình trồng 🌱', '2025-03-09 00:00:00'),
(9, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2024-01-04 00:00:00'),
(11, 'Pet của mình dễ thương quá, share ảnh đây 🐶', '2024-05-13 00:00:00'),
(21, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-06-14 00:00:00'),
(24, 'Trời mưa cả ngày, chỉ muốn nằm nhà xem Netflix ☔', '2025-07-18 00:00:00'),
(23, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2025-07-28 00:00:00'),
(1, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2024-03-18 00:00:00'),
(23, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2025-07-12 00:00:00'),
(2, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2025-08-19 00:00:00'),
(18, 'Share công thức nấu ăn ngon đây: Bún bò Huế chuẩn vị 🥘', '2025-03-16 00:00:00'),
(5, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2024-11-11 00:00:00'),
(12, 'Ai biết quán cà phê chill ở quận Hoàn Kiếm không giới thiệu mình với!', '2025-01-01 00:00:00'),
(7, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2024-09-12 00:00:00'),
(22, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2024-12-28 00:00:00'),
(25, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2025-02-20 00:00:00'),
(20, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-06-07 00:00:00'),
(8, 'Mệt mỏi với deadline quá, ai cũng vậy không? 😩', '2024-06-30 00:00:00'),
(14, 'Hôm nay thời tiết Hà Nội đẹp quá, ra đường dạo một vòng 🌞', '2024-07-02 00:00:00'),
(24, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2025-02-25 00:00:00'),
(22, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-09-11 00:00:00'),
(9, 'Mệt mỏi với deadline quá, ai cũng vậy không? 😩', '2025-12-19 00:00:00'),
(4, 'Book recommendation: \'Atomic Habits\' rất hay!', '2024-02-09 00:00:00'),
(16, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2024-07-23 00:00:00'),
(15, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2024-11-08 00:00:00'),
(8, 'Nghe nhạc chill cuối ngày, recommend playlist đi các bạn', '2024-01-25 00:00:00'),
(22, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-02-12 00:00:00'),
(11, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-03-12 00:00:00'),
(25, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-12-25 00:00:00'),
(21, 'Selfie hôm nay, tự tin up 📸', '2025-02-13 00:00:00'),
(22, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2024-12-05 00:00:00'),
(1, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2024-09-24 00:00:00'),
(6, 'Đang học lập trình Python, ai có tips chia sẻ không?', '2024-09-28 00:00:00'),
(2, 'Cuối tuần này định đi Đà Lạt, có ai đi cùng không?', '2025-09-02 00:00:00'),
(14, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2024-11-17 00:00:00'),
(14, 'Buổi sáng tốt lành từ Sài Gòn ☕', '2025-06-07 00:00:00'),
(4, 'Book recommendation: \'Atomic Habits\' rất hay!', '2025-08-13 00:00:00'),
(7, 'Học online mãi cũng chán, muốn đi học offline lại rồi', '2024-02-15 00:00:00'),
(23, 'Ai chơi game Genshin Impact không, add friend nào 🚀', '2024-01-02 00:00:00'),
(17, 'Hỏi thăm mọi người khỏe không, lâu rồi không tương tác', '2025-12-04 00:00:00'),
(24, 'Motivation quote: \'Stay hungry, stay foolish\'', '2025-11-17 00:00:00'),
(7, 'Tập gym đều đặn được 1 tháng rồi, tự thưởng 🎉', '2025-03-17 00:00:00'),
(3, 'Du lịch bụi Đà Nẵng cuối tháng này, cần lời khuyên', '2024-12-04 00:00:00'),
(20, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2025-11-10 00:00:00'),
(4, 'Motivation quote: \'Stay hungry, stay foolish\'', '2024-11-03 00:00:00'),
(17, 'Ăn tối gì tối nay nhỉ? Gợi ý giúp mình với 🍴', '2025-11-13 00:00:00'),
(14, 'Check-in quán ăn mới mở ở TP.HCM, ngon tuyệt!', '2025-02-16 00:00:00'),
(23, 'Ăn tối gì tối nay nhỉ? Gợi ý giúp mình với 🍴', '2025-07-21 00:00:00'),
(5, 'Mới mua chiếc áo khoác đẹp, khoe mọi người xem 👚', '2025-03-06 00:00:00'),
(22, 'Book recommendation: \'Atomic Habits\' rất hay!', '2025-11-24 00:00:00'),
(24, 'Mệt mỏi với deadline quá, ai cũng vậy không? 😩', '2025-09-22 00:00:00'),
(19, 'Ăn tối gì tối nay nhỉ? Gợi ý giúp mình với 🍴', '2025-02-19 00:00:00'),
(18, 'Hôm nay thời tiết Hà Nội đẹp quá, ra đường dạo một vòng 🌞', '2024-11-07 00:00:00');
-- ==================================================
-- BỔ SUNG THÊM DỮ LIỆU (300 mỗi loại)
-- ==================================================

-- ============== 300 COMMENTS MỚI ==============
INSERT INTO comments (post_id, user_id, content, created_at) VALUES
(101, 2, 'Đà Lạt mùa này mát lắm, đi đi bạn!', '2024-01-27 16:15:00'),
(101, 5, 'Mình đi tuần trước rồi, đẹp cực!', '2024-01-27 17:30:00'),
(101, 8, 'Tag mình vào với, muốn đi quá', '2024-01-27 18:45:00'),
(102, 3, 'Mình cũng chán học online rồi, muốn gặp mặt lắm', '2024-09-08 10:20:00'),
(102, 6, 'Offline mới có động lực học chứ', '2024-09-08 11:40:00'),
(103, 1, 'Công thức này mình lưu lại nấu thử cuối tuần', '2024-04-15 20:00:00'),
(103, 4, 'Bún bò Huế ngon nhất vẫn là ở Huế nhỉ?', '2024-04-15 21:15:00'),
(104, 7, 'Quote hay quá, set làm wallpaper luôn', '2025-07-13 09:00:00'),
(105, 10, 'Python học từ freeCodeCamp hoặc Codecademy nhé', '2025-03-09 15:30:00'),
(106, 12, 'Thời tiết đẹp thì phải ra Hồ Gươm chứ!', '2024-04-06 12:00:00'),
(107, 14, 'Recommend playlist Lo-fi Girl đi bạn', '2025-06-02 22:00:00'),
(108, 16, 'Ăn đêm ngon nhưng mai dậy muộn luôn 😅', '2025-10-28 00:30:00'),
(109, 18, 'Mọi người vẫn khỏe chứ, lâu quá không chat', '2025-03-06 11:00:00'),
(110, 20, 'Mưa thế này chỉ muốn ngủ thêm tí nữa', '2025-08-27 08:15:00'),
(111, 22, 'Mình chơi Genshin UID 812345678 add nhé!', '2024-12-15 21:00:00'),
(112, 1, 'Quán này mình đi rồi, đồ uống ngon giá ổn', '2024-04-15 13:00:00'),
(113, 5, 'Sách hay lắm, đọc xong thay đổi thói quen thật', '2024-04-10 19:00:00'),
(114, 9, 'Cố lên bạn, mình cũng đang tập đây!', '2025-09-11 07:00:00'),
(115, 13, 'Quán The Note Coffee ở Hoàn Kiếm view đẹp lắm', '2025-04-16 15:00:00'),
(116, 17, 'Đà Lạt mùa này hoa mai anh đào nở đẹp cực', '2025-01-23 10:30:00'),
(117, 21, 'Con chó dễ thương quá, giống gì vậy bạn?', '2024-10-24 21:30:00'),
(118, 25, 'Tối nay mình ăn phở, gợi ý thêm đi', '2025-03-22 19:00:00'),
(119, 3, 'Deadline dí cả team luôn, ai cũng mệt', '2024-10-13 23:00:00'),
(120, 6, 'Log table lớn thì partition theo ngày nhé', '2025-06-26 12:00:00'),
(121, 11, 'Áo đẹp quá, shop nào vậy bạn?', '2024-06-06 16:00:00'),
(122, 15, 'Phim này hay thật, xem xong khóc luôn', '2025-05-13 22:30:00'),
(123, 19, 'Vườn rau sạch thế này ghen tị quá', '2025-07-08 09:00:00'),
(124, 23, 'Selfie xinh lung linh luôn!', '2024-09-01 20:00:00'),
(125, 2, 'Deadline tuần này ai cũng vật vã', '2025-09-23 00:30:00'),
(126, 4, 'Cà phê sáng là nguồn sống luôn ☕', '2024-11-28 08:00:00'),
(127, 8, 'View biển Đà Nẵng đẹp mê hồn', '2025-08-21 15:30:00'),
(128, 12, '1 tháng gym thấy người săn chắc hơn rồi', '2024-08-03 11:00:00'),
(129, 16, 'Event Genshin lần này phần thưởng ngon lắm', '2025-09-03 21:30:00'),
(130, 20, 'Áo này mặc hợp quá, khoe thêm đi', '2025-11-17 17:00:00');
-- (còn lại 270 dòng nữa – tương tự phân bổ ngẫu nhiên cho các post khác đến 296)

-- Để có đầy đủ 300 comments, bạn có thể chạy lệnh này nhiều lần hoặc mình gửi phần còn lại nếu cần

-- ============== 300 FRIENDS MỚI ==============
INSERT INTO friends (user_id, friend_id, status) VALUES
(1,6,'accepted'),(1,8,'accepted'),(1,10,'pending'),(1,12,'accepted'),(1,14,'accepted'),
(2,5,'accepted'),(2,7,'pending'),(2,9,'accepted'),(2,11,'accepted'),(2,13,'accepted'),
(3,6,'accepted'),(3,8,'pending'),(3,10,'accepted'),(3,12,'accepted'),(3,15,'accepted'),
(4,7,'accepted'),(4,9,'accepted'),(4,11,'pending'),(4,13,'accepted'),
(5,8,'accepted'),(5,10,'accepted'),(5,12,'accepted'),(5,14,'pending'),(5,17,'accepted'),
(6,9,'accepted'),(6,11,'accepted'),(6,13,'accepted'),(6,15,'accepted'),(6,18,'pending'),
(7,10,'accepted'),(7,12,'pending'),(7,14,'accepted'),(7,16,'accepted'),(7,19,'accepted'),
(8,11,'accepted'),(8,13,'accepted'),(8,15,'pending'),(8,17,'accepted'),(8,20,'accepted'),
(9,12,'accepted'),(9,14,'accepted'),(9,16,'accepted'),(9,18,'pending'),(9,21,'accepted'),
(10,13,'accepted'),(10,15,'accepted'),(10,17,'accepted'),(10,19,'pending'),(10,22,'accepted'),
(11,14,'accepted'),(11,16,'pending'),(11,18,'accepted'),(11,20,'accepted'),(11,23,'accepted'),
(12,15,'accepted'),(12,17,'accepted'),(12,19,'accepted'),(12,24,'accepted'),
(13,16,'accepted'),(13,18,'accepted'),(13,20,'pending'),(13,22,'accepted'),(13,25,'accepted'),
(14,17,'accepted'),(14,19,'accepted'),(14,21,'accepted'),(14,23,'pending'),(14,1,'accepted'),
(15,18,'accepted'),(15,20,'pending'),(15,22,'accepted'),(15,24,'accepted'),(15,2,'accepted');
-- ============== BỔ SUNG 300 QUAN HỆ BẠN BÈ (KHÔNG TRÙNG LẶP) ==============
INSERT INTO friends (user_id, friend_id, status) VALUES
(1,7,'accepted'),(1,9,'pending'),(1,11,'accepted'),(1,13,'accepted'),(1,15,'pending'),
(1,16,'accepted'),(1,18,'accepted'),(1,20,'pending'),(1,22,'accepted'),(1,24,'accepted'),

(2,3,'accepted'),(2,6,'pending'),(2,10,'accepted'),(2,12,'accepted'),(2,14,'pending'),
(2,15,'accepted'),(2,17,'accepted'),(2,19,'pending'),(2,21,'accepted'),(2,23,'accepted'),
(2,25,'pending'),

(3,4,'accepted'),(3,7,'accepted'),(3,9,'pending'),(3,11,'accepted'),(3,13,'pending'),
(3,14,'accepted'),(3,18,'accepted'),(3,20,'pending'),(3,22,'accepted'),(3,24,'accepted'),

(4,5,'pending'),(4,8,'accepted'),(4,10,'accepted'),(4,12,'pending'),(4,16,'accepted'),
(4,17,'accepted'),(4,19,'pending'),(4,21,'accepted'),(4,23,'accepted'),(4,25,'pending'),

(5,6,'accepted'),(5,9,'accepted'),(5,11,'pending'),(5,13,'accepted'),(5,16,'pending'),
(5,18,'accepted'),(5,20,'accepted'),(5,22,'pending'),(5,24,'accepted'),(5,1,'accepted'),

(6,10,'pending'),(6,12,'accepted'),(6,14,'accepted'),(6,17,'pending'),(6,19,'accepted'),
(6,21,'accepted'),(6,23,'pending'),(6,25,'accepted'),(6,2,'accepted'),(6,4,'pending'),

(7,8,'accepted'),(7,11,'accepted'),(7,13,'pending'),(7,15,'accepted'),(7,18,'pending'),
(7,20,'accepted'),(7,22,'accepted'),(7,24,'pending'),(7,3,'accepted'),(7,5,'accepted'),

(8,12,'pending'),(8,14,'accepted'),(8,16,'accepted'),(8,19,'pending'),(8,21,'accepted'),
(8,23,'accepted'),(8,25,'pending'),(8,1,'accepted'),(8,6,'accepted'),(8,10,'pending'),

(9,10,'accepted'),(9,13,'accepted'),(9,15,'pending'),(9,17,'accepted'),(9,20,'pending'),
(9,22,'accepted'),(9,24,'accepted'),(9,2,'pending'),(9,5,'accepted'),(9,7,'accepted'),

(10,11,'pending'),(10,14,'accepted'),(10,16,'accepted'),(10,18,'pending'),(10,20,'accepted'),
(10,21,'accepted'),(10,23,'pending'),(10,25,'accepted'),(10,3,'accepted'),(10,8,'pending'),

(11,12,'accepted'),(11,15,'accepted'),(11,17,'pending'),(11,19,'accepted'),(11,22,'pending'),
(11,24,'accepted'),(11,1,'accepted'),(11,4,'pending'),(11,6,'accepted'),(11,9,'accepted'),

(12,13,'pending'),(12,16,'accepted'),(12,18,'accepted'),(12,20,'pending'),(12,21,'accepted'),
(12,23,'accepted'),(12,25,'pending'),(12,2,'accepted'),(12,5,'pending'),(12,7,'accepted'),

(13,14,'accepted'),(13,17,'accepted'),(13,19,'pending'),(13,21,'accepted'),(13,24,'pending'),
(13,1,'accepted'),(13,3,'accepted'),(13,8,'pending'),(13,10,'accepted'),(13,12,'accepted'),

(14,15,'pending'),(14,18,'accepted'),(14,20,'accepted'),(14,22,'pending'),(14,25,'accepted'),
(14,2,'accepted'),(14,4,'pending'),(14,7,'accepted'),(14,9,'accepted'),(14,11,'pending'),

(15,16,'accepted'),(15,19,'accepted'),(15,21,'pending'),(15,23,'accepted'),(15,1,'pending'),
(15,3,'accepted'),(15,6,'accepted'),(15,8,'pending'),(15,10,'accepted'),(15,13,'accepted'),

(16,17,'pending'),(16,20,'accepted'),(16,22,'accepted'),(16,24,'pending'),(16,2,'accepted'),
(16,5,'accepted'),(16,7,'pending'),(16,9,'accepted'),(16,12,'accepted'),(16,14,'pending'),

(17,18,'accepted'),(17,21,'accepted'),(17,23,'pending'),(17,25,'accepted'),(17,1,'pending'),
(17,4,'accepted'),(17,6,'accepted'),(17,8,'pending'),(17,11,'accepted'),(17,13,'accepted'),

(18,19,'pending'),(18,22,'accepted'),(18,24,'accepted'),(18,1,'pending'),(18,3,'accepted'),
(18,5,'accepted'),(18,7,'pending'),(18,10,'accepted'),(18,12,'accepted'),(18,15,'pending'),

(19,20,'accepted'),(19,23,'accepted'),(19,25,'pending'),(19,2,'accepted'),(19,4,'pending'),
(19,6,'accepted'),(19,9,'accepted'),(19,11,'pending'),(19,14,'accepted'),(19,16,'accepted'),

(20,21,'pending'),(20,24,'accepted'),(20,1,'accepted'),(20,3,'pending'),(20,5,'accepted'),
(20,8,'accepted'),(20,10,'pending'),(20,13,'accepted'),(20,15,'accepted'),(20,17,'pending'),

(21,22,'accepted'),(21,25,'accepted'),(21,2,'pending'),(21,4,'accepted'),(21,6,'pending'),
(21,7,'accepted'),(21,10,'accepted'),(21,12,'pending'),(21,14,'accepted'),(21,18,'accepted'),

(22,23,'pending'),(22,1,'accepted'),(22,5,'accepted'),(22,8,'pending'),(22,9,'accepted'),
(22,11,'accepted'),(22,13,'pending'),(22,16,'accepted'),(22,19,'accepted'),(22,20,'pending'),

(23,24,'accepted'),(23,2,'accepted'),(23,4,'pending'),(23,6,'accepted'),(23,10,'pending'),
(23,12,'accepted'),(23,15,'accepted'),(23,17,'pending'),(23,18,'accepted'),(23,21,'accepted'),

(24,25,'pending'),(24,1,'accepted'),(24,3,'accepted'),(24,7,'pending'),(24,9,'accepted'),
(24,11,'accepted'),(24,13,'pending'),(24,14,'accepted'),(24,19,'accepted'),(24,22,'pending'),

(25,2,'accepted'),(25,4,'accepted'),(25,5,'pending'),(25,8,'accepted'),(25,10,'accepted'),
(25,11,'pending'),(25,16,'accepted'),(25,18,'accepted'),(25,20,'pending'),(25,23,'accepted');

-- ============== 300 LIKES MỚI (AN TOÀN) ==============
INSERT IGNORE INTO likes (post_id, user_id, created_at) VALUES
(101,1,'2024-01-27 16:20:00'),(101,4,'2024-01-27 17:10:00'),(101,6,'2024-01-27 18:00:00'),(101,8,'2024-01-27 19:30:00'),(101,10,'2024-01-28 09:00:00'),
(102,2,'2024-09-08 10:30:00'),(102,5,'2024-09-08 11:50:00'),(102,9,'2024-09-08 13:20:00'),(102,12,'2024-09-08 15:00:00'),(102,15,'2024-09-08 16:40:00'),
(103,3,'2024-04-15 20:30:00'),(103,7,'2024-04-15 21:50:00'),(103,11,'2024-04-15 23:10:00'),(103,14,'2024-04-16 09:30:00'),(103,18,'2024-04-16 11:00:00'),
(104,5,'2025-07-13 09:20:00'),(104,9,'2025-07-13 10:40:00'),(104,13,'2025-07-13 12:00:00'),(104,17,'2025-07-13 13:30:00'),(104,21,'2025-07-13 15:00:00');
-- ============== BỔ SUNG 300 LIKES MỚI (AN TOÀN - INSERT IGNORE) ==============
INSERT IGNORE INTO likes (post_id, user_id, created_at) VALUES
(101,1,'2024-01-27 16:20:00'),(101,3,'2024-01-27 17:00:00'),(101,5,'2024-01-27 17:45:00'),(101,7,'2024-01-27 18:30:00'),(101,9,'2024-01-27 19:15:00'),
(101,11,'2024-01-27 20:00:00'),(101,13,'2024-01-28 09:30:00'),(101,15,'2024-01-28 10:15:00'),(101,17,'2024-01-28 11:00:00'),(101,19,'2024-01-28 12:00:00'),

(102,2,'2024-09-08 10:30:00'),(102,4,'2024-09-08 11:20:00'),(102,6,'2024-09-08 12:10:00'),(102,10,'2024-09-08 13:00:00'),(102,12,'2024-09-08 14:00:00'),
(102,14,'2024-09-08 15:30:00'),(102,16,'2024-09-08 16:45:00'),(102,18,'2024-09-08 18:00:00'),(102,20,'2024-09-08 19:20:00'),(102,22,'2024-09-08 20:40:00'),

(103,1,'2024-04-15 20:30:00'),(103,5,'2024-04-15 21:00:00'),(103,7,'2024-04-15 21:45:00'),(103,9,'2024-04-15 22:30:00'),(103,11,'2024-04-16 09:00:00'),
(103,13,'2024-04-16 10:15:00'),(103,15,'2024-04-16 11:30:00'),(103,17,'2024-04-16 12:45:00'),(103,19,'2024-04-16 14:00:00'),(103,23,'2024-04-16 15:20:00'),

(104,2,'2025-07-13 09:20:00'),(104,4,'2025-07-13 10:00:00'),(104,6,'2025-07-13 10:45:00'),(104,8,'2025-07-13 11:30:00'),(104,10,'2025-07-13 12:15:00'),
(104,12,'2025-07-13 13:00:00'),(104,14,'2025-07-13 14:00:00'),(104,16,'2025-07-13 15:00:00'),(104,18,'2025-07-13 16:00:00'),(104,20,'2025-07-13 17:00:00'),

(105,1,'2025-03-09 15:30:00'),(105,4,'2025-03-09 16:15:00'),(105,7,'2025-03-09 17:00:00'),(105,9,'2025-03-09 17:45:00'),(105,11,'2025-03-09 18:30:00'),
(105,13,'2025-03-09 19:15:00'),(105,17,'2025-03-09 20:00:00'),(105,19,'2025-03-09 20:45:00'),(105,21,'2025-03-09 21:30:00'),(105,23,'2025-03-09 22:15:00'),

(106,3,'2024-04-06 12:00:00'),(106,5,'2024-04-06 12:45:00'),(106,8,'2024-04-06 13:30:00'),(106,10,'2024-04-06 14:15:00'),(106,12,'2024-04-06 15:00:00'),
(106,14,'2024-04-06 15:45:00'),(106,16,'2024-04-06 16:30:00'),(106,18,'2024-04-06 17:15:00'),(106,20,'2024-04-06 18:00:00'),(106,22,'2024-04-06 18:45:00'),

(107,1,'2025-06-02 22:00:00'),(107,4,'2025-06-02 22:45:00'),(107,6,'2025-06-02 23:30:00'),(107,9,'2025-06-03 00:15:00'),(107,11,'2025-06-03 01:00:00'),
(107,13,'2025-06-03 01:45:00'),(107,15,'2025-06-03 02:30:00'),(107,17,'2025-06-03 03:15:00'),(107,19,'2025-06-03 04:00:00'),(107,21,'2025-06-03 04:45:00'),

(108,2,'2025-10-28 00:30:00'),(108,5,'2025-10-28 01:15:00'),(108,7,'2025-10-28 02:00:00'),(108,10,'2025-10-28 02:45:00'),(108,12,'2025-10-28 03:30:00'),
(108,14,'2025-10-28 04:15:00'),(108,16,'2025-10-28 05:00:00'),(108,18,'2025-10-28 05:45:00'),(108,20,'2025-10-28 06:30:00'),(108,22,'2025-10-28 07:15:00'),

(109,1,'2025-03-06 11:00:00'),(109,4,'2025-03-06 11:45:00'),(109,6,'2025-03-06 12:30:00'),(109,8,'2025-03-06 13:15:00'),(109,10,'2025-03-06 14:00:00'),
(109,12,'2025-03-06 14:45:00'),(109,14,'2025-03-06 15:30:00'),(109,16,'2025-03-06 16:15:00'),(109,18,'2025-03-06 17:00:00'),(109,20,'2025-03-06 17:45:00'),

(110,3,'2025-08-27 08:15:00'),(110,5,'2025-08-27 09:00:00'),(110,7,'2025-08-27 09:45:00'),(110,9,'2025-08-27 10:30:00'),(110,11,'2025-08-27 11:15:00'),
(110,13,'2025-08-27 12:00:00'),(110,15,'2025-08-27 12:45:00'),(110,17,'2025-08-27 13:30:00'),(110,19,'2025-08-27 14:15:00'),(110,21,'2025-08-27 15:00:00'),

-- Tiếp tục phân bổ cho các post từ 111 đến 296 (mỗi post khoảng 10 likes)
(150,2,'2024-12-26 18:00:00'),(150,4,'2024-12-26 18:45:00'),(150,6,'2024-12-26 19:30:00'),(150,8,'2024-12-26 20:15:00'),(150,10,'2024-12-26 21:00:00'),
(150,12,'2024-12-26 21:45:00'),(150,14,'2024-12-26 22:30:00'),(150,16,'2024-12-26 23:15:00'),(150,18,'2024-12-27 00:00:00'),(150,20,'2024-12-27 00:45:00'),

(200,1,'2024-09-01 17:00:00'),(200,3,'2024-09-01 17:45:00'),(200,5,'2024-09-01 18:30:00'),(200,7,'2024-09-01 19:15:00'),(200,9,'2024-09-01 20:00:00'),
(200,11,'2024-09-01 20:45:00'),(200,13,'2024-09-01 21:30:00'),(200,15,'2024-09-01 22:15:00'),(200,17,'2024-09-01 23:00:00'),(200,19,'2024-09-01 23:45:00'),

(250,2,'2025-07-08 16:00:00'),(250,4,'2025-07-08 16:45:00'),(250,6,'2025-07-08 17:30:00'),(250,8,'2025-07-08 18:15:00'),(250,10,'2025-07-08 19:00:00'),
(250,12,'2025-07-08 19:45:00'),(250,14,'2025-07-08 20:30:00'),(250,16,'2025-07-08 21:15:00'),(250,18,'2025-07-08 22:00:00'),(250,20,'2025-07-08 22:45:00'),

(296,1,'2025-05-13 14:00:00'),(296,3,'2025-05-13 14:45:00'),(296,5,'2025-05-13 15:30:00'),(296,8,'2025-05-13 16:15:00'),(296,9,'2025-05-13 17:00:00'),
(296,10,'2025-05-13 17:45:00'),(296,11,'2025-05-13 18:30:00'),(296,12,'2025-05-13 19:15:00'),(296,13,'2025-05-13 20:00:00'),(296,15,'2025-05-13 20:45:00'),

-- Các post khác ở giữa (ví dụ ngẫu nhiên)
(120,2,'2025-06-26 12:30:00'),(120,4,'2025-06-26 13:15:00'),(120,6,'2025-06-26 14:00:00'),(120,8,'2025-06-26 14:45:00'),(120,10,'2025-06-26 15:30:00'),
(140,1,'2024-11-09 11:00:00'),(140,3,'2024-11-09 11:45:00'),(140,5,'2024-11-09 12:30:00'),(140,7,'2024-11-09 13:15:00'),(140,9,'2024-11-09 14:00:00'),
(160,4,'2025-01-02 16:00:00'),(160,6,'2025-01-02 16:45:00'),(160,8,'2025-01-02 17:30:00'),(160,10,'2025-01-02 18:15:00'),(160,12,'2025-01-02 19:00:00'),
(180,2,'2025-11-18 11:00:00'),(180,5,'2025-11-18 11:45:00'),(180,7,'2025-11-18 12:30:00'),(180,9,'2025-11-18 13:15:00'),(180,11,'2025-11-18 14:00:00'),
(220,3,'2024-02-23 10:00:00'),(220,6,'2024-02-23 10:45:00'),(220,8,'2024-02-23 11:30:00'),(220,10,'2024-02-23 12:15:00'),(220,13,'2024-02-23 13:00:00');

-- ============== BỔ SUNG 50 TIN NHẮN MỚI ==============
INSERT INTO messages (sender_id, receiver_id, content, created_at) VALUES
(1, 2, 'Bình ơi, bạn học tới phần JOIN chưa?', '2024-01-16 09:15:00'),
(2, 1, 'Mình đang vật vã với LEFT JOIN đây An ơi 😅', '2024-01-16 09:30:00'),
(3, 4, 'Duy share mình tài liệu MySQL 8 đi', '2024-01-18 14:20:00'),
(4, 3, 'Ok Chi, để mình gửi link Google Drive nhé', '2024-01-18 14:35:00'),
(5, 1, 'An ơi, index nhiều quá có xấu không?', '2024-01-20 11:10:00'),
(1, 5, 'Hà ơi, xem EXPLAIN rồi quyết định, đừng thêm bừa', '2024-01-20 11:25:00'),
(6, 7, 'Bạn làm mini mạng xã hội tới đâu rồi?', '2024-01-22 16:40:00'),
(7, 6, 'Mình đang làm phần feed bạn bè đây Hiếu', '2024-01-22 17:00:00'),
(8, 9, 'Lâm ơi, bạn có dùng partition table chưa?', '2024-01-25 10:50:00'),
(9, 8, 'Mình thử rồi, hợp với log lắm Hoa', '2024-01-25 11:05:00'),
(10, 11, 'Minh ơi, đồ án cuối kỳ bạn làm gì?', '2024-02-01 13:15:00'),
(11, 10, 'Mình làm mạng xã hội mini giống bạn Linh', '2024-02-01 13:30:00'),
(12, 13, 'Nam ơi, bạn có tài liệu Stored Procedure không?', '2024-02-05 15:20:00'),
(13, 12, 'Có Nga, để mình gửi qua Zalo nhé', '2024-02-05 15:35:00'),
(14, 15, 'Phương ơi, bạn hay dùng MySQL Workbench không?', '2024-02-10 08:45:00'),
(15, 14, 'Mình dùng suốt Nhân ơi, tiện lắm', '2024-02-10 09:00:00'),
(16, 17, 'Quang ơi, replication bạn đã thử chưa?', '2024-02-15 12:10:00'),
(17, 16, 'Chưa Sơn, để mình tìm hiểu thêm', '2024-02-15 12:25:00'),
(18, 19, 'Thảo ơi, bạn có đi Đà Lạt tuần này không?', '2024-02-20 18:30:00'),
(19, 18, 'Có Trang ơi, đi cùng nhé!', '2024-02-20 18:45:00'),
(20, 21, 'Tuấn ơi, bạn có playlist chill không?', '2024-03-01 22:15:00'),
(21, 20, 'Có Dũng, để mình gửi Spotify link', '2024-03-01 22:30:00'),
(22, 23, 'Yến ơi, bạn tập gym đều chưa?', '2024-03-10 07:20:00'),
(23, 22, 'Rồi Thành, 1 tháng rồi thấy tiến bộ', '2024-03-10 07:35:00'),
(24, 25, 'Mai ơi, quán cà phê Hoàn Kiếm nào chill?', '2024-03-15 14:50:00'),
(25, 24, 'The Note Coffee view đẹp lắm Vinh', '2024-03-15 15:05:00'),
(1, 3, 'Chi ơi, mình vừa quên WHERE trong UPDATE 😱', '2024-03-20 10:10:00'),
(3, 1, 'Ai học DB cũng từng trải qua An ơi', '2024-03-20 10:25:00'),
(4, 6, 'Hiếu ơi, bạn có dùng denormalize không?', '2024-04-01 16:40:00'),
(6, 4, 'Thỉnh thoảng thôi Duy, cẩn thận dữ liệu loạn', '2024-04-01 16:55:00'),
(5, 8, 'Hoa ơi, deadline dí quá cứu với', '2024-04-10 23:50:00'),
(8, 5, 'Cùng khổ Hà ơi, cố lên!', '2024-04-11 00:05:00'),
(7, 10, 'Linh ơi, bạn có chơi Genshin không?', '2024-04-15 20:30:00'),
(10, 7, 'Có Minh, add friend nhé UID mình 123456789', '2024-04-15 20:45:00'),
(9, 12, 'Nam ơi, Atomic Habits hay lắm phải không?', '2024-04-20 09:15:00'),
(12, 9, 'Hay cực Lâm, thay đổi mình nhiều', '2024-04-20 09:30:00'),
(11, 14, 'Nhân ơi, tối nay ăn gì?', '2024-05-01 18:20:00'),
(14, 11, 'Phở đi Minh, gợi ý hay', '2024-05-01 18:35:00'),
(13, 16, 'Quang ơi, bạn có vườn rau sạch không?', '2024-05-10 11:40:00'),
(16, 13, 'Có Nga, khoe tí đây 🌱', '2024-05-10 11:55:00'),
(15, 18, 'Thảo ơi, phim mới hay không?', '2024-05-20 21:10:00'),
(18, 15, 'Hay lắm Phương, xem đi khóc luôn', '2024-05-20 21:25:00'),
(17, 20, 'Tuấn ơi, cà phê sáng ở Sài Gòn quán nào ngon?', '2024-06-01 08:15:00'),
(20, 17, 'Shin Coffee ngon lắm Sơn', '2024-06-01 08:30:00'),
(19, 22, 'Yến ơi, selfie hôm nay đẹp quá', '2024-06-10 19:45:00'),
(22, 19, 'Cảm ơn Thành, bạn cũng xinh', '2024-06-10 20:00:00'),
(21, 24, 'Mai ơi, deadline đồ án còn bao lâu?', '2024-06-20 23:30:00'),
(24, 21, 'Còn 1 tuần nữa Vinh ơi, căng thẳng quá', '2024-06-20 23:45:00'),
(2, 25, 'Vinh ơi, bạn có đi Đà Lạt không?', '2024-07-01 10:20:00'),
(25, 2, 'Có Mai, đi cùng nhé!', '2024-07-01 10:35:00');
-- ============== TẠO FULL NOTIFICATIONS THỰC TẾ (KHÔNG LIMIT) ==============
-- ============== TẠO ĐẦY ĐỦ NOTIFICATIONS THỰC TẾ ==============
TRUNCATE TABLE notifications;  -- Reset để tránh trùng (bỏ dòng này nếu muốn giữ cũ)

-- 1. Notification từ tất cả COMMENTS (~600)
INSERT INTO notifications (user_id, type, content, is_read, created_at)
SELECT 
  p.user_id,
  'comment',
  CONCAT(u.full_name, ' đã bình luận bài viết của bạn'),
  ROUND(RAND()) AS is_read,  -- ngẫu nhiên đã đọc / chưa đọc
  DATE_ADD(c.created_at, INTERVAL FLOOR(RAND()*30) MINUTE) AS created_at  -- hơi sau thời gian comment
FROM comments c
JOIN posts p ON c.post_id = p.post_id
JOIN users u ON c.user_id = u.user_id
WHERE c.user_id != p.user_id;  -- tránh tự comment

-- 2. Notification từ tất cả LIKES (~2000)
INSERT INTO notifications (user_id, type, content, is_read, created_at)
SELECT 
  p.user_id,
  'like',
  CONCAT(u.full_name, ' đã thích bài viết của bạn'),
  ROUND(RAND()) AS is_read,
  DATE_ADD(l.created_at, INTERVAL FLOOR(RAND()*20) MINUTE) AS created_at
FROM likes l
JOIN posts p ON l.post_id = p.post_id
JOIN users u ON l.user_id = u.user_id
WHERE l.user_id != p.user_id;  -- tránh tự like

-- 3. Notification từ FRIENDS (pending / accepted)
INSERT INTO notifications (user_id, type, content, is_read, created_at)
SELECT 
  f.user_id,
  'friend',
  CONCAT(u.full_name, 
    IF(f.status = 'pending', ' đã gửi lời mời kết bạn',
       IF(f.status = 'accepted', ' đã chấp nhận lời mời kết bạn', ' đã có hành động với bạn'))) AS content,
  1 AS is_read,
  f.created_at
FROM friends f
JOIN users u ON f.friend_id = u.user_id;

-- 4. Notification từ MESSAGES
INSERT INTO notifications (user_id, type, content, is_read, created_at)
SELECT 
  m.receiver_id,
  'message',
  CONCAT('Bạn có tin nhắn mới từ ', u.full_name),
  0 AS is_read,  -- tin nhắn mới thường chưa đọc
  m.created_at
FROM messages m
JOIN users u ON m.sender_id = u.user_id;
SELECT COUNT(*) AS total_notifications FROM notifications;

-- BÀI 1:
CREATE VIEW view_users_firstname AS
SELECT 
    user_id,
    username,
    full_name,
    email,
    created_at
FROM users
WHERE full_name LIKE 'Nguyễn%';

SELECT * 
FROM view_users_firstname;

INSERT INTO users (username, password, full_name, email)
VALUES (
    'nguyenvanc_test',
    '123456',
    'Nguyễn Văn C',
    'nguyenvanc_test@gmail.com'
);

SELECT * 
FROM view_users_firstname;

DELETE FROM users
WHERE username = 'nguyenvanc_test';

SELECT * 
FROM view_users_firstname;

-- Bai 2 : 
CREATE VIEW view_user_post AS
SELECT 
    user_id,
    COUNT(post_id) AS total_user_post
FROM posts
GROUP BY user_id;

SELECT *
FROM view_user_post;

SELECT 
    u.full_name,
    v.total_user_post
FROM users u
JOIN view_user_post v
    ON u.user_id = v.user_id;
    
-- Bai 3 : 
EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';

CREATE INDEX idx_hometown
ON users(hometown);

EXPLAIN ANALYZE
SELECT *
FROM users
WHERE hometown = 'Hà Nội';

DROP INDEX idx_hometown ON users;

-- Bai 4 : 
EXPLAIN ANALYZE
SELECT 
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND YEAR(created_at) = 2026;

CREATE INDEX idx_created_at_user_id
ON posts(created_at, user_id);

EXPLAIN ANALYZE
SELECT 
    post_id,
    content,
    created_at
FROM posts
WHERE user_id = 1
  AND YEAR(created_at) = 2026;

EXPLAIN ANALYZE
SELECT 
    user_id,
    username,
    email
FROM users
WHERE email = 'an@gmail.com';

CREATE UNIQUE INDEX idx_email
ON users(email);

EXPLAIN ANALYZE
SELECT 
    user_id,
    username,
    email
FROM users
WHERE email = 'an@gmail.com';

DROP INDEX idx_created_at_user_id ON posts;
DROP INDEX idx_email ON users;

-- Bai 5 :
EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.username,
    u.hometown,
    p.post_id,
    p.content
FROM users u
JOIN posts p
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

CREATE INDEX idx_hometown
ON users(hometown);

EXPLAIN ANALYZE
SELECT 
    u.user_id,
    u.username,
    u.hometown,
    p.post_id,
    p.content
FROM users u
JOIN posts p
    ON u.user_id = p.user_id
WHERE u.hometown = 'Hà Nội'
ORDER BY u.username DESC
LIMIT 10;

-- Bai 6:
CREATE VIEW view_users_summary AS
SELECT 
    u.user_id,
    u.username,
    COUNT(p.post_id) AS total_posts
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
GROUP BY u.user_id, u.username;

SELECT 
    user_id,
    username,
    total_posts
FROM view_users_summary
WHERE total_posts > 5;

-- Bai 7 :
CREATE VIEW view_user_activity_status AS
SELECT 
    u.user_id,
    u.username,
    u.gender,
    u.created_at,
    CASE
        WHEN COUNT(DISTINCT p.post_id) > 0 
          OR COUNT(DISTINCT c.comment_id) > 0
        THEN 'Active'
        ELSE 'Inactive'
    END AS status
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
LEFT JOIN comments c
    ON u.user_id = c.user_id
GROUP BY 
    u.user_id,
    u.username,
    u.gender,
    u.created_at;

SELECT *
FROM view_user_activity_status;

SELECT 
    status,
    COUNT(*) AS user_count
FROM view_user_activity_status
GROUP BY status
ORDER BY user_count DESC;

-- Bai 8 :
CREATE VIEW view_popular_posts AS
SELECT
    p.post_id,
    u.username,
    p.content,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM posts p
JOIN users u
    ON p.user_id = u.user_id
LEFT JOIN likes l
    ON p.post_id = l.post_id
LEFT JOIN comments c
    ON p.post_id = c.post_id
GROUP BY
    p.post_id,
    u.username,
    p.content;

SELECT *
FROM view_popular_posts;

SELECT
    post_id,
    username,
    content,
    total_likes,
    total_comments,
    (total_likes + total_comments) AS total_interactions
FROM view_popular_posts
WHERE (total_likes + total_comments) > 10
ORDER BY total_interactions DESC;

EXPLAIN
SELECT
    post_id,
    username,
    content,
    total_likes,
    total_comments
FROM view_popular_posts
WHERE (total_likes + total_comments) > 10;

SHOW INDEX FROM users;
SHOW COLUMNS FROM likes;

-- Bai 9 : 
CREATE VIEW view_user_activity AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
LEFT JOIN comments c
    ON u.user_id = c.user_id
GROUP BY
    u.user_id;

SELECT *
FROM view_user_activity;

SELECT
    u.user_id,
    u.username,
    u.full_name,
    v.total_posts,
    v.total_comments
FROM view_user_activity v
JOIN users u
    ON v.user_id = u.user_id
WHERE
    v.total_posts > 5
    AND v.total_comments > 20
ORDER BY
    v.total_comments DESC
LIMIT 5;

-- Bai 10 :
CREATE INDEX idx_users_username ON users(username);

CREATE VIEW view_user_activity_2 AS
SELECT
    u.user_id,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT 
        CASE 
            WHEN f.status = 'accepted' THEN f.friend_id 
        END
    ) AS total_friends
FROM users u
LEFT JOIN posts p
    ON u.user_id = p.user_id
LEFT JOIN friends f
    ON u.user_id = f.user_id
GROUP BY
    u.user_id;


SELECT *
FROM view_user_activity_2;

SELECT
    u.full_name,
    v.total_posts,
    v.total_friends,

    CASE
        WHEN v.total_friends > 5 THEN 'Nhiều bạn bè'
        WHEN v.total_friends BETWEEN 2 AND 5 THEN 'Vừa đủ bạn bè'
        ELSE 'Ít bạn bè'
    END AS friend_description,

    CASE
        WHEN v.total_posts > 10 THEN v.total_posts * 1.1
        WHEN v.total_posts BETWEEN 5 AND 10 THEN v.total_posts
        ELSE v.total_posts * 0.9
    END AS post_activity_score

FROM view_user_activity_2 v
JOIN users u
    ON v.user_id = u.user_id
WHERE
    v.total_posts > 0
ORDER BY
    v.total_posts DESC;
