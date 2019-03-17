/* Guide 3, Exercise 3
 * C4_Stocks Management System
 * Pedro Teixeira <pedro.teix@ua.pt>
 * 12-March-2019
 */

 -- Define relations
 CREATE TABLE C4_Stocks.Product (
	code				int,
	name				string,
	price				money	NOT NULL DEFAULT 0,
	tax					real	NOT NULL DEFAULT 0,
	numUnitsStock		int		NOT NULL DEFAULT 0,
	CONSTRAINT PRODUCT_PK PRIMARY KEY (code),
	CONSTRAINT PRODUCT_UNIQUE UNIQUE (name),
	CONSTRAINT PRODUCT_STOCK CHECK (numUnitsStock >= 0)
 );

 CREATE TABLE C4_Stocks.OrderInfo (
	number				int,
	[date]				date,
	providerNIF			nif,
	CONSTRAINT ORDER_INFO_PK PRIMARY KEY (number)
 );

 CREATE TABLE C4_Stocks.Provider (
	nif					nif,
	name				string, 
	[address]			string,
	fax					nchar(9),
	paymentConditions	string,
	typeProvider		int,
	CONSTRAINT PROVIDER_PK PRIMARY KEY (nif)
 );

 CREATE TABLE C4_Stocks.TypeProvider (
	code				int,
	designation			string,
	CONSTRAINT TYPE_PROVIDER_PK PRIMARY KEY (code)
 );

 CREATE TABLE C4_Stocks.ProductsInOrder (
	productCode			int,
	orderNumber			int,
	quantity			int		NOT NULL DEFAULT 0,
	CONSTRAINT PRODUCTS_IN_ORDER_PK PRIMARY KEY (productCode, orderNumber),
	CONSTRAINT PRODUCTS_IN_ORDER_QUANTITY CHECK (quantity >= 0)
 );

 -- Assign foreign keys
 -- Kept default behavior on delete (ie SQL Server throws an exception)
 -- Setting as null would mean inconsistency on data
 ALTER TABLE C4_Stocks.OrderInfo			ADD FOREIGN KEY (providerNIF)	REFERENCES C4_Stocks.Provider(nif)			ON UPDATE CASCADE;
 ALTER TABLE C4_Stocks.Provider				ADD FOREIGN KEY (typeProvider)	REFERENCES C4_Stocks.TypeProvider(code)		ON UPDATE CASCADE;
 ALTER TABLE C4_Stocks.ProductsInOrder		ADD FOREIGN KEY (productCode)	REFERENCES C4_Stocks.Product(code)			ON UPDATE CASCADE;
 ALTER TABLE C4_Stocks.ProductsInOrder		ADD FOREIGN KEY (productCode)	REFERENCES C4_Stocks.OrderInfo(number)		ON UPDATE CASCADE;

 
 