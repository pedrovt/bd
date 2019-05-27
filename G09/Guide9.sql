/* Guide 9
 * Pedro Teixeira 
 * Paulo Vasconcelos
 * 16-May-2019
 */
 
 --a) Construa um stored procedure que aceite o ssn de um funcionário, que o remova da
--tabela de funcionários, que remova as suas entradas da tabela works_on e que
--remova ainda os seus dependentes. Que preocupações adicionais devem ter no
--storage procedure para além das referidas anteriormente?
GO
CREATE PROC dbo.p_RemoveEmployee (@Ssn INT)
AS
	-- Remove Works_On
	DELETE dbo.WORKS_ON WHERE Essn=@Ssn

	-- Remove Dependent
	DELETE dbo.WORKS_ON WHERE Essn=@Ssn

	-- Update Departement (no need to delete the whole department!)
	UPDATE dbo.DEPARTMENT SET Mgr_ssn = null, Mgr_start_date = null WHERE Mgr_ssn = @Ssn

	-- Update Employees with supervisor
	UPDATE dbo.EMPLOYEE SET Super_ssn = null WHERE Super_ssn = @Ssn

	-- Remove Dependents
	DELETE dbo.EMPLOYEE WHERE Ssn=@Ssn

  RETURN 0;
GO

EXEC dbo.p_RemoveEmployee @Ssn=52;

--b) Crie um stored procedure que retorne um record-set com os funcionários gestores
--de departamentos, assim como o ssn e número de anos (como gestor) do
--funcionário mais antigo dessa lista.
GO
CREATE PROC dbo.p_GetManagers (@OldestSsn INT OUTPUT, @NumberYears INT OUTPUT)
AS
	BEGIN

	SELECT TOP 1 @OldestSsn=Ssn, @NumberYears=DATEDIFF(YEAR, D.Mgr_start_date, GETDATE())  
	FROM (dbo.DEPARTMENT AS D JOIN dbo.EMPLOYEE AS E on D.Mgr_ssn = E.Ssn) 
	ORDER BY Mgr_start_date DESC

	-- Funcionarios gestores de departamentos
	SELECT * FROM (dbo.DEPARTMENT AS D JOIN dbo.EMPLOYEE AS E on D.Mgr_ssn = E.Ssn)
	END
GO

DECLARE @OldestSsn INT;
DECLARE @NumberYears INT;
EXEC dbo.p_GetManagers @OldestSsn OUTPUT, @NumberYears OUTPUT

PRINT @OldestSsn
PRINT @NumberYears

--c) Construa um trigger que não permita que determinado funcionário seja definido
--como gestor de mais do que um departamento.
GO
CREATE TRIGGER t_EmployeeManager ON dbo.DEPARTMENT INSTEAD OF INSERT, UPDATE
AS
BEGIN
	DECLARE @Dname			AS VARCHAR(50);
	DECLARE @Dnumber		AS INT;
	DECLARE @Mgr_ssn		AS INT;
	DECLARE @Mgr_start_date AS DATE;

	SELECT @Dname=inserted.Dname, @Dnumber=inserted.Dnumber, @Mgr_ssn=inserted.Mgr_ssn, @Mgr_start_date=inserted.Mgr_start_date FROM inserted;
	
	-- only insert/update if no department has Mgr_ssn = Ssn
	IF @Mgr_ssn IN (SELECT Mgr_ssn FROM dbo.DEPARTMENT AS D WHERE D.Mgr_ssn = @Mgr_ssn) 
	BEGIN
		PRINT('Employee already manages one or more departements');
		RAISERROR('Department couldnt be created/updated. Employees cant manage more than one department', 16, 1);
	END
	ELSE
	BEGIN
		-- verify if Deleted Table is empty. if so, it's Insert, otherwise is Update
		IF EXISTS (SELECT * FROM deleted)	-- update
		BEGIN
			PRINT('Update')
			UPDATE dbo.DEPARTMENT SET Dname=@Dname, Dnumber=@Dnumber, Mgr_ssn=@Mgr_ssn, Mgr_start_date=@Mgr_start_date WHERE Dnumber=@Dnumber
		END
		ELSE
		BEGIN
			PRINT('Insert') 
			INSERT INTO dbo.DEPARTMENT SELECT * FROM inserted;
		END
	END	
END
GO

INSERT INTO dbo.DEPARTMENT VALUES ('Test', 54, 1, GETDATE()) -- Should fail
INSERT INTO dbo.DEPARTMENT VALUES ('Test', 54, 54, GETDATE()) -- Should work (if the employee exists)

