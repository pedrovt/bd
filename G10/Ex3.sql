/* Guide 10, Exercise 2
 * Pedro Teixeira 
 * Paulo Vasconcelos
 * 23-May-2019
 */

 USE company;

-- Defina os �ndices que achar conveniente para cada uma das rela��es. Tenha em
-- aten��o que usualmente temos necessidade de efetuar as seguintes consultas � 
-- base de dados:
--		i. O funcion�rio com determinado n�mero ssn;						--> Non-Clustered Unique Key on Employee
--		ii. O(s) funcion�rio(s) com determinado primeiro e �ltimo nome;		-->	Non-Clustered Composite Key (First, Last Name) on Employee
--		iii. Os funcion�rios que trabalham para determinado departamento;	--> Non-Clustered Composite Key (Dno) [basically a covered query]
--		iv. Os funcion�rios que trabalham para determinado projeto;			--> Non-Clustered Unique Key (Essn) on WorksOn
--		v. Os dependentes de determinado funcion�rio;						--> Non-Clustered Unique Key (Essn) on Dependent
--		vi. Os projetos associados a determinado departamento;				--> Non-Clustered Unique Key (Dnum) on Project

