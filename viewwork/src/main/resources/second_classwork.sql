create table dict_services (
                               id bigint primary key,
                               name varchar(255)
);

create table services (
                          id serial,
                          service_id bigint references dict_services(id),
                          service_date date,
                          cost integer
);

insert into dict_services (id,name) values (1,'Замена материнской платы'),
                                           (2, 'Замена видео карты'), (3, 'Ремонт клавиатуры'), (4, 'Клининг');

insert into services (service_id, service_date, cost) values (1, '2024-03-01', 4000),
                                                             (2, '2024-03-01', 2000), (1, '2024-03-02', 3000),(4, '2024-03-03', 1000),
                                                             (2, '2024-03-03', 2500), (2, '2024-03-03', 1000), (2, '2024-03-04', 1000),
                                                             (4, '2024-03-04', 1000), (1, '2024-03-04', 4000), (3, '2024-03-05', 2000),
                                                             (3, '2024-03-05', 2000),(1, '2024-03-05', 5000);

