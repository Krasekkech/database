create table person(
    id int primary key,
    name varchar,
    passport_id bigint unique,
    passpnum varchar,
    foreign key  (passport_id) references passport(id) on update no action
);

create table passport(
    id int primary key,
    num varchar
);

insert into person(id, name, passport_id, passpnum) VALUES (2, 'person 1', 1, '12341241'), (3, 'person 2', 2, '132457324'), (4, 'person 3', 3, '124264273')
insert into passport(id, num) values (1, '124125215'), (2, '12412551'), (3, '12412415')



select * from person p left join passport ps on p.passport_id = ps.id;

create view personinfo as
    select p.*, ps.num from person p left join passport ps on p.passport_id = ps.id;

select * from personinfo;



CREATE OR REPLACE FUNCTION personinfo_by_name(person_name text) RETURNS
    TABLE(id int, name varchar , passport_id int, passpnum varchar, num varchar) LANGUAGE 'sql'
AS
$BODY$
select p.*, ps.num from person p left join passport ps on p.passport_id=ps.id
where p.name like person_name;
$BODY$


select * from personinfo_by_name('person 1');
