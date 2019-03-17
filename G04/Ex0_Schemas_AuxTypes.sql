/* Guide 3
 * Schemas and Auxiliar Types
 * Pedro Teixeira <pedro.teix@ua.pt>
 * 17-March-2019
 */
 
-- Create Schemas
CREATE SCHEMA C4_RentACar;
CREATE SCHEMA C4_Stocks;
CREATE SCHEMA C4_Flights;

-- Create auxiliar types
CREATE TYPE string		FROM nchar(50) NOT NULL;
CREATE TYPE nif	    FROM nchar(9)  NOT NULL;
