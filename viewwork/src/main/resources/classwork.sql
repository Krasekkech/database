select * from bookings limit 5;
select * from tickets limit 5;

create view new_view as
    select t.ticket_no, b.total_amount, t.passenger_name, t.contact_data
    from bookings b
        join tickets t on b.book_ref = t.book_ref

select * from new_view;



create or replace function buyer_count(result integer) returns integer language 'sql' as
    $$
        select count(*) from new_view
                        where result < total_amount
    $$

select * from buyer_count(100000)


create or replace function top_buyer(top integer) returns
    table(passenger_name varchar, total_amount varchar) language 'sql'
    as
    $$
        select passenger_name, sum(total_amount) as amount from new_view
            group by passenger_name
            order by amount desc
            limit top
    $$

select * from top_buyer(5)

