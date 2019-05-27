/* Guide 6, Exercise 1
 * Pedro Teixeira  
 * 28-March-2019 
 */ 
 
 use pubs;


--a) Todos os tuplos da tabela autores (authors);
SELECT * FROM authors;
--b) O primeiro nome, o último nome e o telefone dos autores;
--c) Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o
--último nome (ascendente);
--d) Consulta definida em c) mas renomeando os atributos para (first_name, last_name,
--telephone);
--e) Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é
--diferente de ‘Ringer’;
--f) Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome;
--g) Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’;
--h) Número total de vendas de cada editora;
--i) Número total de vendas de cada editora agrupado por título;
--j) Nome dos títulos vendidos pela loja ‘Bookbeat’;
--k) Nome de autores que tenham publicações de tipos diferentes;
--l) Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo
--(type) e editora (pub_id);
--m) Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça”
--(advance) é uma vez e meia superior à média do grupo (tipo);
--n) Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua
--venda;
--o) Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu
--nome, a faturação total, o valor da faturação relativa aos autores e o valor da
--faturação relativa à editora;
--p) Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu
--nome, o nome de cada autor, o valor da faturação de cada autor e o valor da
--faturação relativa à editora;
--q) Lista de lojas que venderam pelo menos um exemplar de todos os livros;
--r) Lista de lojas que venderam mais livros do que a média de todas as lojas.
--s) Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;
--t) Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora;