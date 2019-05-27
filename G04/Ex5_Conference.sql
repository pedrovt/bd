/*
        Guide 4, exercise 5
        Conferences Management
        Paulo Vasconcelos
        84987
*/

-- CREATE SCHEMA C4_Conference;

CREATE TABLE C4_Conference.Paper(
    number	int,
    title	varchar(200),
	PRIMARY KEY(number));

CREATE TABLE C4_Conference.Person(
    email		varchar(50),
    [name]		varchar(100),
	inst_name	varchar(50),
	inst_addr	varchar(100),
	PRIMARY KEY(email));

CREATE TABLE C4_Conference.Institution(
	[name]		varchar(50),
	[address]	varchar(100),
	PRIMARY KEY([name],[address]));

CREATE TABLE C4_Conference.Participant(
    email			varchar(50),
	[address]		varchar(100),
	regist_date		date,
	PRIMARY KEY(email));

CREATE TABLE C4_Conference.Student(
    email		varchar(50),
	receipt		varbinary(MAX),
	PRIMARY KEY(email));

CREATE TABLE C4_Conference.NonStudent(
	email	varchar(50),
	ref		int,
	PRIMARY KEY(email));

CREATE TABLE C4_Conference.Author(
	email	varchar(50),
	PRIMARY KEY(email));
	
CREATE TABLE C4_Conference.Authorship(
	paper	int,
	author	varchar(50),
	PRIMARY KEY(paper,author));

-------------------------------
-- ALTER TABLE: FOREIGN KEYS --
-------------------------------
-- Person
ALTER TABLE C4_Conference.Person ADD FOREIGN KEY (inst_name, inst_addr) REFERENCES C4_Conference.Institution([name], [address]) ON DELETE SET NULL ON UPDATE CASCADE;
-- Participant
ALTER TABLE C4_Conference.Participant ADD FOREIGN KEY (email) REFERENCES C4_Conference.Person(email) ON UPDATE CASCADE;
-- Student
ALTER TABLE C4_Conference.Student ADD FOREIGN KEY (email) REFERENCES C4_Conference.Participant(email) ON UPDATE CASCADE;
-- NonStudent
ALTER TABLE C4_Conference.NonStudent ADD FOREIGN KEY (email) REFERENCES C4_Conference.Participant(email) ON UPDATE CASCADE;
-- Author
ALTER TABLE C4_Conference.Author ADD FOREIGN KEY (email) REFERENCES C4_Conference.Person(email)  ON UPDATE CASCADE;
-- Authorship
ALTER TABLE C4_Conference.Authorship ADD FOREIGN KEY (paper) REFERENCES C4_Conference.Paper(number)  ON UPDATE CASCADE;
ALTER TABLE C4_Conference.Authorship ADD FOREIGN KEY (author) REFERENCES C4_Conference.Author(email)  ON UPDATE CASCADE;