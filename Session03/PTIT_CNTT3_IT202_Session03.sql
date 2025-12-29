create database IT202_Session03;
use IT202_Session03;

-- Bài 02+ Bài 03: 
-- Bảng Student 
create table student(
	student_id int primary key auto_increment,
    full_name varchar(100) not null,
    date_of_birth date not null,
    email varchar(100) unique not null
);
-- Thêm mới học sinh
insert into student(full_name, date_of_birth, email)
values('Nguyễn Văn A', '2002-09-20', 'nguyenvana@gmail.com'),('Trương Việt Hoàng', '2006-02-08', 'viethoang2006@gmail.com'),
('Hoàng Minh Việt', '2005-11-01', 'viethoang2005@gmail.com'),('Trần Quang Thành', '2000-06-12', 'thanhtran2000@gmail.com'),
('Mai Phương Ánh', '2004-12-09', 'maianh2004');
-- Hiển thị toàn bộ học sinh
select * from student;
-- Hiển thị cột mã và tên học sinh
select student_id, full_name from student;
-- Cập nhật email
update student
set email = 'viethoang@gmail.com'
where student_id=3;
-- Cập nhật ngày sinh
update student 
set date_of_birth='2009-08-29'
where student_id=2;

select * from student;
-- Xóa học sinh
delete from student where student_id=5;

select * from student;
-- Bài 03:
-- Tạo bảng môn học
create table subjects(
	subject_id int primary key auto_increment,
    subject_name varchar(50) not null,
    credit int check(credit>0)
);
-- Thêm mới dữ liệu
insert into subjects(subject_name, credit)
values('ReactJS',5),('Python',4),('Frontend',4),('C++',3);
select * from subjects;
-- Cập nhật tín chỉ và tên môn học
update subjects
set credit=2
where subject_id=2;
update subjects
set subject_name='Scratch'
where subject_id=2;
select * from subjects;
-- Bài 04:
-- Tạo bảng Enrollment
create table enrollment(
	student_id int,
    foreign key (student_id) references student(student_id),
    subject_id int,
    foreign key (subject_id) references subjects(subject_id),
    primary key(student_id, subject_id),
    enroll_date date default(current_date)
);
-- Thêm mới các dữ liệu 
insert into enrollment(student_id, subject_id)
values(1,2),(1,1),(2,2),(2,1),(3,2),(3,3),(4,4),(4,2);
-- Hiển thị dữ liệu
select * from enrollment;
-- Hiển thị lượt đăng ký của 1 sinh viên
select * from enrollment where student_id=1;
-- Bài 05:
-- Tạo bảng Điểm môn học
create table score(
	student_id int,
    foreign key (student_id) references student(student_id),
    subject_id int,
    foreign key (subject_id) references subjects(subject_id),
    primary key(student_id, subject_id),
    mid_score float check(mid_score>0 and mid_score<=10),
    final_score float check(final_score>0 and final_score<=10)
);
-- Thêm dữ liệu 
insert into score(student_id, subject_id, mid_score, final_score)
values(1,3,6.7,9),(2,4,4,3),(1,4,10,9),(3,1,6.2,7),(2,3,7,7) ;
-- Cập nhật dữ liệu 
update score
set final_score=8
where student_id=3 and subject_id=1;
-- Lấy dữ liệu 
select * from score;
select * from score where final_score>=8;
-- Bài 06
-- Thêm mới 1 học sinh
insert into student(full_name,date_of_birth, email)
values('Nguyễn Văn Chanh', '2007-07-07','nguyenvanchanh07@gmail.com');
-- Đăng ký 2 môn cho học sinh đó 
insert into enrollment(student_id, subject_id)
values (last_insert_id(), 2), (last_insert_id(), 3), (last_insert_id(), 1);
select * from enrollment where student_id= last_insert_id();
-- Thêm và cập nhật điểm cho học sinh đó 
insert into score (student_id, subject_id, mid_score, final_score)
values(last_insert_id(), 1,8,9),(last_insert_id(),4,10,2);
update score 
set final_score=7
where student_id=last_insert_id() and subject_id=4;
-- Xóa lượt đăng ký không hợp lệ vì môn đó đã học và có điểm
delete from enrollment where student_id=last_insert_id() and student_id=1;
select * from enrollment where student_id= last_insert_id();
-- Lấy ra danh sách sinh viên và số điểm tương ứng
select * from score where student_id=last_insert_id();
