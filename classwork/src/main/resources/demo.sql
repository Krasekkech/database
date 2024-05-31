CREATE INDEX idx_tickets_ticket_no ON tickets using btree(ticket_no);
explain analyze
SELECT tickets.ticket_no, tickets.passenger_name, tickets.passenger_id,
       flights.flight_no, flights.departure_airport, flights.arrival_airport,
       boarding_passes.seat_no
FROM tickets
         JOIN ticket_flights ON tickets.ticket_no = ticket_flights.ticket_no
         JOIN flights ON ticket_flights.flight_id = flights.flight_id
         JOIN boarding_passes ON ticket_flights.flight_id = boarding_passes.flight_id
    AND tickets.ticket_no = boarding_passes.ticket_no
WHERE tickets.passenger_name = 'ARTUR GERASIMOV';

drop index idx_tickets_passenger_name
drop index idx_tickets_passenger_id
drop index idx_tickets_ticket_no