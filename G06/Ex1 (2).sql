-- BD 2018/2019
-- Guião 6, Exercício 1
-- Paulo Brandão Vasconcelos
-- 84987
-- paulobvasconcelos@gmail.com

-- a) Todos os tuplos da tabela autores (authors)
SELECT * FROM authors;

-- b) O primeiro nome, o último nome e o telefone dos autores
SELECT au_fname,au_lname,phone
	FROM authors;

-- c) Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente)
SELECT au_fname,au_lname,phone
	FROM authors
	ORDER BY au_fname,au_lname;

-- d) Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone)
SELECT au_fname AS first_name,au_lname AS last_name,phone AS telephone
	FROM authors
	ORDER BY au_fname,au_lname;

-- e) Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’
SELECT au_fname AS first_name,au_lname AS last_name,phone AS telephone
	FROM authors
	WHERE [state]='CA' AND au_lname!='Ringer'
	ORDER BY au_fname,au_lname;

-- f) Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome
SELECT *
	FROM publishers
	WHERE pub_name LIKE '%Bo%';

-- g) Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’
--SELECT DISTINCT pub_id
--		FROM titles
--		WHERE [type]='Business';
SELECT DISTINCT pub_name
	FROM (publishers JOIN titles ON publishers.pub_id=titles.pub_id)
	WHERE [type]='Business';

-- h) Número total de vendas de cada editora
--SELECT *
--	FROM (publishers JOIN (titles JOIN sales ON titles.title_id=sales.title_id) ON publishers.pub_id=titles.pub_id);
SELECT publishers.pub_name, COUNT (*)
	FROM (publishers JOIN (titles JOIN sales ON titles.title_id=sales.title_id) ON publishers.pub_id=titles.pub_id)
	GROUP BY publishers.pub_id,publishers.pub_name
	ORDER BY publishers.pub_name;
	
-- i) Número total de vendas de cada editora agrupado por título
SELECT publishers.pub_name,titles.title, COUNT (*)
	FROM (publishers JOIN (titles JOIN sales ON titles.title_id=sales.title_id) ON publishers.pub_id=titles.pub_id)
	GROUP BY publishers.pub_id,publishers.pub_name,titles.title_id,titles.title
	ORDER BY publishers.pub_name,titles.title;

-- j) Nome dos títulos vendidos pela loja ‘Bookbeat’
SELECT title
	FROM (titles JOIN (sales JOIN stores ON sales.stor_id=stores.stor_id) ON titles.title_id=sales.title_id)
	WHERE stor_name='Bookbeat'
	ORDER BY title;

-- k) Nome de autores que tenham publicações de tipos diferentes
SELECT au_fname,au_lname
	FROM (titles JOIN (titleauthor JOIN authors ON titleauthor.au_id=authors.au_id) ON titles.title_id=titleauthor.title_id)
	GROUP BY au_fname,au_lname
	HAVING COUNT ([type])>1;


-- l) Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id)
SELECT [type],publishers.pub_id,AVG(titles.price) AS average_price,COUNT(*) AS total_sales
	FROM (publishers JOIN (titles JOIN sales ON titles.title_id=sales.title_id) ON publishers.pub_id=titles.pub_id)
	GROUP BY [type],publishers.pub_id;

-- m) Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo)
SELECT title,titles.[type],advance,avgAdv
	FROM titles JOIN
		(SELECT [type], AVG(advance) AS avgAdv
		FROM titles
		GROUP BY type) AS busiAvg
	ON titles.[type]=busiAvg.[type]
	WHERE advance>avgAdv*1.5;

-- n) Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda
SELECT titles.title,authors.au_fname,authors.au_lname AS author,SUM(sales.qty)*titles.price/(titles.royalty*titleauthor.royaltyper/100.0) AS MoneyMade
	FROM sales
    JOIN titles ON titles.title_id=sales.title_id
    JOIN titleauthor ON titles.title_id=titleauthor.title_id
    JOIN authors ON authors.au_id=titleauthor.au_id
	GROUP BY titles.title_id,titles.title,titles.price,titles.royalty,titleauthor.au_id,authors.au_fname,authors.au_lname,titleauthor.royaltyper;

-- o) Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora
SELECT title,ytd_sales,price*ytd_sales AS totalSalesValue,price*ytd_sales*royalty/100 AS authorsSalesValue,price*ytd_sales*(100-royalty)/100 AS pubSalesValue
	FROM titles;


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

-- t) Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora
