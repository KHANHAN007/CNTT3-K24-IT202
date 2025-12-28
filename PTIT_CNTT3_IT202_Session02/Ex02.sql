drop database if exists ex02_v2;
create database ex02_v2;

use ex02_v2;

create table class (
    class_code   varchar(20) primary key,
    class_title  varchar(100) not null,
    academic_year year not null,

    unique (class_title)
);

create table student (
    student_code varchar(20) primary key,
    student_name varchar(100) not null,
    birth_date   date not null,
    class_code   varchar(20) not null,

    constraint fk_student_class
        foreign key (class_code)
        references class(class_code)
);

create table teacher (
    teacher_code varchar(20) primary key,
    teacher_name varchar(100) not null,
    email        varchar(100) unique
);

create table subject (
    subject_code varchar(20) primary key,
    subject_title varchar(100) not null,
    credits       int not null,
    teacher_code  varchar(20),

    constraint chk_subject_credits
        check (credits > 0),

    constraint fk_subject_teacher
        foreign key (teacher_code)
        references teacher(teacher_code)
);

create table enrollment (
    student_code varchar(20),
    subject_code varchar(20),
    registered_at date not null,

    primary key (student_code, subject_code),

    constraint fk_enroll_student
        foreign key (student_code)
        references student(student_code),

    constraint fk_enroll_subject
        foreign key (subject_code)
        references subject(subject_code)
);

create table score (
    student_code varchar(20),
    subject_code varchar(20),
    mid_score    decimal(4,2),
    end_score    decimal(4,2),

    primary key (student_code, subject_code),

    constraint chk_mid_score
        check (mid_score between 0 and 10),

    constraint chk_end_score
        check (end_score between 0 and 10),

    constraint fk_score_student
        foreign key (student_code)
        references student(student_code),

    constraint fk_score_subject
        foreign key (subject_code)
        references subject(subject_code)
);
