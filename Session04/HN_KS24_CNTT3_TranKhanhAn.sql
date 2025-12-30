create database btth;
use btth;

create table Student(
student_id int primary key auto_increment,
student_name varchar(100) not null,
student_email varchar(100) not null unique,
student_phone varchar(11)not null
);

create table Courge (
courge_id int primary key,
courge_name varchar(100) not null,
credit_hours int check(credit_hours between 1 and 10)
);

create table Enrollment(
grade decimal(4,2) check (grade between 0 and 10) default 0,
student_id int,
courge_id int,
foreign key(student_id) references Student(student_id),
foreign key(courge_id) references Courge(courge_id)
);

insert into Student(student_name,student_email,student_phone)
values('trankhanhan','trankhanhan@gmail.com','0123456789'),
	  ('trankhanhan2','trankhanhan2@gmail.com','0123456789'),
	  ('trankhanhan3','trankhanhan3@gmail.com','0123456789'),
	  ('trankhanhan4','trankhanhan4@gmail.com','0123456789'),
      ('trankhanhan5','trankhanhan5@gmail.com','0123456789');

insert into Courge(courge_id,courge_name,credit_hours)
values(101,'IT01',5),
      (102,'IT02',3),
      (103,'IT03',4),
      (104,'IT04',6),
      (105,'IT05',3);
      
insert into enrollment(grade,student_id,courge_id)
values(9,1,101),
      (5,2,102),
      (3,3,103),
      (4,4,104),
      (2,5,105);
      
update Enrollment
set grade = 9
where student_id = 2 and courge_id = 102;

select student_name,student_email,student_phone from Student;

delete  from Courge
where courge_id=101

