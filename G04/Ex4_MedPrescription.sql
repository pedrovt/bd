/*
        Guide 4, exercise 4
        Electronic Drug Prescription System
        Paulo Vasconcelos
        84987
*/

-- CREATE SCHEMA C4_MedPrescription;

-- CREATE TYPE string FROM nchar(50);
-- CREATE TYPE big_string FROM nchar(100);

/*
DROP TABLE C4_MedPrescription.Patient;
DROP TABLE C4_MedPrescription.Prescription;
DROP TABLE C4_MedPrescription.Doctor;
DROP TABLE C4_MedPrescription.Farmacy;
DROP TABLE C4_MedPrescription.Drug;
DROP TABLE C4_MedPrescription.Company;
DROP TABLE C4_MedPrescription.Sold;
*/

CREATE TABLE C4_MedPrescription.Patient (
	userNumber		int								NOT NULL,
	[name]			string		NOT NULL,
	dateOfBirth		date							NOT NULL,
	[address]		string			,
	PRIMARY KEY (userNumber));

CREATE TABLE C4_MedPrescription.Prescrition (
	number			int		NOT NULL,
	doctor			int				,
	patient			int				,
	farmacy			int				,
	processmentDate	date	NOT NULL,
	PRIMARY KEY (number));

CREATE TABLE C4_MedPrescription.Doctor (
	id				int							NOT NULL,
	[name]			string	NOT NULL,
	speciality		string			,
	PRIMARY KEY (id));

CREATE TABLE  C4_MedPrescription.Farmacy (
	telephone		int								NOT NULL,
	[name]			string		NOT NULL,
	[address]		string	NOT NULL,
	PRIMARY KEY (telephone));

CREATE TABLE  C4_MedPrescription.Drug (
	[name]		string	NOT NULL,
	formula		string	NOT NULL,
	company		int									,
	PRIMARY KEY ([name]));

CREATE TABLE  C4_MedPrescription.Company (
	id			int								NOT NULL,
	[name]		string		NOT NULL,
	[address]	string	NOT NULL,
	telephone	int										,
	PRIMARY KEY (id));

CREATE TABLE  C4_MedPrescription.Sold (
	drug		string	,
	farmacy		int							,
	PRIMARY KEY (drug, farmacy));

-------------------------------
-- ALTER TABLE: FOREIGN KEYS --
-------------------------------
-- Prescription
ALTER TABLE C4_MedPrescription.Prescrition ADD FOREIGN KEY (doctor) REFERENCES C4_MedPrescription.Doctor(id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE C4_MedPrescription.Prescrition ADD FOREIGN KEY (patient) REFERENCES C4_MedPrescription.Patient(userNumber) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE C4_MedPrescription.Prescrition ADD FOREIGN KEY (farmacy) REFERENCES C4_MedPrescription.Farmacy(telephone) ON DELETE SET NULL ON UPDATE CASCADE;
-- Drug
ALTER TABLE C4_MedPrescription.Drug ADD FOREIGN KEY (company) REFERENCES C4_MedPrescription.Company(id) ON DELETE SET NULL ON UPDATE CASCADE;
-- Sold
ALTER TABLE C4_MedPrescription.Sold ADD FOREIGN KEY (drug) REFERENCES C4_MedPrescription.Drug([name]) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE C4_MedPrescription.Sold ADD FOREIGN KEY (farmacy) REFERENCES C4_MedPrescription.Farmacy(telephone) ON DELETE CASCADE ON UPDATE CASCADE;