-- d) Crie um trigger que não permita que determinado funcionário tenha um vencimento superior ao vencimento do gestor do seu departamento. Nestes casos, o trigger deve ajustar o salário do funcionário para um valor igual ao salário do gestor menos uma unidade.
GO
CREATE TRIGGER t_Capitalism ON dbo.EMPLOYEE AFTER INSERT, UPDATE
AS 
BEGIN
	DECLARE @Essn			AS INT;
	DECLARE @Esalary		AS INT;
	DECLARE @Dno			AS INT;
	DECLARE @Ssalary		AS INT;

	SELECT @Essn=inserted.Ssn, @Esalary=inserted.Salary, @Dno=inserted.Dno FROM inserted;
	SELECT @Ssalary=EMPLOYEE.Salary FROM DEPARTMENT
		JOIN EMPLOYEE ON DEPARTMENT.Mgr_ssn=EMPLOYEE.Ssn
		WHERE @Dno=DEPARTMENT.Dnumber;
	

	IF @Esalary>@Ssalary 
	BEGIN
		UPDATE EMPLOYEE
		SET EMPLOYEE.Salary=@Ssalary-1
		WHERE EMPLOYEE.Ssn=@Essn;
	END
END
GO

-- e) Crie uma UDF que, para determinado funcionário (ssn), devolva o nome e localização dos projetos em que trabalha.
GO
CREATE FUNCTION dbo.employeeProjects (@employeeSSN int) RETURNS @table TABLE ([name] varchar(50), [location] varchar(50))
AS
	BEGIN
		INSERT @table
			SELECT PROJECT.Pname, PROJECT.Plocation
			FROM PROJECT
			JOIN WORKS_ON ON WORKS_ON.Pno=PROJECT.Pnumber
			WHERE WORKS_ON.Essn=@employeeSSN;
		RETURN;
	END;
GO
SELECT * FROM dbo.employeeProjects(15);

-- f) Crie uma UDF que, para determinado departamento (dno), retorne os funcionários com um vencimento superior à média dos vencimentos desse departamento;
GO
CREATE FUNCTION dbo.highestPaidEmployees (@dno int) RETURNS @table TABLE (Fname varchar(50), Minit varchar(50), Lname varchar(50), Ssn int)
AS
	BEGIN
		INSERT @table
			SELECT EMPLOYEE.Fname, EMPLOYEE.Minit, EMPLOYEE.Lname, EMPLOYEE.Ssn
			FROM EMPLOYEE
			JOIN (SELECT Dno, AVG(Salary) 'depAvgSalary'
				FROM EMPLOYEE
				GROUP BY Dno) AS AVGSALARY
				ON AVGSALARY.Dno=EMPLOYEE.Dno
			WHERE EMPLOYEE.Salary > AVGSALARY.depAvgSalary
		RETURN;
	END;
GO
SELECT * FROM dbo.highestPaidEmployees(1);


-- g) Crie uma UDF que, para determinado departamento, retorne um record-set com os projetos desse departamento. Para cada projeto devemos ter um atributo com seu o orçamento mensal de mão de obra e outra coluna com o valor acumulado do orçamento.
-- Nota: parta do princípio que um funcionário trabalha 40 horas por semana para o cálculo do custo da sua afetação ao projeto.
-- Exemplo: select * from dbo.employeeDeptHighAverage(3);
-- Recomendação: utilize um cursor.
GO
CREATE FUNCTION dbo.departmentProjects (@dno int) RETURNS @table TABLE (ProjectName varchar(50), MensalBudget int, CumulativeBudget int)
AS
	BEGIN
		INSERT @table
			SELECT PROJECT.Pname,SUM(EMPLOYEE.Salary) 'MensalBudget',SUM(EMPLOYEE.Salary*WORKS_ON.[Hours]/160) 'CumulativeBudget'
			FROM DEPARTMENT
				JOIN PROJECT ON DEPARTMENT.Dnumber=PROJECT.Dnum
				JOIN WORKS_ON ON PROJECT.Pnumber=WORKS_ON.Pno
				JOIN EMPLOYEE ON WORKS_ON.Essn=EMPLOYEE.Ssn
			GROUP BY PROJECT.Pname
		RETURN;
	END;
GO
SELECT * FROM dbo.departmentProjects(1);



