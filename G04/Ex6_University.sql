/*
        Guide 4, exercise 6
		University
        Paulo Vasconcelos
        84987
*/

-- CREATE SCHEMA C4_University;

CREATE TABLE C4_University.Project(
    ref			int,
    [name]		varchar(50),
	fin_entity	varchar(50),
	[start]		date,
	[end]		date,
	budget		int,
	manager		int,
	PRIMARY KEY(ref));


CREATE TABLE C4_University.Person(
	nmec	int,
	[name]	varchar(50),
	birth	date,
	PRIMARY KEY(nmec));

CREATE TABLE C4_University.Professor(
	nmec		int,
	categ		varchar(50),
	area		varchar(50),
	dep_name	varchar(50),
	dep_loc		varchar(100),
	effort		int,
	PRIMARY KEY(nmec));

CREATE TABLE C4_University.Student(
	nmec		int,
	formation	varchar(50),
	advisor		int,
	dep_name	varchar(50),
	dep_loc		varchar(100),
	PRIMARY KEY(nmec));

CREATE TABLE C4_University.Department(
	[name]		varchar(50),
	[location]	varchar(100),
	manager		int,
	PRIMARY KEY([name],[location]));

CREATE TABLE C4_University.ProfParticipation(
	project		int,
	professor	int,
	PRIMARY KEY(project,professor));

CREATE TABLE C4_University.StudentParticipation(
	project		int,
	student		int,
	supervisor	int,
	PRIMARY KEY(project,student,supervisor));

-------------------------------
-- ALTER TABLE: FOREIGN KEYS --
-------------------------------
-- Project
ALTER TABLE C4_University.Project ADD FOREIGN KEY (manager) REFERENCES C4_University.Professor(nmec) ON DELETE SET NULL ON UPDATE CASCADE;
-- Professor
ALTER TABLE C4_University.Professor ADD FOREIGN KEY (nmec) REFERENCES C4_University.Person(nmec) ON UPDATE CASCADE;
ALTER TABLE C4_University.Professor ADD FOREIGN KEY (dep_name, dep_loc) REFERENCES C4_University.Department([name], [location]) ON UPDATE CASCADE;
-- Student
ALTER TABLE C4_University.Student ADD FOREIGN KEY (nmec) REFERENCES C4_University.Person(nmec) ON UPDATE CASCADE;
ALTER TABLE C4_University.Student ADD FOREIGN KEY (dep_name, dep_loc) REFERENCES C4_University.Department([name], [location]) ON UPDATE CASCADE;
ALTER TABLE C4_University.Student ADD FOREIGN KEY (advisor) REFERENCES C4_University.Student(nmec);
-- Department
ALTER TABLE C4_University.Department ADD FOREIGN KEY (manager) REFERENCES C4_University.Professor(nmec);
-- ProfParticipation
ALTER TABLE C4_University.ProfParticipation ADD FOREIGN KEY (project) REFERENCES C4_University.Project(ref) ON UPDATE CASCADE;
ALTER TABLE C4_University.ProfParticipation ADD FOREIGN KEY (professor) REFERENCES C4_University.Professor(nmec);
-- StudentParticipation
ALTER TABLE C4_University.StudentParticipation ADD FOREIGN KEY (project) REFERENCES C4_University.Project(ref);
ALTER TABLE C4_University.StudentParticipation ADD FOREIGN KEY (student) REFERENCES C4_University.Student(nmec);
ALTER TABLE C4_University.StudentParticipation ADD FOREIGN KEY (supervisor) REFERENCES C4_University.Professor(nmec);