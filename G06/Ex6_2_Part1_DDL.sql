/* Guide 6, Exercise 2, Company
 * 30-March-2019
 */

 -- CREATE DATABASE company;
 -- CREATE TYPE string from varchar(50);
 
 -- Define relations
 CREATE TABLE EMPLOYEE (
	Fname				string,
	Minit				string,
	Lname				string,
	Ssn					int,
	Bdate				date,
	Address				string,
	Sex					string,
	Salary				int,
	Super_ssn			int,
	Dno					int,
	CONSTRAINT EMPLOYEE_PK PRIMARY KEY (Ssn),
 );

 CREATE TABLE DEPARTMENT (
	Dname				string NOT NULL,
	Dnumber				int,
	Mgr_ssn				int,
	Mgr_start_date		date,
	CONSTRAINT DEPARTMENT_PK PRIMARY KEY (Dnumber)
 );

 CREATE TABLE DEPT_LOCATIONS (
	Dnumber				int,
	Dlocation			string,
	CONSTRAINT DEPT_LOCATIONS_PK PRIMARY KEY (Dnumber, Dlocation)
 );

 CREATE TABLE PROJECT (
	Pname				string,
	Pnumber				int,
	Plocation			string,
	Dnumb				int,
	CONSTRAINT PROJECT_PK PRIMARY KEY (Pnumber)
 );

 CREATE TABLE WORKS_ON (
	Essn				int,
	Pno					int,
	[Hours]				int,
	CONSTRAINT WORKS_ON_PK PRIMARY KEY (Essn, Pno)
 );

 CREATE TABLE DEPENDENT (
	Essn				int,
	Dependent_name		string,
	Sex					string,
	Bdate				date,
	Relationship		string,
	CONSTRAINT DEPENDENT_PK PRIMARY KEY (Essn, Dependent_name)
 );


 -- Assign foreign keys
 -- Ignored behaviour on update for some foreign keys because of the error
 -- Introducing FOREIGN KEY constraint 'FK__LightVehic__code__6E01572D' on table 'Light/HeavyVehicle or RentACar' may cause cycles or multiple cascade paths. Specify ON DELETE NO ACTION or ON UPDATE NO ACTION, or modify other FOREIGN KEY constraints.

 ALTER TABLE EMPLOYEE		ADD FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn)		;
 ALTER TABLE EMPLOYEE		ADD FOREIGN KEY (Dno)		REFERENCES DEPARTMENT(Dnumber)	;

 ALTER TABLE DEPARTMENT		ADD FOREIGN KEY (Mgr_ssn)	REFERENCES EMPLOYEE(Ssn)		;
 
 ALTER TABLE DEPT_LOCATIONS ADD FOREIGN KEY (Dnumber)	REFERENCES DEPARTMENT(Dnumber)	;
 
 ALTER TABLE PROJECT		ADD FOREIGN KEY (Dnum)		REFERENCES DEPARTMENT(Dnumber)	;

 ALTER TABLE WORKS_ON		ADD FOREIGN KEY (Essn)		REFERENCES EMPLOYEE(Ssn)		;
 ALTER TABLE WORKS_ON		ADD FOREIGN KEY (Pno)		REFERENCES PROJECT(Pnumber)		;
 
 ALTER TABLE DEPENDENT		ADD FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)				;
