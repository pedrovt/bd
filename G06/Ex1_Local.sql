/* Guide 6, Exercise 1
 * Pedro Teixeira  
 * 28-March-2019 
 */ 
 
 use pubs;

--a) Todos os tuplos da tabela autores (authors);
SELECT * 
FROM authors;		

--b) O primeiro nome, o último nome e o telefone dos autores;
SELECT au_fname, au_lname, phone 
FROM authors;	-- Projection

--c) Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o
--último nome (ascendente);
SELECT au_fname, au_lname, phone 
FROM authors 
ORDER BY au_fname, au_lname DESC;

--d) Consulta definida em c) mas renomeando os atributos para (first_name, last_name,
--telephone);
SELECT au_fname AS first_name, au_lname AS last_name, phone 
FROM authors 
ORDER BY au_fname, au_lname DESC;

--e) Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é
--diferente de ‘Ringer’;
SELECT au_fname AS first_name, au_lname AS last_name, phone 
FROM authors 
WHERE [state]='CA' AND au_lname!='Ringer'
ORDER BY au_fname, au_lname DESC;

--f) Todas AS editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome;
SELECT * 
FROM publishers 
WHERE pub_name LIKE '%Bo%';

--g) Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’;
SELECT DISTINCT pub_name 
FROM (publishers AS p JOIN (SELECT * from titles WHERE type='Business') AS t ON p.pub_id=t.pub_id);

--h) Número total de vendas de cada editora;
-- Natural Join of Sales with Title -> group by pub_id -> natural join with publishers
SELECT pub_name, numSales 
FROM (publishers AS p JOIN (SELECT pub_id, COUNT(*) AS numSales FROM (sales AS s JOIN titles AS t ON s.title_id = t.title_id) GROUP BY pub_id) AS s ON p.pub_id=s.pub_id);

--i) Número total de vendas de cada editora agrupado por título;
-- Natural Join of Sales with Title -> group by pub_id, title -> natural join with publishers
SELECT pub_name, title, numSales 
FROM (publishers AS p JOIN (SELECT pub_id, title, COUNT(*) AS numSales FROM (sales AS s JOIN titles AS t ON s.title_id = t.title_id) GROUP BY pub_id, title) AS s ON p.pub_id=s.pub_id)
ORDER BY pub_name, title;

--j) Nome dos títulos vendidos pela loja ‘Bookbeat’;
-- Natural Join of (stores selection name = 'Bookbeat') with sales -> natural join of sales with title -> select title
SELECT title 
FROM (titles JOIN (SELECT stores.stor_id, title_id FROM (sales JOIN (SELECT stor_id FROM stores WHERE stor_name='Bookbeat') AS stores ON sales.stor_id=stores.stor_id)) AS store_sales ON titles.title_id=store_sales.title_id);

--k) Nome de autores que tenham publicações de tipos diferentes;
SELECT au_fname, au_lname, count
FROM authors AS a1 JOIN (SELECT t2.au_id, COUNT(DISTINCT(type)) as count FROM titles AS t1 JOIN titleauthor AS t2 ON t1.title_id = t2.title_id GROUP BY t2.au_id) AS a2 ON a1.au_id = a2.au_id
WHERE count > 1

--l) Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo
--(type) e editora (pub_id);
SELECT type, pub_id, AVG(price), SUM(ytd_sales)  
FROM titles
GROUP BY type, pub_id

--m) Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça”
--(advance) é uma vez e meia superior à média do grupo (tipo);
SELECT type
FROM titles 
GROUP BY type
HAVING MAX(advance) > 1.5 * AVG(advance)


--n) Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua
--venda;
SELECT au_lname, au_fname, total, title_id, title
FROM authors JOIN (SELECT au_id, titleauthor.title_id, t2.title, total FROM titleauthor JOIN (SELECT titles.title_id, titles.title, price*qty AS total FROM sales JOIN titles on sales.title_id = titles.title_id) as t2 on titleauthor.title_id = t2.title_id) as authors_title_totals ON authors.au_id = authors_title_totals.au_id

--o) Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu
--nome, a faturação total, 
SELECT ytd_sales, title, price*qty AS total 
FROM sales JOIN titles on sales.title_id = titles.title_id
GROUP BY title;

-- p) Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora
SELECT titles.title,ytd_sales,price*ytd_sales AS totalSalesValue,price*ytd_sales*royalty/100 AS authorsSalesValue,price*ytd_sales*(100-royalty)/100 AS pubSalesValue
	FROM titles
	JOIN titleauthor ON titles.title_id=titleauthor.title_id
	JOIN authors ON titleauthor.au_id=authors.au_id;
-- NOT FINISHED

-- q) Lista de lojas que venderam pelo menos um exemplar de todos os livros
SELECT DISTINCT stores.stor_id
	FROM stores
	JOIN sales ON sales.stor_id=stores.stor_id
	GROUP BY stores.stor_id
	HAVING COUNT(sales.title_id) = (SELECT COUNT(titles.title_id) FROM titles);

-- r) Lista de lojas que venderam mais livros do que a média de todas as lojas
SELECT *
	FROM    (SELECT sales.stor_id,COUNT(sales.stor_id) AS NumSales
		FROM stores JOIN sales ON sales.stor_id=stores.stor_id
		GROUP BY sales.stor_id) AS John
	WHERE NumSales > (SELECT AVG(NumSales)
        FROM    (SELECT sales.stor_id,COUNT(sales.stor_id) AS NumSales
        FROM stores JOIN sales ON sales.stor_id=stores.stor_id
        GROUP BY sales.stor_id) AS John);

-- s) Nome dos títulos que nunca foram vendidos na loja “Bookbeat”
SELECT title
	FROM titles
	LEFT JOIN sales
		JOIN stores ON stores.stor_id=sales.stor_id
	ON sales.title_id=titles.title_id
	EXCEPT
	SELECT title
		FROM titles JOIN sales JOIN stores
		ON sales.stor_id = stores.stor_id
		ON titles.title_id=sales.title_id
		WHERE stor_name='Bookbeat';

--t) Para cada editora, a lista de todas AS lojas que nunca venderam títulos dessa editora;