CREATE DATABASE StudentDB;
USE StudentDB;
-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);




-- tạo các bảng
create table department (
  deptid char(5) primary key,
  deptname varchar(50)
);

create table student (
  studentid char(6) primary key,
  fullname varchar(50),
  gender varchar(10),
  birthdate date,
  deptid char(5),
  foreign key (deptid) references department(deptid)
);

create table course (
  courseid char(6) primary key,
  coursename varchar(50),
  credits int
);

create table enrollment (
  studentid char(6),
  courseid char(6),
  score float,
  primary key (studentid, courseid),
  foreign key (studentid) references student(studentid),
  foreign key (courseid) references course(courseid)
);

-- thêm dữ liệu mẫu
insert into department (deptid, deptname) values
  ('it001','information technology'),
  ('d0002','mathematics'),
  ('d0003','physics');

insert into course (courseid, coursename, credits) values
  ('c00001','database systems',3),
  ('c00002','algorithms',3),
  ('c00003','data structures',4);

insert into student (studentid, fullname, gender, birthdate, deptid) values
  ('s00001','nguyen van a','male','2000-01-01','it001'),
  ('s00002','tran thi b','female','2000-02-02','d0002'),
  ('s00003','le van c','male','2000-03-03','it001'),
  ('s00004','pham thi d','female','2000-04-04','it001'),
  ('s00005','hoang van e','male','2000-05-05','d0003');

insert into enrollment (studentid, courseid, score) values
  ('s00001','c00001',9.5),
  ('s00002','c00001',8.0),
  ('s00003','c00001',10.0),
  ('s00004','c00001',7.5),
  ('s00001','c00002',7.0),
  ('s00003','c00002',8.5),
  ('s00005','c00003',9.0);

-- phần a - cơ bản

-- câu 1: tạo view view_studentbasic và truy vấn
create or replace view view_studentbasic as
	select s.studentid, s.fullname, d.deptname
	from student s
	join department d on s.deptid = d.deptid;

select s.studentid, s.fullname, d.deptname from view_studentbasic;

-- câu 2: tạo regular index cho cột fullname
create index idx_student_fullname on student(fullname);

-- câu 3: stored procedure getstudentsit
delimiter $$
create procedure getstudentsit()
begin
  select s.studentid, s.fullname, s.gender, s.birthdate, d.deptname
  from student s
  join department d on s.deptid = d.deptid
  where d.deptname = 'information technology';
end $$
delimiter ;

call getstudentsit();

-- phần b - khá
-- câu 4a: view view_studentcountbydept
create or replace view view_studentcountbydept as
	select d.deptname, count(s.studentid) as totalstudents
	from department d
	left join student s on d.deptid = s.deptid
	group by d.deptname;

-- câu 4b: khoa có nhiều sinh viên nhất
select deptname, totalstudents
from view_studentcountbydept
order by totalstudents desc
limit 1;

-- câu 5: stored procedure gettopscorestudent
delimiter $$
create procedure gettopscorestudent(in p_courseid char(6))
begin
  select e.studentid, s.fullname, e.courseid, c.coursename, e.score
  from enrollment e
  join student s on e.studentid = s.studentid
  join course c on e.courseid = c.courseid
  where e.courseid = p_courseid
  order by e.score desc
  limit 1;
end $$
delimiter ;

call gettopscorestudent('c00001');

-- phần c - giỏi
-- bài 6a: tạo view view_it_enrollment_db với check option
create or replace view view_it_enrollment_db as
select e.studentid, e.courseid, e.score
from enrollment e
where e.courseid = 'c00001'
  and e.studentid in (
    select s.studentid 
    from student s
    join department d on s.deptid = d.deptid
    where d.deptname = 'information technology'
  )
with cascaded check option;

-- bài 6b: stored procedure updatescore_it_db
delimiter $$
create procedure updatescore_it_db(
  in p_studentid char(6), 
  inout p_newscore float
)
begin
  if p_newscore > 10 then
    set p_newscore = 10;
  end if;
    update view_it_enrollment_db
  set score = p_newscore
  where studentid = p_studentid and courseid = 'c00001';
end $$
delimiter ;

-- bài 6c: gọi thủ tục và kiểm tra
set @newscore = 11;
call updatescore_it_db('s00001', @newscore);
select @newscore as 'diem moi sau khi cap nhat';
select * from view_it_enrollment_db where studentid = 's00001';
select * from view_it_enrollment_db;
