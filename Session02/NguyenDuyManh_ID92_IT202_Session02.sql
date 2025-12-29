-- Bài 2: 
-- Bảng class
create table class (
    class_id int primary key,
    class_name varchar(100) not null,
    school_year varchar(20) not null
);
--   Bảng Student
create table student (
    student_id int primary key,
    full_name varchar(100) not null,
    date_of_birth date not null,
    class_id int not null,
	foreign key (class_id) references class(class_id)
);

-- Bài 3 và Bài 4 :
-- Bảng Student đã có ở Bài 2
-- Bảng Môn Học
create table subjects (
    subject_id int primary key,
    subject_name varchar(100) not null,
    credits int not null check (credits > 0)
);
-- Bảng Đăng ký
create table enrollment (
    student_id int not null,
    subject_id int not null,
    enroll_date date not null,
    primary key (student_id, subject_id),
	foreign key (student_id) references student(student_id),
	foreign key (subject_id) references subjects(subject_id)
);
--   Bài 05:
-- Bảng Teacher
create table teacher (
    teacher_id int primary key,
    full_name varchar(100) not null,
    email varchar(100) not null,
    constraint uq_teacher_email unique (email)
);
-- Cập nhật Bảng Subject
alter table subjects
add teacher_id int not null;
alter table subjects
add foreign key (teacher_id) references teacher(teacher_id);
-- Bài 06:
-- Bảng Score
create table score (
    student_id int not null,
    subject_id int not null,
    process_score decimal(4,2) not null check (process_score between 0 and 10),
    final_score decimal(4,2) not null check (final_score between 0 and 10),
    primary key (student_id, subject_id),
	foreign key (student_id) references student(student_id),
	foreign key (subject_id) references subjects(subject_id)
);

drop table score;
drop table enrollment;
drop table subjects;
drop table teacher;
drop table student;
drop table class;

-- Bài 7: Đã hoàn thiện CSDL

