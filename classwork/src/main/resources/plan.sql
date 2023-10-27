select * from airports_data;

select * from bookings limit 7;

select * from tickets limit 10;

select * from flights limit 15;

select * from aircrafts limit 5;

select passenger_id, passenger_name from tickets limit 15;

select ticket_no, seat_no from boarding_passes limit 20;

select ticket_no, amount from ticket_flights limit 20;

select flight_id, actual_departure - scheduled_departure from flights  limit 20;

select flight_id, actual_arrival - scheduled_arrival from flights  limit 20;

select * from ticket_flights;

select case when
