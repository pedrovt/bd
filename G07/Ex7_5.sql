USE pubs;

--a) Construa a seguintes views3:
--i. Nome dos títulos e nome dos respetivos autores;
CREATE VIEW Titles_Authores AS
SELECT title, au_lname, au_fname 
FROM titles JOIN (SELECT title_id, au_lname, au_fname FROM titleauthor JOIN authors ON titleauthor.au_id = authors.au_id) AS authors ON titles.title_id = authors.title_id

--ii. Nome dos editores e nome dos respetivos funcionários;
CREATE VIEW Editors_Employee AS
SELECT pub_name, fname, lname 
FROM publishers JOIN employee ON publishers.pub_id = employee.pub_id

--iii. Nome das lojas e o nome dos títulos vendidos nessa loja;
CREATE VIEW Stores_TitlesSold AS
SELECT stor_name, title 
FROM stores JOIN (SELECT title, stor_id from titles JOIN sales ON titles.title_id=sales.title_id) as titlesSales ON stores.stor_id=titlesSales.stor_id

--iv. Livros do tipo ‘Business’;
CREATE VIEW Business_Books AS
SELECT *
FROM titles
WHERE type='Business'
WITH CHECK OPTION;

--b) Construa uma consulta tendo como base cada uma das views definidas na alínea a);

SELECT title FROM Titles_Authores WHERE au_lname='Ringer';								--i.
SELECT fname, lname FROM Editors_Employee WHERE pub_name ='New Moon Books';				--ii.
SELECT stor_name, COUNT(title) AS numTitles FROM Stores_TitlesSold GROUP BY stor_name;	--iii.
SELECT title FROM Business_Books where price=19.99;										--iv.

--c) Altere as views i e iii da alínea a) para que se possa implementar uma consulta que
--as utilize como fonte de dados para implementar a seguinte consulta: “Nome das
--lojas e nome dos autores vendidos na loja”;
CREATE VIEW Stores_Authors AS
SELECT S.stor_name, T.au_fname, T.au_lname  FROM Stores_TitlesSold AS S JOIN Titles_Authores AS T ON S.title=T.title

SELECT * FROM Stores_Authors;

--d) Relativamente à view iv da alínea a) execute o seguinte comando4:
insert into Business_Books (title_id, title, type, pub_id, price, notes)
values('BDTst1', 'New BD Book','popular_comp', '1389', $30.00, 'A must-read for DB course.')

--i. Teve sucesso na sua execução? Faz sentido?
--Msg 550, Level 16, State 1, Line 39
--The attempted insert or update failed because the target view either specifies WITH CHECK OPTION or spans a view that specifies WITH CHECK OPTION and one or more rows resulting from the operation did not qualify under the CHECK OPTION constraint.
--The statement has been terminated.

-- The insert query is not successfull since the type is not Business and with check option ensures the WHERE condition is veryied upon update/insertion

--ii. Altere a view (iv da alínea a) para corrigir o problema.
-- Remove the check option
CREATE VIEW Business_Books_2 AS
SELECT *
FROM titles
WHERE type='Business';

--iii. Volte a testar a instrução acima.
insert into Business_Books_2 (title_id, title, type, pub_id, price, notes)
values('BDTst1', 'New BD Book','popular_comp', '1389', $30.00, 'A must-read for DB course.')

-- result (1 row(s) affected)
