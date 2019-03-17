/* Guide 3, Exercise 2 
 * Flight Reservations Management System 
 * Pedro Teixeira  
 * 17-March-2019 
 */ 

-- C4_Flights Schema 

-- Define relations 
-- Airport ############################# 
CREATE TABLE C4_Flights.Airport 
  ( 
     code				int, 
     city				string,				-- airports might not be in a city? 
     [state]			string, 
     [name]				string NOT NULL,	-- airports must have a name? 
     CONSTRAINT AIRPORT_PK PRIMARY KEY (code) 
  ); 

-- Flight ############################## 
CREATE TABLE C4_Flights.Flight 
  ( 
     number				int, 
     airline			string, 
     weekdays			string, 
     CONSTRAINT FLIGHT_PK PRIMARY KEY (number) 
  ); 

CREATE TABLE C4_Flights.LegInstance 
  ( 
     [date]				date, 
     numAvailableSeats	int NOT NULL DEFAULT 0, 
     flightLegNum		int,	--FK 
	 flightLegFlight	int,	--FK
     departsAirport		int,	--FK 
     depTime			time, 
     arrivesAirport		int,	--FK 
     arrtTime			time, 
     assignedAirplane	int		--FK 
     CONSTRAINT LEG_INSTANCE_PK PRIMARY KEY ([date]),
	 CONSTRAINT LEG_INSTANCE_SEATS CHECK (numAvailableSeats >= 0)
  ); 

CREATE TABLE C4_Flights.FlightLeg 
  ( 
     number				int, 
     flight				int,	--FK 
     departureAirport	int,	--FK 
     scheduleDepTime	time, 
     arrivalAirport		int,	--FK 
     scheduleArrTime	time, 
     CONSTRAINT FLIGHT_LEG_PK PRIMARY KEY (number, flight) 
  ); 

CREATE TABLE C4_Flights.Fare 
  ( 
     code				int, 
     ammount			int, 
     restrictions		string, 
     flight				int,	--FK 
     CONSTRAINT FARE_PK PRIMARY KEY (code) 
  ); 

-- Airplane ############################# 
CREATE TABLE C4_Flights.Airplane 
  ( 
     id					int, 
     totalNumSeats		int NOT NULL DEFAULT 0, 
     [type]				string,	--FK 
     CONSTRAINT AIRPLANE_PK PRIMARY KEY (id) 
  ); 

CREATE TABLE C4_Flights.AirplaneType 
  ( 
     [name]				string, 
     maxSeats			int NOT NULL DEFAULT 0, 
     company			string, 
     CONSTRAINT AIRPLANE_TYPE_PK PRIMARY KEY([name]) 
  ); 

CREATE TABLE C4_Flights.Seat 
  ( 
     number				int, 
     customerName		string, 
     cPhone				int, 
     legInstance		date,	--FK 
     CONSTRAINT SEAT_PK PRIMARY KEY(number, legInstance) 
  ); 

CREATE TABLE C4_Flights.CanLand 
  ( 
     airport      int,			--FK
     airplaneType string,		--FK
     CONSTRAINT CAN_LAND_PK PRIMARY KEY(airport, airplaneType) 
  ); 

-- Assign foreign keys 
ALTER TABLE C4_Flights.LegInstance ADD FOREIGN KEY (flightLegNum, flightLegFlight) REFERENCES C4_Flights.FlightLeg(number, flight); -- ON UPDATE CASCADE; 
ALTER TABLE C4_Flights.LegInstance ADD FOREIGN KEY (departsAirport) REFERENCES C4_Flights.Airport(code);	--ON UPDATE CASCADE; 
ALTER TABLE C4_Flights.LegInstance ADD FOREIGN KEY (arrivesAirport) REFERENCES C4_Flights.Airport(code);	--ON UPDATE CASCADE; 
ALTER TABLE C4_Flights.LegInstance ADD FOREIGN KEY (assignedAirplane) REFERENCES C4_Flights.Airplane(id);	--ON UPDATE CASCADE; 

ALTER TABLE C4_Flights.FlightLeg ADD FOREIGN KEY (flight) REFERENCES C4_Flights.Flight(number);				--ON UPDATE CASCADE; 
ALTER TABLE C4_Flights.FlightLeg ADD FOREIGN KEY (departureAirport) REFERENCES C4_Flights.Airport(code);	--ON UPDATE CASCADE; 
ALTER TABLE C4_Flights.FlightLeg ADD FOREIGN KEY (arrivalAirport) REFERENCES C4_Flights.Airport(code);		--ON UPDATE CASCADE; 

ALTER TABLE C4_Flights.Fare ADD FOREIGN KEY (flight) REFERENCES C4_Flights.Flight(number) ON UPDATE CASCADE; 

ALTER TABLE C4_Flights.Airplane ADD FOREIGN KEY ([type]) REFERENCES C4_Flights.AirplaneType(name) ON UPDATE CASCADE; 

ALTER TABLE C4_Flights.Seat ADD FOREIGN KEY (legInstance) REFERENCES C4_Flights.LegInstance([date]) ON UPDATE CASCADE; 

ALTER TABLE C4_Flights.CanLand ADD FOREIGN KEY (airport) REFERENCES C4_Flights.Airport(code) ON UPDATE CASCADE; 
ALTER TABLE C4_Flights.CanLand ADD FOREIGN KEY (airplaneType) REFERENCES C4_Flights.AirplaneType(name) ON UPDATE CASCADE;