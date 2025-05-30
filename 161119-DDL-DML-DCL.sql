/*
KASH@london-training.com


SQL DATABASE ADMINISTRATION.


PASSWORD:		TSLT$$ADMIN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

DBMS database management system: to store data.

Relational:		(RDBMS)  RELATIONAL DATA BASE MANAGEMENT SYSTEM.	Create relation between data., It uses S. Q. L.

	-	Basically, Data is inserted to schema. Data is structured.
	-	Schema(they are just groups which are named with a specific group-name) : is making reference to two things mainly:
		-	Group of related object or tables or 
				- dbo. is a schema. 
		- 



		*** BLOB is the way in which for example, images, are stored in sql.


Non-relational: The way in which data is stored is different (is unstructured) versus Relational database. 
	-	it's stored in the JSON	structured
	-	it's Unstructured. 
	-	
	- 



	---------------------------------------------------
	Types of Database

	-	OLTP online transaction processing:	Used for Live/Current data.

	-	OLAP online analytcal processing: used for historical data

	------------------------------------------------------------------------------------------------------------------------------


	Instance:	
		-	Default: 
			- Instance name is autocatically taken as 'MSSQLSERVER'
			- For end user connections: Server name = PC-NAME or IP address



		-	Named instance:
			- Instance name is manually Specified During installation.
			- For end user connection server name = pc-Name/instance name or IP  address/instance name.


----------------------------------------------------------------------------------------------------------------------------------

Categories of SQL COMMANDS

- DDL (data definition language):		
	-Objects:
			- Tables
			- Vews
			- Fuction
			- Stored procedures...
	
	- Create
	- Alter
	- Drop




- DML (data manipulation language):
	- Insert
	- Update
	- Delete

- DCL (data control language):
	- Permition
		-Grant
		- Deny
		- Revoque

- TCL (transaction control language):
	- Commint transaction
	- save transaction
	- Roll back transaction

	===============================================================================================


sql server configuration manager --> instance = Main Server
																		  = Agent Service




----------------------------------------------------------------------------------------------------------------------------------------------------------------------

DATA TYPES:
==========

(I)		Characters:
		===========

			a)		Char: Fixed Lenght character string - 1 byte (characters, numbers, symbols)

				1.- Non-Unicode/ uses ASCII
				2.- 1 char = 1Byte// one character one byte.
				3.- 8000 bytes are the maximun character I can storage.

			b) Varchar: Fixed Lenght unicode string - 2 bytes ( unicode, characters, numbers, symbols) 
				1.-  8000 bytes are the maximun character I can storage.
				2.- I can type Varchar (max) to get up to 2GB of storage
				3.- It's faster.
				

			c) Nvarchar: Variable Lenght unicode string - 2 bytes ( unicode, characters, numbers, symbols) 
				1.- 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

A.||	DATA DEFENINTION LANGUAGE (DDL)
		================================
		(I)		CREATE 
		(II	)	ALTER
		(III)	DROP



B.|| DATA MANIPULATION LANGUAGE (DML)
	  ==================================

		(I)		SELECT 
		(II)	INSERT
		(III)	UPDATE
		(IV)	DELETE

*/


Create database Administration

use Administration

--Rename a database

/*
There are 2 ways to rename a database:
============================

By using the 'Alter' command.
By usin one of the System Stored Procedures (sp_renamedb).

*/


--Rename a database : Using 'Alter' command:

Alter database Administration modify name = AdministrationDB


--By Using system stored procedure

exec sp_renamedb 'Administration2', 'Administration'

Use AdministrationDB