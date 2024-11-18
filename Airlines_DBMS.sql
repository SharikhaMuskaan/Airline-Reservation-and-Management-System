CREATE DATABASE AirlineReservationManagement;
USE AirlineReservationManagement;


CREATE TABLE Flight (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    on_time_rating FLOAT CHECK (on_time_rating BETWEEN 0 AND 5),
    economy_seats INT NOT NULL CHECK (economy_seats >= 0),
    business_seats INT NOT NULL CHECK (business_seats >= 0),
    first_seats INT NOT NULL CHECK (first_seats >= 0)
);


CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    seat_preference ENUM('Window', 'Aisle') DEFAULT 'Window',
    class_preference ENUM('Economy', 'Business', 'First') DEFAULT 'Economy',
    loyalty_id INT UNIQUE

);
ALTER TABLE Passenger
ADD CONSTRAINT fk_loyalty_id
FOREIGN KEY (loyalty_id) 
REFERENCES LoyaltyProgram(loyalty_id)
ON UPDATE CASCADE
ON DELETE SET NULL;


CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5),
    booking_status ENUM('Confirmed', 'Canceled') DEFAULT 'Confirmed',
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    class ENUM('Economy', 'Business', 'First') NOT NULL

);
ALTER TABLE Booking
ADD CONSTRAINT fk_passenger_id
FOREIGN KEY (passenger_id) 
REFERENCES Passenger(passenger_id)
ON UPDATE CASCADE
ON DELETE CASCADE,

ADD CONSTRAINT fk_flight_id
FOREIGN KEY (flight_id) 
REFERENCES Flight(flight_id)
ON UPDATE CASCADE
ON DELETE CASCADE;


CREATE TABLE Seat (
    seat_id INT PRIMARY KEY,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    class ENUM('Economy', 'Business', 'First') NOT NULL,
    status ENUM('Available', 'Booked') DEFAULT 'Available'
 
);
ALTER TABLE Seat
ADD CONSTRAINT fk_flight_id1
FOREIGN KEY (flight_id) 
REFERENCES Flight(flight_id)
ON UPDATE CASCADE
ON DELETE CASCADE;


