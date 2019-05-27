/* Guide 6, Exercise 2, Company
 * 30-March-2019
 */

-- a) Obtenha uma lista contendo os projetos e funcionários (ssn e nome completo) que lá trabalham;
-- π Pno, Essn, Fname, Minit, Lname (works_on) ⨝ ρ Essn←Ssn (π Ssn, Fname, Minit, Lname (employee))
SELECT *
FROM (WORKS_ON JOIN (SELECT Ssn, Fname, Minit, Lname FROM EMPLOYEE) AS E ON WORKS_ON.Essn = E.Ssn)

-- b) Obtenha o nome de todos os funcionários supervisionados por ‘Carlos D Gomes’;
-- π Fname, Minit, Lname ((employee) ⨝ ρ Super_ssn←Ssn (π Ssn (σ Fname ='Carlos' AND Minit='D' AND Lname='Gomes' (employee))))
SELECT Fname, Minit, Lname 
FROM (EMPLOYEE JOIN (SELECT Ssn FROM EMPLOYEE WHERE Fname ='Carlos' AND Minit='D' AND Lname='Gomes') AS p_ssn on EMPLOYEE.Ssn = p_ssn.Ssn);

-- c) Para cada projeto, listar o seu nome e o número de horas (por semana) gastos nesse projeto por todos os funcionários;
-- π Pname, thours (project ⨝ (ρ Pnumber←Pno (γ Pno; thours←sum(Hours) works_on)))
SELECT Pname, thours 
FROM (project join (SELECT Pno, sum(Hours) as thours FROM works_on GROUP BY Pno) AS p ON project.Pnumber=p.Pno);

-- d) Obter o nome de todos os funcionários do departamento 3 que trabalham mais de 20 horas por semana no projeto ‘Aveiro Digital’;
-- worksInProject = ρ Pnumber←Pno (works_on) ⨝ σ Pname='Aveiro Digital' (project)		--employees working on the project
-- worksMoreThan20Hours = ρ Ssn←Essn σ Hours>20 (worksInProject)											 --...working more than 20h
-- employeesDep3 = σ Dno=3 (employee)																								 --employees working in dep 3
-- π Fname, Minit, Lname (employeesDep3 ⨝ worksMoreThan20Hours)
SELECT Fname, Minit, Lname
FROM (SELECT * FROM EMPLOYEE WHERE Dno=3) AS E JOIN (SELECT * FROM (WORKS_ON JOIN (SELECT * FROM PROJECT WHERE Pname='Aveiro Digital') as PROJ ON WORKS_ON.Pno = PROJ.Pnumber) WHERE Hours > 20) AS P ON E.Ssn=P.Essn;

-- e) Nome dos funcionários que não trabalham para projetos;
-- employeesProjects = employee ⟕ ρ Ssn←Essn works_on
-- employeesNotInProjects = σ Pno=null employeesProjects
-- π Fname, Minit, Lname employeesNotInProjects
SELECT Fname, Minit, Lname FROM EMPLOYEE LEFT OUTER JOIN WORKS_ON ON EMPLOYEE.Ssn = WORKS_ON.Essn WHERE Pno = NULL;

-- f) Para cada departamento, listar o seu nome e o salário médio dos seus funcionários do sexo feminino;
-- femaleEmployees = department ⨝ (ρ Dnumber←Dno σ Sex='F' employee)
-- γ Dname; avgSalary←avg(Salary) femaleEmployees
SELECT DEPARTMENT.Dname, avg(Salary) AS avgSalary 
FROM (DEPARTMENT JOIN (SELECT * FROM EMPLOYEE WHERE Sex='F') AS EMP ON DEPARTMENT.Dnumber = EMP.Dno) 
GROUP BY DEPARTMENT.Dname;

-- g) Obter uma lista de todos os funcionários com mais do que dois dependentes;
-- countDependents = ρ Ssn←Essn γ Essn; count←count(Dependent_name) dependent
-- countDependentsMore2 = σ count > 2 countDependents
-- (countDependentsMore2 ⋊ employee)
SELECT * 
FROM (EMPLOYEE LEFT JOIN (SELECT Essn, COUNT(Dependent_name) AS NumDependents FROM DEPENDENT GROUP BY Dependent_name, Essn HAVING COUNT(Dependent_name) > 2) AS COUNT_DEPENDENTS ON COUNT_DEPENDENTS.Essn=EMPLOYEE.Ssn)

-- h) Obtenha uma lista de todos os funcionários gestores de departamento que não têm dependentes;
-- managers = employee ⨝ (ρ Ssn←Mgr_ssn department)
-- dependentsOfManagers = managers ⟕ (ρ Ssn←Essn dependent)
-- σ Dependent_name = null dependentsOfManagers 
SELECT * 
FROM DEPENDENT LEFT OUTER JOIN (SELECT * FROM EMPLOYEE JOIN DEPARTMENT ON EMPLOYEE.Ssn=DEPARTMENT.Mgr_ssn) AS MANAGERS ON DEPENDENT.Essn=MANAGERS.Ssn
WHERE Dependent_name = NULL

-- i) Obter os nomes e endereços de todos os funcionários que trabalham em, pelo menos, um projeto localizado em Aveiro mas o seu departamento não tem nenhuma localização em Aveiro.
-- employeesAveiroProjs = ρ Dnumber←Dno employee ⨝ ρ Ssn←Essn (works_on ⨝ ρ Pno←Pnumber σ Plocation='Aveiro' project)
-- π Fname, Minit, Lname, Address σ Dlocation != 'Aveiro' (dept_location ⨝ employeesAveiroProjs)
SELECT Fname, Minit, Lname, Address 
FROM DEPT_LOCATIONS JOIN (SELECT * FROM EMPLOYEE JOIN (SELECT * FROM WORKS_ON JOIN (SELECT * FROM PROJECT WHERE Plocation='Aveiro') AS PROJ ON WORKS_ON.Pno=PROJ.Pnumber) AS WORK_PROJ ON EMPLOYEE.Ssn = WORK_PROJ.Essn) AS EMP_AVEIRO ON DEPT_LOCATIONS.Dnumber=EMP_AVEIRO.Dnum 
WHERE Dlocation != 'Aveiro'


 
