CREATE DATABASE Session03;
USE Session03;

-- Bai 1 : 
create table student (
    student_id varchar(20) primary key,
    full_name varchar(100) not null,
    date_of_birth date,
    email varchar(100) unique
);

insert into student (student_id, full_name, date_of_birth, email) values
('sv001', 'nguyen van an', '2003-05-10', 'an@gmail.com'),
('sv002', 'tran thi binh', '2002-12-11', 'binh@gmail.com'),
('sv003', 'le hoang long', '2002-12-01', 'long@gmail.com');

select * from student;

select student_id, full_name
from student;

-- Bai 2 : 
update student
set email = 'newemail3@gmail.com'
where student_id = 'sv003';

update student
set date_of_birth = '2003-09-15'
where student_id = 'sv002';

delete from student
where student_id = 'sv005';

-- Bai 3 :
create table subject (
    subject_id int primary key,
    subject_name varchar(100) not null,
    credit int not null check (credit > 0)
);

insert into subject (subject_id, subject_name, credit) values
(1, 'co so du lieu', 3),
(2, 'lap trinh c', 4),
(3, 'mang may tinh', 3);

select * from subject;

update subject
set credit = 4
where subject_id = 1;

update subject
set subject_name = 'lap trinh c nang cao'
where subject_id = 2;

-- Bai 4 :
create table enrollment (
	student_id varchar(20) not null,
    subject_id int not null,
    enroll_date date not null,

    primary key (student_id, subject_id),
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id)
);

insert into enrollment (student_id, subject_id, enroll_date) values
('sv001', 1, '2024-09-01'),
('sv001', 2, '2024-09-01'),
('sv002', 1, '2024-09-02'),
('sv003', 3, '2024-09-03');

select * from enrollment;

-- Bai 5 :
create table score (
    student_id varchar(20) not null,
    subject_id int not null,
    mid_score decimal(4,2),
    final_score decimal(4,2),

    primary key (student_id, subject_id),
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id)
);

insert into score (student_id, subject_id, mid_score, final_score) values
('sv001', 1, 7.5, 8.5),
('sv002', 1, 8.0, 9.0),
('sv001', 2, 6.5, 7.0);

update score
set final_score = 8.8
where student_id = 'sv001'
  and subject_id = 2;

select * from score;

select *
from score
where final_score >= 8;

-- Bai 6 :
insert into student (student_id, full_name, date_of_birth, email) values
('sv004', 'pham thi nhi', '2003-07-20', 'nhi@gmail.com');

select * from student;

insert into enrollment (student_id, subject_id, enroll_date) values
('sv004', 1, '2024-09-05'),
('sv004', 2, '2024-09-05');

select * from enrollment;

insert into score (student_id, subject_id, mid_score, final_score) values
('sv004', 1, 7.0, 8.0),
('sv004', 2, 6.5, 7.5);

update score
set final_score = 8.5
where student_id = 'sv004'
  and subject_id = 2;

select * from score;

delete from enrollment
where student_id = 'sv004'
  and subject_id = 1;

select
    a.student_id,
    a.full_name,
    b.subject_name,
    c.mid_score,
    c.final_score
from student a
join score c 
on a.student_id = c.student_id
join subject b 
on c.subject_id = b.subject_id;



 






