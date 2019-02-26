-- Databases
-- Pedro Teixeira 84715

-- Ex1

-- DROP TABLE Hello;

CREATE TABLE Hello (MsgID INT PRIMARY KEY, MsgSubject VARCHAR(30) NOT NULL); 

INSERT INTO Hello Values (1245, 'Ola tudo Bem. Pedro');

SELECT * FROM Hello;