pragma foreign_keys = on;

create table if not exists educationalDirection(
    id integer primary key not null unique,
    name varchar not null
);

create table if not exists discipline(
    id integer primary key autoincrement,
    name varchar unique not null
);

create table if not exists plan(
    id integer primary key autoincrement,
    assessmentType varchar default 'exam' check (assessmentType == 'exam' or assessmentType == 'offset'),
    disciplineId integer not null,
    semesterNumber integer check (semesterNumber >= 1 and semesterNumber <= 8),
    planId integer not null,
    foreign key (disciplineId) references discipline(id) on delete cascade,
    foreign key (planId) references educationalDirection(id) on delete restrict
);



create table if not exists `group`(
    id integer primary key autoincrement,
    startDate varchar not null,
    groupNumber integer not null
);

create table if not exists student(
    studentsNumber integer primary key not null unique,
    name varchar not null,
    surname varchar not null,
    lastname varchar not null,
    sex varchar check (sex == 'мужской' or sex == 'женский'),
    birthDate varchar not null,
    groupId integer not null,
    educationalDirectionId integer not null,
    foreign key (educationalDirectionId) references educationalDirection(id) on delete restrict,
    foreign key (groupId) references `group`(id) on delete restrict
);

create table if not exists marks(
    id integer primary key autoincrement,
    mark integer check(mark >= 3 and mark <= 5),
    studentId integer not null,
    disciplineId integer not null,
    foreign key (studentId) references student(studentsNumber) on delete cascade,
    foreign key (disciplineId) references discipline(id) on delete restrict
);

-- data filling

insert into educationalDirection(id, name) values
(4, 'Программная инженерия'),
(3, 'Прикладная математика и информатика');

insert into discipline(name) values
('Математический анализ'),
('Численные методы'),
('Базы данных'),
('Алгебра и геометрия'),
('Уравнения математической физики'),
('Теоретическая механика'),
('Право'),
('Физика'),
('Практикум ЭВМ'),
('Аналитическая геометрия'),
('Алгоритмы и структуры данных');

insert into plan(assessmentType, disciplineId, semesterNumber, planId)
select 'exam', id, 1, 4 from discipline where name='Математический анализ'
union
select 'exam', id, 1, 4 from discipline where name='Алгебра и геометрия'
union
select 'offset', id, 1, 4 from discipline where name='Практикум ЭВМ'
union
select 'exam', id, 1, 4 from discipline where name='Аналитическая геометрия'
union
select 'offset', id, 1, 4 from discipline where name='Алгоритмы и структуры данных'
union
select 'offset', id, 5, 3 from discipline where name='Численные методы'
union
select 'exam', id, 5, 3 from discipline where name='Базы данных'
union
select 'exam', id, 5, 3 from discipline where name='Уравнения математической физики'
union
select 'exam', id, 5, 3 from discipline where name='Теоретическая механика'
union
select 'offset', id, 5, 3 from discipline where name='Право'
union
select 'offset', id, 5, 3 from discipline where name='Физика';

insert into `group`(startDate, groupNumber) values
('2020-09-01', 3),
('2022-09-01', 4);

insert into student(studentsNumber, name, surname, lastname, sex, birthDate, groupId, educationalDirectionId)
select 24156, 'Сергей', 'Акайкин', 'Владимирович', 'мужской', '2002-02-10', id, 3 from `group` where startDate = '2020-09-01'
union
select 24157, 'Дарья', 'Акимова', 'Анатольевна', 'женский', '2001-04-12', id, 3 from `group` where startDate = '2020-09-01'
union
select 24158, 'Алексей', 'Артамонов', 'Викторович', 'мужской', '2002-09-02', id, 3 from `group` where startDate = '2020-09-01'
union
select 24159, 'Анна', 'Бугреева', 'Валерьевна', 'женский', '2002-04-28', id, 3 from `group` where startDate = '2020-09-01'
union
select 24160, 'Антон', 'Прокопенко', 'Сергеевич', 'мужской', '2002-08-22', id, 3 from `group` where startDate = '2020-09-01'
union
select 24161, 'Данил', 'Прокопенко', 'Сергеевич', 'мужской', '2002-08-22', id, 3 from `group` where startDate = '2020-09-01'
union
select 24172, 'Иван', 'Иванов', 'Иванович', 'мужской', '2002-12-11', id, 4 from `group` where startDate = '2022-09-01'
union
select 24173, 'Маргарита', 'Тучина', 'Валерьевна', 'женский', '2004-09-15', id, 4 from `group` where startDate = '2022-09-01'
union
select 24174, 'Павел', 'Родайкин', 'Викторович', 'мужской', '2004-11-10', id, 4 from `group` where startDate = '2022-09-01'
union
select 24175, 'Данил', 'Пакнаев', 'Сергеевич', 'мужской', '2004-11-21', id, 4 from `group` where startDate = '2022-09-01'
union
select 24176, 'Денис', 'Храмов', 'Артёмович', 'мужской', '2004-03-01', id, 4 from `group` where startDate = '2022-09-01';