--h) Pretende-se criar um trigger que, quando se elimina um departamento, este passe
--para uma tabela department_deleted com a mesma estrutura da department. Caso
--esta tabela não exista então deve criar uma nova e só depois inserir o registo.
--Implemente a solução com um trigger de cada tipo (after e instead of). Discuta
--vantagens e desvantagem de cada implementação.
--Utilize a seguinte instrução para verificar se determinada tabela existe:
--IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
--WHERE TABLE_SCHEMA = 'myschema' AND TABLE_NAME = 'mytable'))
GO
CREATE TRIGGER t_RemoveDepartment_InsteadOf ON dbo.DEPARTMENT INSTEAD OF DELETE
AS
BEGIN
	PRINT('Instead Of Trigger')
	DECLARE @Dname			AS VARCHAR(50);
	DECLARE @Dnumber		AS INT;
	DECLARE @Mgr_ssn		AS INT;
	DECLARE @Mgr_start_date AS DATE;

	SELECT @Dname=deleted.Dname, @Dnumber=deleted.Dnumber, @Mgr_ssn=deleted.Mgr_ssn, @Mgr_start_date=deleted.Mgr_start_date FROM deleted;
	
	-- create new table deleted table
	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DEPARTMENT_DELETED'))
		CREATE TABLE DEPARTMENT_DELETED (
		Dname				string NOT NULL,
		Dnumber				int,
		Mgr_ssn				int,
		Mgr_start_date		date,
		CONSTRAINT DEPARTMENT_DELETED_PK PRIMARY KEY (Dnumber)
	);

	-- insert in the table
	INSERT INTO dbo.DEPARTMENT_DELETED SELECT * FROM deleted;

	-- remove from the original table
	DELETE FROM dbo.DEPARTMENT WHERE Dnumber=@Dnumber;
END
GO

GO
ENABLE TRIGGER t_RemoveDepartment_InsteadOf ON dbo.DEPARTMENT
GO
DISABLE TRIGGER t_RemoveDepartment_InsteadOf ON dbo.DEPARTMENT
GO

CREATE TRIGGER t_RemoveDepartment_After ON dbo.DEPARTMENT AFTER DELETE
AS
BEGIN
	PRINT('After Trigger')
	DECLARE @Dname			AS VARCHAR(50);
	DECLARE @Dnumber		AS INT;
	DECLARE @Mgr_ssn		AS INT;
	DECLARE @Mgr_start_date AS DATE;

	SELECT @Dname=deleted.Dname, @Dnumber=deleted.Dnumber, @Mgr_ssn=deleted.Mgr_ssn, @Mgr_start_date=deleted.Mgr_start_date FROM deleted;
	
	-- create new table deleted table
	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DEPARTMENT_DELETED'))
		CREATE TABLE DEPARTMENT_DELETED (
		Dname				string NOT NULL,
		Dnumber				int,
		Mgr_ssn				int,
		Mgr_start_date		date,
		CONSTRAINT DEPARTMENT_DELETED_PK PRIMARY KEY (Dnumber)
	);

	-- insert in the table
	INSERT INTO dbo.DEPARTMENT_DELETED SELECT * FROM deleted;
END
GO

GO
ENABLE TRIGGER t_RemoveDepartment_After ON dbo.DEPARTMENT
GO
DISABLE TRIGGER t_RemoveDepartment_After ON dbo.DEPARTMENT
GO

DELETE FROM dbo.DEPARTMENT WHERE Dnumber=54;

-- The difference between both approaches is that the INSTEAD OF trigger requires an explicit DELETE query to delete the entry from the Department table
-- while the AFTER trigger does not since it happens after the DELETE query. 
-- This means the INSTEAD OF trigger is more apropriate for a situation where we don't want to actually delete the Department from the original table but 
-- archive it in another table while the after is more apropriate for the opposite situations.

--i) Relativamente aos stored procedure e UDFs, enumere as suas mais valias e as
--características que as distingue. Dê exemplos de situações em que se deve utiliza
--cada uma destas ferramentas;
-- Both are compiled and saved to cache, meaning their run is optimized and faster than batch queries
-- and both can be used to implement more or less complex logic, allowing the creation of an abstraction
-- layer between the Database Schema and Applications.

-- The User Definied Functions can be used as source of data (in FROM clauses), but 
-- Stored Procedures can't - but both can return values. 
-- In UDFs it's also possible Schema Binding, unlike Stored Procedures.

-- Having in mind their characteristics, UDFs are ideal to perfom
-- queries on the database to retrieve information, while SP are better
-- for executing more complex logics (even if UDFs can do that too)