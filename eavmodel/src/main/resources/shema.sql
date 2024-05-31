create table entity(
    id int primary key ,
    name varchar(20)
)

create table attribute(
    id int primary key ,
    name varchar(20)
)

create table value(
    entity_id int,
    attribute_id int,
    attribute_value varchar,
    foreign key (entity_id) references entity(id),
    foreign key (attribute_id) references attribute(id)
)

insert into entity(id, name) values (1, 'телефон'),(2, 'ноутбук');
insert into attribute(id,name) values (1,'цена'),(2,'производитель');
insert into value(entity_id, attribute_id, attribute_value) values (1,1,'23000'),(1,2,'Samsung'),(2,1,'70000'),(2,2,'Huawei');
select * from entity;
select * from attribute;
select * from value;