insert into marks(mark, studentId, disciplineId)
select 4, 24156, id from discipline where name='Численные методы'
union
select 4, 24156, id from discipline where name='Физика'
union
select 4, 24156, id from discipline where name='Теоретическая механика'
union
select 5, 24156, id from discipline where name='Базы данных'
union
select 3, 24156, id from discipline where name='Право'
union
select 5, 24156, id from discipline where name='Уравнения математической физики'
union
--
select 4, 24157, id from discipline where name='Численные методы'
union
select 4, 24157, id from discipline where name='Физика'
union
select 3, 24157, id from discipline where name='Теоретическая механика'
union
select 5, 24157, id from discipline where name='Базы данных'
union
select 3, 24157, id from discipline where name='Право'
union
select 4, 24157, id from discipline where name='Уравнения математической физики'
union
--
select 5, 24158, id from discipline where name='Численные методы'
union
select 5, 24158, id from discipline where name='Физика'
union
select 5, 24158, id from discipline where name='Теоретическая механика'
union
select 5, 24158, id from discipline where name='Базы данных'
union
select 5, 24158, id from discipline where name='Право'
union
select 5, 24158, id from discipline where name='Уравнения математической физики'
union
--
select 4, 24159, id from discipline where name='Численные методы'
union
select 4, 24159, id from discipline where name='Физика'
union
select 5, 24159, id from discipline where name='Теоретическая механика'
union
select 5, 24159, id from discipline where name='Базы данных'
union
select 4, 24159, id from discipline where name='Право'
union
select 3, 24159, id from discipline where name='Уравнения математической физики'
--
union
select 5, 24172, id from discipline where name='Математический анализ'
union
select 3, 24172, id from discipline where name='Алгебра и геометрия'
union
select 5, 24172, id from discipline where name='Алгоритмы и структуры данных'
union
select 5, 24172, id from discipline where name='Аналитическая геометрия'
union
select 4, 24172, id from discipline where name='Практикум ЭВМ'
--
union
select 5, 24173, id from discipline where name='Математический анализ'
union
select 5, 24173, id from discipline where name='Алгебра и геометрия'
union
select 4, 24173, id from discipline where name='Алгоритмы и структуры данных'
union
select 5, 24173, id from discipline where name='Аналитическая геометрия'
union
select 5, 24173, id from discipline where name='Практикум ЭВМ'
--
union
select 3, 24174, id from discipline where name='Математический анализ'
union
select 4, 24174, id from discipline where name='Алгебра и геометрия'
union
select 4, 24174, id from discipline where name='Алгоритмы и структуры данных'
union
select 4, 24174, id from discipline where name='Аналитическая геометрия'
union
select 5, 24174, id from discipline where name='Практикум ЭВМ'
--
union
select 3, 24175, id from discipline where name='Математический анализ'
union
select 3, 24175, id from discipline where name='Алгебра и геометрия'
union
select 3, 24175, id from discipline where name='Алгоритмы и структуры данных'
union
select 4, 24175, id from discipline where name='Аналитическая геометрия'
union
select 4, 24175, id from discipline where name='Практикум ЭВМ'







