create database course_online;
use course_online;

create table students (
	student_id int primary key auto_increment,
    full_name varchar(100),
    email varchar(255),
    gender enum('male','female','other'),
    date_of_birth date,
    class_name varchar(20)
);

create table subjects (
	subject_id int primary key auto_increment,
    subject_name varchar(255),
    credit_hours int
);

create table enrollment (
	subject_id int,
    student_id int,
    semeter varchar(20),
    regist_date datetime,
    primary key (subject_id, student_id),
    foreign key (subject_id) references subjects (subject_id),
    foreign key (student_id) references students (student_id)
);

-- 1. thêm ít nhất cho thầy 5 dữ liệu cho mỗi bảng
-- Bảng student
insert into students (full_name, email, gender, date_of_birth, class_name) values
('nguyễn văn a', 'a@gmail.com', 'male', '2002-01-10', 'cntt01'),
('trần thị b', 'b@gmail.com', 'female', '2002-03-15', 'cntt01'),
('lê văn c', 'c@gmail.com', 'male', '2001-07-20', 'cntt02'),
('phạm thị d', 'd@gmail.com', 'female', '2002-11-05', 'cntt02'),
('hoàng văn e', 'e@gmail.com', 'male', '2001-09-30', 'cntt03');
-- Bảng Subjects
insert into subjects (subject_name, credit_hours) values
('lập trình c', 3),
('cơ sở dữ liệu', 3),
('lập trình java', 4),
('mạng máy tính', 3),
('hệ điều hành', 3);
-- Bảng enrollment
insert into enrollment (subject_id, student_id, semeter, regist_date) values
(1, 1, 'hk1-2024', now()),
(2, 1, 'hk1-2024', now()),
(3, 2, 'hk1-2024', now()),
(4, 3, 'hk1-2024', now()),
(5, 4, 'hk1-2024', now());

-- 2. sửa cho tên sinh viên Giỏi vào sau tên sinh --> Nguyễn Văn A --> Nguyễn văn A Giỏi
update students
set full_name = concat(full_name, ' giỏi');
-- 3. Sửa cho môn học 'Lập trình C' --> 'Môn học lập trình C'
update subjects
set subject_name = concat('môn học ', subject_name);

-- 4. Xóa nhưng môn học có mã 2, 3
delete from enrollment
where subject_id in (2, 3);
-- Xóa đơn đăng ký vì nó có liên quan đến subjects
delete from subjects
where subject_id in (2, 3);

-- 5. Đăng ký môn học 1 cho sinh viên 2
insert into enrollment (subject_id, student_id, semeter, regist_date)
values (1, 2, 'hk1-2024', now());

-- 6. Hủy đăng ký môn học 1 cho sinh viên 2
delete from enrollment
where subject_id = 1
  and student_id = 2;