CREATE TABLE LoyaltyProgram (
    loyalty_id INT PRIMARY KEY,
    passenger_id INT UNIQUE NOT NULL,
    miles_accumulated INT DEFAULT 0 CHECK (miles_accumulated >= 0),
    points_available INT DEFAULT 0 CHECK (points_available >= 0),
    tier ENUM('Bronze', 'Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO Flight (flight_id, flight_number, departure_time, arrival_time, origin, destination, on_time_rating, economy_seats, business_seats, first_seats)
VALUES 
(1, 'SH101', '2024-12-01 08:00:00', '2024-12-01 12:00:00', 'New York', 'Los Angeles', 4.5, 50, 30, 20),
(2, 'SH102', '2024-12-02 09:00:00', '2024-12-02 13:00:00', 'Los Angeles', 'Chicago', 4.2, 60, 25, 15),
(3, 'SH103', '2024-12-03 07:30:00', '2024-12-03 11:30:00', 'Chicago', 'San Francisco', 4.8, 70, 40, 30),
(4, 'SH104', '2024-12-04 10:00:00', '2024-12-04 14:00:00', 'San Francisco', 'Miami', 4.7, 80, 50, 40),
(5, 'SH105', '2024-12-05 11:30:00', '2024-12-05 15:30:00', 'Miami', 'New York', 4.3, 100, 60, 50);
select * from flight;

INSERT INTO Passenger (passenger_id, first_name, last_name, email, phone, seat_preference, class_preference, loyalty_id)
VALUES 
(1, 'John', 'Doe', 'john.doe@example.com', '1234567890', 'Window', 'Economy', NULL),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2345678901', 'Aisle', 'Business', NULL),
(3, 'Michael', 'Brown', 'michael.brown@example.com', '3456789012', 'Window', 'First', NULL),
(4, 'Emily', 'Davis', 'emily.davis@example.com', '4567890123', 'Aisle', 'Economy', NULL),
(5, 'David', 'Clark', 'david.clark@example.com', '5678901234', 'Window', 'Business', NULL);
select * from passenger;
INSERT INTO LoyaltyProgram (loyalty_id, passenger_id, miles_accumulated, points_available, tier)
VALUES 
(1, 1, 1000, 500, 'Gold'),
(2, 2, 2000, 1000, 'Platinum'),
(3, 3, 1500, 750, 'Silver'),
(4, 4, 500, 250, 'Bronze'),
(5, 5, 800, 400, 'Silver'),
(6, 6, 13000,1200,'Platinum');
select * from loyaltyprogram;


INSERT INTO Seat (seat_id, flight_id, seat_number, class, status)
VALUES 
(1, 1, 'A1', 'Economy', 'Booked'),
(2, 1, 'A2', 'Economy', 'Available'),
(3, 2, 'B2', 'Business', 'Booked'),
(4, 2, 'B3', 'Business', 'Available'),
(5, 3, 'C3', 'First', 'Booked');
select* from seat;

ALTER TABLE Booking
MODIFY COLUMN booking_status ENUM('Confirmed', 'Cancelled', 'Pending');

INSERT INTO Booking (booking_id, passenger_id, flight_id, seat_number, booking_status, booking_date, class)
VALUES 
(1, 1, 1, 'A1', 'Confirmed', '2024-12-01 07:00:00', 'Economy'),
(2, 2, 2, 'B2', 'Confirmed', '2024-12-02 08:00:00', 'Business'),
(3, 3, 3, 'C3', 'Pending', '2024-12-03 06:00:00', 'First'),
(4, 4, 4, 'D4', 'Cancelled', '2024-12-04 09:00:00', 'Economy'),
(5, 5, 5, 'E5', 'Confirmed', '2024-12-05 10:30:00', 'Business');
select * from booking;

CREATE USER 'remote_user'@'%' IDENTIFIED BY 'c4b6';
GRANT ALL PRIVILEGES ON AirlineReservationManagement.* TO 'remote_user'@'%';
FLUSH PRIVILEGES;



CREATE TABLE Flight (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    on_time_rating FLOAT CHECK (on_time_rating BETWEEN 0 AND 5),
    economy_seats INT NOT NULL CHECK (economy_seats >= 0),
    business_seats INT NOT NULL CHECK (business_seats >= 0),
    first_seats INT NOT NULL CHECK (first_seats >= 0)
)
ENGINE = FEDERATED
DEFAULT CHARSET = utf8mb4
CONNECTION = 'mysql://remote_user:c4b6@192.168.168.34:3306/AirlineReservationManagement/Flight';

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5),
    booking_status ENUM('Confirmed', 'Canceled') DEFAULT 'Confirmed',
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    class ENUM('Economy', 'Business', 'First') NOT NULL


)
ENGINE = FEDERATED
DEFAULT CHARSET = utf8mb4
CONNECTION = 'mysql://remote_user:c4b6@192.168.168.34:3306/AirlineReservationManagement/Booking';
ALTER TABLE Booking
ADD CONSTRAINT fk_passenger_id
FOREIGN KEY (passenger_id) 
REFERENCES Passenger(passenger_id)
ON UPDATE CASCADE
ON DELETE CASCADE


-- Stored Procedure:
DELIMITER $$

CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
    DECLARE seat_number VARCHAR(5);
    DECLARE flight_id INT;

    -- Retrieve seat number and flight ID from the Booking table for the given booking_id
    -- Use LIMIT 1 to ensure that only one row is fetched
    SELECT seat_number, flight_id
    INTO seat_number, flight_id
    FROM Booking
    WHERE booking_id = booking_id
    LIMIT 1; -- Ensures only one result is returned

    -- Check if a seat number exists for the given booking
    IF seat_number IS NOT NULL THEN
        -- Update the seat number in the Booking table to NULL (marking the booking as canceled)
        UPDATE Booking
        SET seat_number = NULL, booking_status = 'Cancelled'
        WHERE booking_id = booking_id;

        -- Update the Seat table to set the status as "Available" for the corresponding seat
        UPDATE Seat
        SET status = 'Available'
        WHERE flight_id = flight_id AND seat_number = seat_number;
    ELSE
        -- If no seat found, return a message (this part is just for debugging)
        SELECT 'No seat found for the given booking ID' AS message;
    END IF;
END $$

call CancelBooking(2);
