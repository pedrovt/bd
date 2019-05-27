/* Guide 10, Exercise 2
 * Pedro Teixeira 
 * Paulo Vasconcelos
 * 23-May-2019
 */

 USE company;

-- Defina os índices que achar conveniente para cada uma das relações. Tenha em
-- atenção que usualmente temos necessidade de efetuar as seguintes consultas à 
-- base de dados:
--		i. O funcionário com determinado número ssn;						--> Non-Clustered Unique Key on Employee
--		ii. O(s) funcionário(s) com determinado primeiro e último nome;		-->	Non-Clustered Composite Key (First, Last Name) on Employee
--		iii. Os funcionários que trabalham para determinado departamento;	--> Non-Clustered Composite Key (Dno) [basically a covered query]
--		iv. Os funcionários que trabalham para determinado projeto;			--> Non-Clustered Unique Key (Essn) on WorksOn
--		v. Os dependentes de determinado funcionário;						--> Non-Clustered Unique Key (Essn) on Dependent
--		vi. Os projetos associados a determinado departamento;				--> Non-Clustered Unique Key (Dnum) on Project

