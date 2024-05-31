create table olapdata (
                          aircraft_319 integer,
                          aircraft_320 integer,
                          aircraft_321 integer,
                          aircraft_733 integer,
                          aircraft_763 integer,
                          aircraft_773 integer,
                          aircraft_CN1 integer,
                          aircraft_CR2 integer,
                          aircraft_SU9 integer,
                          dataday date,
                          string_id integer,
                          constraint olapdata_pk primary key (string_id, dataday)
);

create index olap_date_idx on olapdata using btree (dataday);

select * from olapdata;
drop table olapdata


--1 строка
insert into olapdata(select
                            count(case when aircraft_code = '319' then 1 else null end) as aircraft_319,
                            count(case when aircraft_code = '320' then 1 else null end) as aircraft_320,
                            count(case when aircraft_code = '321' then 1 else null end) as aircraft_321,
                            count(case when aircraft_code = '733' then 1 else null end) as aircraft_733,
                            count(case when aircraft_code = '763' then 1 else null end) as aircraft_763,
                            count(case when aircraft_code = '773' then 1 else null end) as aircraft_773,
                            count(case when aircraft_code = 'CN1' then 1 else null end) as aircraft_CN1,
                            count(case when aircraft_code = 'CR2' then 1 else null end) as aircraft_CR2,
                            count(case when aircraft_code = 'SU9' then 1 else null end) as aircraft_SU9,
                            actual_departure::date as day,
                            1 as string_id
                            from flights
                                where actual_departure is not null
                                group by actual_departure::date);

--2 строка
create or replace function second_string_count() returns table(
    aircraft_319 integer,
    aircraft_320 integer,
    aircraft_321 integer,
    aircraft_733 integer,
    aircraft_763 integer,
    aircraft_773 integer,
    aircraft_CN1 integer,
    aircraft_CR2 integer,
    aircraft_SU9 integer,
    dataday date,
    string_id integer) language 'plpgsql' as
$$
    declare
  d  RECORD;

begin

  FOR d IN SELECT distinct(actual_departure::date) as actual_departure
      FROM flights where actual_departure is not null
  LOOP
    select count(boarding_no) into aircraft_319
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = '319';

    select count(boarding_no) into aircraft_320
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = '320';

    select count(boarding_no) into aircraft_321
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = '321';

    select count(boarding_no) into aircraft_733
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = '733';

    select count(boarding_no) into aircraft_763
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = '763';

    select count(boarding_no) into aircraft_773
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = '773';

    select count(boarding_no) into aircraft_CN1
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = 'CN1';

    select count(boarding_no) into aircraft_CR2
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = 'CR2';

    select count(boarding_no) into aircraft_SU9
      from boarding_passes natural join flights
      where actual_departure::date = d.actual_departure and aircraft_code = 'SU9';

    dataday = d.actual_departure;
    string_id = 2;

    RETURN NEXT;
  END LOOP;
end;

    $$

drop function second_string_count()

insert into olapdata(select * from second_string_count())

select * from second_string_count();

--3 строка

insert into olapdata(select
        sum(case when aircraft_code = '319' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_319,
       sum(case when aircraft_code = '320' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_320,
       sum(case when aircraft_code = '321' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_321,
       sum(case when aircraft_code = '733' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_733,
       sum(case when aircraft_code = '773' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_773,
       sum(case when aircraft_code = '763' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_763,
       sum(case when aircraft_code = 'CN1' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_CN1,
       sum(case when aircraft_code = 'CR2' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_CR2,
       sum(case when aircraft_code = 'SU9' then extract(epoch from actual_departure::timestamp - scheduled_departure::timestamp) else 0 end)/60 as aircraft_SU9,
        actual_departure::date as day,
        3 as string_id
        from flights
where actual_departure is not null
group by actual_departure::date)

select actual_departure, scheduled_departure from flights where aircraft_code = '319' and actual_departure::date = '2017-07-30'


--4 строка

-- select round(count(flight_id)/344::numeric*100, 1), flight_id, count(flight_id) from boarding_passes group by flight_id

create or replace function fourth_string_count() returns table(
                                                                  aircraft_319 integer,
                                                                  aircraft_320 integer,
                                                                  aircraft_321 integer,
                                                                  aircraft_733 integer,
                                                                  aircraft_763 integer,
                                                                  aircraft_773 integer,
                                                                  aircraft_CN1 integer,
                                                                  aircraft_CR2 integer,
                                                                  aircraft_SU9 integer,
                                                                  dataday date,
                                                                  string_id integer) language 'plpgsql' as
$$
declare
    d  RECORD;

begin

    FOR d IN SELECT distinct(actual_departure::date) as actual_departure
             FROM flights where actual_departure is not null
        LOOP
            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = '319' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_319 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = '320' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_320 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = '321' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_321 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = '733' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_733 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = '763' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_763 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = '773' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_773 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = 'CN1' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_CN1 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = 'CR2' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_CR2 from i;

            with flight_info as (
                select count(flight_id), flight_id, aircraft_code
                from boarding_passes natural join flights
                where actual_departure::date = d.actual_departure and aircraft_code = 'SU9' group by flight_id,aircraft_code
            ), seats_count as (
                select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
            ), i as (
                select round(fi.count/total_seats::numeric, 2)*100 as a from flight_info fi join seats_count sc on fi.aircraft_code = sc.aircraft_code group by total_seats, fi.count
            )
            select avg(a) into aircraft_SU9 from i;

            dataday = d.actual_departure;
            string_id = 4;

            RETURN NEXT;
        END LOOP;
end;

$$

-- select round((count(flight_id)/344::numeric*100),1) from flights natural join boarding_passes where aircraft_code = '773' and actual_departure::date = '2017-08-11' group by flight_id

insert into olapdata(select * from fourth_string_count());

-- select count(seat_no), aircraft_code from seats group by aircraft_code
--
--
--
-- select flight_id, aircraft_code
-- from boarding_passes natural join flights
-- where actual_departure::date = '2017-08-07' and aircraft_code = '319' group by aircraft_code, flight_id
--
-- select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
--
-- with flight_info as (
--     select flight_id, aircraft_code
--     from boarding_passes natural join flights
--     where actual_departure::date = '2017-08-07' and aircraft_code = '319' group by flight_id,aircraft_code
-- ), seats_count as (
--     select count(seat_no) as total_seats, aircraft_code from seats group by aircraft_code
-- ), i as (
--     select round(count(flight_id)/seats_count::numeric*100, 1) as a
--     from seats_count natural join flight_info
--     group by aircraft_code
-- )
-- select avg(a) from i;