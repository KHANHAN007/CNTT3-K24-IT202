
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
    semester varchar(20),
    register_date datetime,
    primary key (subject_id, student_id),
    foreign key (subject_id) references subjects(subject_id),
    foreign key (student_id) references students(student_id)
);

insert into students (full_name, email, gender, date_of_birth, class_name) values
('Nguyen Van An', 'an.nguyen@gmail.com', 'male', '2003-01-10', 'CNTT01'),
('Tran Thi Binh', 'binh.tran@gmail.com', 'female', '2003-02-15', 'CNTT01'),
('Le Hoang Long', 'long.le@gmail.com', 'male', '2002-12-20', 'CNTT02'),
('Pham Thi Mai', 'mai.pham@gmail.com', 'female', '2003-03-05', 'CNTT02'),
('Hoang Van Duc', 'duc.hoang@gmail.com', 'other', '2002-11-11', 'CNTT03');

insert into subjects (subject_name, credit_hours) values
('Lap trinh C', 3),
('Co so du lieu', 3),
('Mang may tinh', 3),
('He dieu hanh', 4),
('Lap trinh Web', 3);

insert into enrollment (subject_id, student_id, semester, register_date) values
(1, 1, 'HK1-2024', now()),
(2, 1, 'HK1-2024', now()),
(3, 2, 'HK1-2024', now()),
(1, 3, 'HK1-2024', now()),
(4, 4, 'HK1-2024', now());

update students
set full_name = concat(full_name, ' Gioi')
where student_id = 1;

update subjects
set subject_name = 'Mon hoc lap trinh C'
where subject_id = 1;

delete from enrollment
where subject_id in (2, 3);

delete from subjects
where subject_id in (2, 3);

insert into enrollment (subject_id, student_id, semester, register_date)
values (1, 2, 'HK1-2024', now());

delete from enrollment
where subject_id = 1
  and student_id = 2;
