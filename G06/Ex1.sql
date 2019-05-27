/* Guide 6, Exercise 1
 * Pedro Teixeira  
 * 28-March-2019 
 */ 
 
 use pubs;


--a) Todos os tuplos da tabela autores (authors);
SELECT * FROM authors;
--b) O primeiro nome, o �ltimo nome e o telefone dos autores;
--c) Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o
--�ltimo nome (ascendente);
--d) Consulta definida em c) mas renomeando os atributos para (first_name, last_name,
--telephone);
--e) Consulta definida em d) mas s� os autores da Calif�rnia (CA) cujo �ltimo nome �
--diferente de �Ringer�;
--f) Todas as editoras (publishers) que tenham �Bo� em qualquer parte do nome;
--g) Nome das editoras que t�m pelo menos uma publica��o do tipo �Business�;
--h) N�mero total de vendas de cada editora;
--i) N�mero total de vendas de cada editora agrupado por t�tulo;
--j) Nome dos t�tulos vendidos pela loja �Bookbeat�;
--k) Nome de autores que tenham publica��es de tipos diferentes;
--l) Para os t�tulos, obter o pre�o m�dio e o n�mero total de vendas agrupado por tipo
--(type) e editora (pub_id);
--m) Obter o(s) tipo(s) de t�tulo(s) para o(s) qual(is) o m�ximo de dinheiro �� cabe�a�
--(advance) � uma vez e meia superior � m�dia do grupo (tipo);
--n) Obter, para cada t�tulo, nome dos autores e valor arrecadado por estes com a sua
--venda;
--o) Obter uma lista que inclu�a o n�mero de vendas de um t�tulo (ytd_sales), o seu
--nome, a fatura��o total, o valor da fatura��o relativa aos autores e o valor da
--fatura��o relativa � editora;
--p) Obter uma lista que inclu�a o n�mero de vendas de um t�tulo (ytd_sales), o seu
--nome, o nome de cada autor, o valor da fatura��o de cada autor e o valor da
--fatura��o relativa � editora;
--q) Lista de lojas que venderam pelo menos um exemplar de todos os livros;
--r) Lista de lojas que venderam mais livros do que a m�dia de todas as lojas.
--s) Nome dos t�tulos que nunca foram vendidos na loja �Bookbeat�;
--t) Para cada editora, a lista de todas as lojas que nunca venderam t�tulos dessa editora;