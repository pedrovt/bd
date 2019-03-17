/* Guide 3, Exercise 1
 * Rent-a-Car Management System
 * Pedro Teixeira <pedro.teix@ua.pt>
 * 14-March-2019
 */

 -- Define relations
 CREATE TABLE C4_RentACar.Vehicle (
	registration		string,
	vehicleYear			date	NOT NULL,
	brand				string	NOT NULL,
	typeVehicle			int		NOT NULL,
	CONSTRAINT VEHICLE_PK PRIMARY KEY (registration),
 );

 CREATE TABLE C4_RentACar.TypeVehicle (
	code				int,
	conditionatedAir	string,
	designation			string NOT NULL,
	CONSTRAINT TYPE_VEHICLE_PK PRIMARY KEY (code)
 );

 CREATE TABLE C4_RentACar.LightVehicle (
	code				int,
	numSeats			int	NOT NULL DEFAULT 0,
	numDoors			int NOT NULL DEFAULT 0,
	fuel				string,
	CONSTRAINT LIGHT_VEHICLE_PK PRIMARY KEY (code)
 );

 CREATE TABLE C4_RentACar.HeavyVehicle (
	code				int,
	vehicleWeight		int	NOT NULL DEFAULT 0,
	CONSTRAINT HEAVY_VEHICLE_PK PRIMARY KEY (code)
 );

 CREATE TABLE C4_RentACar.Similarity (
	vehicleA			int,
	vehicleB			int,
	CONSTRAINT SIMILARITY_PK PRIMARY KEY (vehicleA, vehicleB)
 );

 CREATE TABLE C4_RentACar.Balcony (
	number				int,
	name				string NOT NULL,
	[address]			string,		--virtual balconies?
	CONSTRAINT BALCONY_PK PRIMARY KEY (number)
 );

 CREATE TABLE C4_RentACar.Client (
	nif					int,
	name				string NOT NULL,
	[address]			string NOT NULL,
	numLicense			int    NOT NULL DEFAULT 0,
	CONSTRAINT CLIENT_PK PRIMARY KEY (nif),
	CONSTRAINT CLIENT_UNIQUE UNIQUE (numLicense)
 );

 CREATE TABLE C4_RentACar.Rent (
	number				int, 
	[date]				datetime,
	duration			int NOT NULL DEFAULT 0,
	titular				int NOT NULL,
	[object]			string NOT NULL,
	[local]				int,
	CONSTRAINT RENT_PK PRIMARY KEY(number)
 );


 -- Assign foreign keys
 -- Ignored behaviour on update for some foreign keys because of the error
 -- Introducing FOREIGN KEY constraint 'FK__LightVehic__code__6E01572D' on table 'Light/HeavyVehicle or RentACar' may cause cycles or multiple cascade paths. Specify ON DELETE NO ACTION or ON UPDATE NO ACTION, or modify other FOREIGN KEY constraints.

 ALTER TABLE C4_RentACar.LightVehicle	ADD FOREIGN KEY (code)			REFERENCES C4_RentACar.TypeVehicle(code);	 --ON UPDATE CASCADE;
 ALTER TABLE C4_RentACar.HeavyVehicle	ADD FOREIGN KEY (code)			REFERENCES C4_RentACar.TypeVehicle(code);	 --ON UPDATE CASCADE;
 
 ALTER TABLE C4_RentACar.Similarity		ADD FOREIGN KEY (vehicleA)		REFERENCES C4_RentACar.TypeVehicle(code)	 --ON UPDATE CASCADE;
 ALTER TABLE C4_RentACar.Similarity		ADD FOREIGN KEY (vehicleA)		REFERENCES C4_RentACar.TypeVehicle(code)	 --ON UPDATE CASCADE;
 
 ALTER TABLE C4_RentACar.Vehicle		ADD FOREIGN KEY (typeVehicle)	REFERENCES C4_RentACar.TypeVehicle(code)	 ON UPDATE CASCADE;

 ALTER TABLE C4_RentACar.Rent			ADD FOREIGN KEY (titular)		REFERENCES C4_RentACar.Client(nif)			 ON UPDATE CASCADE;
 ALTER TABLE C4_RentACar.Rent			ADD FOREIGN KEY ([object])		REFERENCES C4_RentACar.Vehicle(registration) ON UPDATE CASCADE;
 ALTER TABLE C4_RentACar.Rent			ADD FOREIGN KEY ([local])		REFERENCES C4_RentACar.Balcony(number)		 ON UPDATE CASCADE;	


 