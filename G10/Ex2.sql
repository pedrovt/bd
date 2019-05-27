/* Guide 10, Exercise 2
 * Paulo Vasconcelos
 * Pedro Teixeira 
 * 22-May-2019
 */
 
 use IndexesTests;

 CREATE TABLE mytemp (
	rid BIGINT /*IDENTITY (1, 1)*/ NOT NULL,
	at1 INT NULL,
	at2 INT NULL,
	at3 INT NULL,
	lixo varchar(100) NULL
);

-- ################################################################################################################
-- a) Defina rid como chave primária do tipo Clustered Index;
CREATE CLUSTERED INDEX IndexRid ON mytemp(rid);

-- ################################################################################################################
-- b) Registe os tempos de introdução de 50000 novos registos (tuplos) na tabela utilizando o código abaixo:

-- Record the Start Time
DECLARE @start_time DATETIME, @end_time DATETIME;
SET @start_time = GETDATE();
PRINT @start_time

-- Generate random records
DECLARE @val as int = 1;
DECLARE @nelem as int = 50000;

SET nocount ON

WHILE @val <= @nelem
BEGIN
	DBCC DROPCLEANBUFFERS; -- need to be sysadmin
	INSERT mytemp (rid, at1, at2, at3, lixo)
	SELECT	cast((RAND()*@nelem*40000) as int), cast((RAND()*@nelem) as int),
			cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
			'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
	SET @val = @val + 1;
END

PRINT 'Inserted ' + str(@nelem) + ' total records'

-- Duration of Insertion Process
SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND, @start_time, @end_time));

-- Results
-- Milliseconds used: 63756
USE tempdb;
SELECT * FROM sys.dm_db_index_physical_stats ( db_id('IndexesTests'), object_id('Frag'), NULL, NULL, 'DETAILED');

-- Fragmentation: 99.4172494172494 
-- Page Space Used: 68.3733629849271  

---- Full results
--database_id object_id   index_id    partition_number index_type_desc                                              alloc_unit_type_desc                                         index_depth index_level avg_fragmentation_in_percent fragment_count       avg_fragment_size_in_pages page_count           avg_page_space_used_in_percent record_count         ghost_record_count   version_ghost_record_count min_record_size_in_bytes max_record_size_in_bytes avg_record_size_in_bytes forwarded_record_count compressed_page_count
------------- ----------- ----------- ---------------- ------------------------------------------------------------ ------------------------------------------------------------ ----------- ----------- ---------------------------- -------------------- -------------------------- -------------------- ------------------------------ -------------------- -------------------- -------------------------- ------------------------ ------------------------ ------------------------ ---------------------- ---------------------
--11          245575913   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  3           0           99.4172494172494             858                  1                          858                  68.3733629849271               50000                0                    0                          93                       97                       93                       NULL                   0
--11          245575913   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  3           1           0                            2                    1                          2                    90.0790709167284               858                  0                    0                          15                       15                       15                       NULL                   0
--11          245575913   1           1                CLUSTERED INDEX                                              IN_ROW_DATA                                                  3           2           0                            1                    1                          1                    0.395354583642204              2                    0                    0                          15                       15                       15                       NULL                   0

--(3 row(s) affected)



-- ################################################################################################################
-- c) Varie o fillfactor (por exemplo: 65, 80 e 90) do clustered index e veja o efeito nos tempos de inserção.

-- Original Milliseconds used: 63756

DROP INDEX IndexRid on dbo.mytemp;
CREATE CLUSTERED INDEX IndexRid ON mytemp(rid) WITH (FILLFACTOR = 65, PAD_INDEX = ON);
-- Milliseconds used: 58490

DROP INDEX IndexRid on dbo.mytemp;
CREATE CLUSTERED INDEX IndexRid ON mytemp(rid) WITH (FILLFACTOR = 80, PAD_INDEX = ON);
-- Milliseconds used: 57236

DROP INDEX IndexRid on dbo.mytemp;
CREATE CLUSTERED INDEX IndexRid ON mytemp(rid) WITH (FILLFACTOR = 90, PAD_INDEX = ON);
-- Milliseconds used: 59636

-- ################################################################################################################
-- d) Altere a tabela mytemp para que o atributo rid passe a ser do tipo identity. Volte a medir os tempos de inserção6.
-- ALTER TABLE dbo.mytemp ALTER COLUMN rid BIGINT IDENTITY(1, 1) NOT NULL,
CREATE TABLE mytemp2 (
	rid BIGINT IDENTITY (1, 1) NOT NULL,
	at1 INT NULL,
	at2 INT NULL,
	at3 INT NULL,
	lixo varchar(100) NULL
);

CREATE CLUSTERED INDEX IndexRid ON mytemp2(rid);

GO
-- Record the Start Time
DECLARE @start_time DATETIME, @end_time DATETIME;
SET @start_time = GETDATE();
PRINT @start_time

-- Generate random records
DECLARE @val as int = 1;
DECLARE @nelem as int = 50000;

SET nocount ON

WHILE @val <= @nelem
BEGIN
	DBCC DROPCLEANBUFFERS; -- need to be sysadmin
	INSERT mytemp2 (at1, at2, at3, lixo)
	SELECT	cast((RAND()*@nelem) as int),
			cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
			'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
	SET @val = @val + 1;
END

PRINT 'Inserted ' + str(@nelem) + ' total records'

-- Duration of Insertion Process
SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND, @start_time, @end_time));

GO

-- Milliseconds used: 51830

-- ################################################################################################################
-- e) Crie um índice para cada atributo da tabela mytemp. Compare os tempos de inserção obtidos, sem e com todos os índices. O que pode concluir?

-- Sem
-- Milliseconds used: 151 400

-- Com
--CREATE INDEX IndexRid ON mytemp(rid);
CREATE INDEX IndexAt1 ON mytemp(at1);
CREATE INDEX IndexAt2 ON mytemp(at2);
CREATE INDEX IndexAt3 ON mytemp(at3);
CREATE INDEX IndexLixo ON mytemp(lixo);
-- Milliseconds used: 346 350
-- On each insertion, we have to access the disk both to read the page where the new tuple is inserted and to change the index
-- Since the 2nd result is obtained using more indexes, that means there will be more indexes to be changed on each insertion,
-- which means more accesses to the disks - to read the pages where the indexes are - and thus more time is needed to perform the operations 
-- than when using just 1 index.