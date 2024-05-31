select * from airports_data;

select * from bookings limit 7;

select * from tickets limit 10;

select * from flights limit 15;

select * from seats ;

select passenger_id, passenger_name from tickets limit 15;

select ticket_no, seat_no from boarding_passes limit 20;

select ticket_no, amount from ticket_flights limit 20;

select flight_id, actual_departure - scheduled_departure from flights  limit 20;

select flight_id, actual_arrival - scheduled_arrival from flights  limit 20;

select * from ticket_flights;

-- select case when

-----------------------------------------------------------------------------------------------------------------

select t.book_ref, book_date, count(ticket_no)
    from bookings b join tickets t on b.book_ref = t.book_ref
        group by t.book_ref, book_date

select t.ticket_no, passenger_name, tf.fare_conditions, amount
from tickets t join ticket_flights tf on t.ticket_no = tf.ticket_no
               join boarding_passes bp on bp.ticket_no = tf.ticket_no and bp.flight_id = tf.flight_id
               join flights f on f.flight_id = tf.flight_id
               join aircrafts_data a on a.aircraft_code = f.aircraft_code
               join  seats s on s.aircraft_code = a.aircraft_code

where tf.fare_conditions <> s.fare_conditions


SELECT b.book_ref, b.book_date, t.passenger_name, a_departure.airport_name AS departure_airport, a_arrival.airport_name AS arrival_airport
FROM bookings b
        JOIN tickets t ON b.book_ref = t.book_ref
        JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
        JOIN flights f ON tf.flight_id = f.flight_id
        JOIN airports a_departure ON f.departure_airport = a_departure.airport_code
        JOIN airports a_arrival ON f.arrival_airport = a_arrival.airport_code
        JOIN aircrafts a ON f.aircraft_code = a.aircraft_code
        JOIN seats s ON a.aircraft_code = s.aircraft_code

WHERE b.book_date = '2017-08-07'
ORDER BY s.seat_no ASC

SELECT t.passenger_name, b.book_ref
FROM bookings b
         JOIN tickets t ON b.book_ref = t.book_ref
         JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
         JOIN flights f ON tf.flight_id = f.flight_id

WHERE EXTRACT(EPOCH FROM (f.actual_departure - f.scheduled_departure))/3600 BETWEEN 2 AND 4;

-- WHERE cast(concat(extract(hour from f.actual_departure - f.scheduled_departure), extract(minute from f.actual_departure - f.scheduled_departure)) as int) > 2 AND
--       cast(concat(extract(hour from f.actual_departure - f.scheduled_departure), extract(minute from f.actual_departure - f.scheduled_departure)) as int) <= 40 AND
--     extract(minute from f.actual_departure - f.scheduled_departure)>0;


select t1.book_ref, t1.acount, passenger_name, scheduled_departure, scheduled_arrival
from
(select count(distinct aircraft_code) as acount, book_ref --, passenger_name, scheduled_departure, arrival_departure
       from tickets t
            join ticket_flights tf on t.ticket_no=tf.ticket_no
            join flights f on f.flight_id=tf.flight_id
            where scheduled_departure::date = '2017-07-16'
group by book_ref
order by acount desc) t1 join tickets t on t.book_ref=t1.book_ref
join ticket_flights tf on t.ticket_no = tf.ticket_no
join flights f on f.flight_id=tf.flight_id
order by passenger_name

select * from boarding_passes

SELECT ac.aircraft_code, COUNT(f.flight_id) AS flight_count
FROM flights f
        JOIN aircrafts ac ON f.aircraft_code = ac.aircraft_code
WHERE f.departure_airport = 'KZN' AND EXTRACT(month FROM f.actual_departure) = 8 AND EXTRACT(year FROM f.actual_departure) = 2017
GROUP BY ac.aircraft_code, f.departure_airport
--HAVING COUNT(f.flight_id) > 50
ORDER BY flight_count DESC, ac.aircraft_code ASC;

select * from aircrafts
select * from airports
select * from flights
WHERE departure_airport = 'KZN' AND EXTRACT(month FROM sheduled_departure) = 8 AND EXTRACT(year FROM actual_departure) = 2017
SELECT
    aircraft_code,
    COUNT(*) AS flight_count
FROM
    flights
WHERE
        departure_airport = 'KZN'
  AND EXTRACT(MONTH FROM scheduled_departure) = 8
  AND EXTRACT(YEAR FROM scheduled_departure) = 2017
GROUP BY
    aircraft_code, departure_airport
HAVING
        COUNT(*) > 50
ORDER BY
    flight_count DESC,
    aircraft_code ASC;

select count(aircraft_code) from flights;

select count(flight_no) from flights;

select flight_no from flights;

select range from aircrafts
group by range
having range>5000


with sd as(
    select range from aircrafts
                 where range > 5000
)

select * from sd
group by range;

