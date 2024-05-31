create table uni(
        id varchar primary key,
        title varchar
);



insert into uni(id, title) values ('01.00.00.00.00', 'Университет');
insert into uni(id, title) values ('01.01.00.00.00', 'КПФУ');
insert into uni(id, title) values ('01.02.00.00.00', 'Елабужский филиал КФУ');
insert into uni(id, title) values ('01.03.00.00.00', 'Набережно-челнинский филиал КФУ');
insert into uni(id, title) values ('01.01.01.00.00', 'Институты');
insert into uni(id, title) values ('01.01.02.00.00', 'Факультеты');
insert into uni(id, title) values ('01.01.03.00.00', 'Подразделение ГО');
insert into uni(id, title) values ('01.01.04.00.00', 'Бухгалтерия');
insert into uni(id, title) values ('01.01.01.11.00', 'ИТИС');
insert into uni(id, title) values ('01.01.01.11.01', 'Деканат ИТИС');
insert into uni(id, title) values ('01.01.01.11.02', 'Лабаратории')

with recursive unirecursive as (
    SELECT '01.00.00.00.00' AS code, 'Университет' AS name, NULL::text AS parent_code
    UNION ALL
    SELECT '01.01.00.00.00', 'КПФУ', '01.00.00.00.00'
    UNION ALL
    SELECT '01.02.00.00.00', 'Елабужский филиал КФУ', '01.00.00.00.00'
    UNION ALL
    SELECT '01.03.00.00.00', 'Набережно-челнинский филиал КФУ', '01.00.00.00.00'
    UNION ALL
    SELECT '01.01.01.00.00', 'Институты', '01.01.00.00.00'
    UNION ALL
    SELECT '01.01.02.00.00', 'Факультеты', '01.01.00.00'
    UNION ALL
    SELECT '01.01.03.00.00', 'Подразделение ГО', '01.01.00.00'
    UNION ALL
    SELECT '01.01.04.00.00', 'Бухгалтерия', '01.01.00.00'
    UNION ALL
    SELECT '01.01.01.11.00', 'ИТИС', '01.01.01.00'
    UNION ALL
    SELECT '01.01.01.11.01', 'Деканат ИТИС', '01.01.01.11'
    UNION ALL
    SELECT '01.01.01.11.02', 'Лаборатории', '01.01.01.11'
);

with recursive unirecursive2 as (
    select id, title from uni as u
                     where id != '01.00.00.00.00'
    union
    select u.id, u.title
    from uni as u join unirecursive2 on u.title = unirecursive2.title
)

select * from unirecursive2

select sum(substring(id, n, 2)::int) from uni

with a as (
    select substring(id, 13, 2)::int, id from uni
)

select *
from uni;



with recursive s as(
    select rtrim(id, '.00') as code, substring(id from 1 for length(id)-3), title, title as n from uni
    union
    select substring(code from 1 for length(code)) as father_code, code, title, title as n from s
                                                                                           where code not like '%00'

)

select * from s
select substring(code from 1 for length(code)) as father_code, code, title, title as n from s

