/*

SYSTEM DATABASES

	-Master
	-Model
	-MSDB
	-Tempdb
	-Resource


USER DATABASES
	-uNIVERSITY DATABASE
	-Emoployee





	SySTEM DATABASES go to: https://docs.microsoft.com/en-us/sql/relational-databases/databases/system-databases?view=sql-server-ver15 
	-------------------------------------------------------------------------

	MASTER: Every database get lock into the master system database, its means that control every master system.

	1. Records all the system-level information for an instance of SQL server
	2. Used to store information like server (Instance) Name, Connetcions, SP IDs(sesion process ID), Locations of Other databases.
	

	MODEL
	1. Used to create templates for new databases we create.
	2. Used as template for all databases created on the instance of SQL Server.
	3. All table I create in the following route: AJLR(SQL Server...) -->Databases--> System databases--> Model--> tables--> 
		right botom--> create table.; will appear in any database I create in "system Databases" as "built in"
	


	MSDB very very important
	1. Used to contain audit reports and history information required for database administrators.
	2. used by SQL Server agent for scheduling alerts and jobs. it is on the left, on the bottom "SQL Server Agent"


	TEMPDB (temporary objects)
	1. Every time you start the system its created.
	2. Used to provide us a temporary space for calculations and also for faster response from SQL server.
	3. Workspace for holding temporary objects or intermediate result sets.

	RESOURCE
	1. this database cnannot be seen in SSMS for security reasons
	2. Resource database is a read-only database that contains system objets. taht are inclueded from SQL  server 2012 and higer versions
	3.System objects are physically persisted in the resource database
	4.Resource databse can be used for sderver repairs and metadata


	DISTRIBUTION
	its all about source and destination
	
	
====================================================================================================
====================================================================================================

	SQL SERVER ARCHITECTER
	----------------------------------------

	Wen you write a query you are writein it in the client component but its executed in the server. what happen in the server is the following:

	SQL SERVER ACHITTECTURE is classified into three categories:

	1. Network protocol/external protocols
	2. Database engine/SQL engine
	3. SQLOS API



	DATABASE ARCHITECTER
	-------------------------------------
	File group:

	


	Primary file group------------------------------------>Data Pages(is divided into three parts)
																										----------------------->HEADER (96 bytes)
																																			>>File ID
																																			>>Page_ID
																																			>>Space_info
																																			>>Meta_data
																										----------------------->Body	(8050bytes)
																																			>>Row by row format
																																			>>
																																			>>
																										----------------------->Offset Rows(36bytes)
																																			>>8kb x 8 =Extent(64kb):
																																										>>Mixed
																																										>>Unifrom
																																			>>
																																			>>


			


Log Data File/
Transaction log file.---------------------(log data pages)
																										----------------------->Logs
																																			>> 
																																			>>
																																			>>
																																			>>
																										----------------------->Data
																																			>>   
																																			>>
																																			>>
																										-----------------------> Recovery models
																																			>>Simple
																																							-Minimal data involved
																																							-Minimal amount of transactions(overwrite the																											last one)										
																																			>>Bulk logged
																																							-Except bulk statements/transactions
																																							-Bulk Operations(examples of it are the																														following):
																																									-Select into
																																									-Insert into select from
																																									-Import/export
																																			>>Full (Default)
																																						-Transaction(include bulk statments)
																																						-Data
		
			Secondary file group------------------------------------>Secondary Data Files
																										----------------------->
																																			>> 
																																			>>
																																			>>
																																			>>
																										----------------------->Body	()
																																			>> 
																																			>>
																																			>>
																										-----------------------> ()
																																			>>   
																																										>>
																																										>>
																																			>>
																																			>>



"Relations between Buffer Vs. Disk":

-Read-Ahead	Reads/logs
-Dirty Pages
-Wal(write head log)
-Cold pages/Active pages
-Lazy writer


====================================================================================================
====================================================================================================
====================================================================================================
*/




Create database AdministrationDB
Use AdministrationDB

-- How to report the list of all tables in the current database?
Select* from sys.tables

--tbl Employee
Create table tblEmployee
(
	ID int primary key,
	Name nvarchar(30)
)

go

Insert into tblEmployee values
(1, 'Sam')

go

Select * from tblEmployee

--DBCC = Database consistency check
--Console Command





--DBCC  IND ('DatabaseName' or 'Database ID', 'ObjectName' or 'ObjectID', PageType)

DBCC IND('AdministrationDB','tblEmployee', -1)----[-1] Indicates all pages(index page, data page, etc...)

/*
PageType 10 = IAM page (Index Allocation Map)

PageType 1 = Data Page

*/

--IAM Page = Contain information about extent used by a table or index, and address of the data page.


--Note: When we insert a record into a table, first thing it will do is query the IAM page, and from the IAM page it gets the address
--of the data page where it will go and store the data.


--Trace Flag 3604 = Enabling this trace flag will give the output of the DBCC commands to screen or prints the output to the result window.

DBCC Traceon(3604)
--DBCC execution completed. If DBCC printed error messages, contact your system administrator.



--================================================================

Declare @db_id int
Declare @name nvarchar(30)

Select
		@name = name, --as [Database Name],
		@db_id = database_id --as [Database ID]
From sys.databases
Where name = 'AdministrationDB'


Print @db_id
Print @name


--===========================================================
--================================================================

Declare @db_id int
Declare @name nvarchar(30)

Select
		@name = name, --as [Database Name],
		@db_id = database_id --as [Database ID]
From sys.databases
Where name = 'AdministrationDB'

DBCC Page (@name, 1,256,1)

--Print @db_id
--Print @name


--DBCC Page ('databaseName' or DB_ID, 'IAMFID', 'PagePID', 1 for overall view or 3 detailed view)

--===========================================================

--******************************************************************


Create database FilegroupDB

use FilegroupDB

Select * from sys.filegroups

--Add a secondery filegroup:
--===================

Alter database FilegroupDB
Add Filegroup FG1_FilegroupDB


--Verify
Select * from sys.filegroups



/*
Name = Logical Name; which can be checked running --> Select * from sys.filegroups
FileName = Physical Name; which can be checked running --> Select * from sys.sysfiles

*/
--Checking it go to:

Select * from sys.sysfiles

--and take a look name and filename


--Add a file to the above filegroup:
--=======================
--I copy 'C:\Program Files\Microsoft SQL Server\MSSQL13.SECOND_INSTANCE\MSSQL\DATA\FilegroupDB.mdf
--take out this:FilegroupDB.mdf
--paste:File1_FG1_FilegroupDB.ndf


Alter database FilegroupDB 
add file
(
	Name = File1_FG1_FilegroupDB,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SECOND_INSTANCE\MSSQL\DATA\File1_FG1_FilegroupDB.ndf'
) To Filegroup FG1_FilegroupDB




--Verify 
Select * from sys.sysfiles




--Add a file to the above filegroup:
--=======================
--pay attention to file2 only its changed the number -2-


Alter database FilegroupDB 
add file
(
	Name = File2_FG1_FilegroupDB,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SECOND_INSTANCE\MSSQL\DATA\File2_FG1_FilegroupDB.ndf'
) To Filegroup FG1_FilegroupDB

--Verify 
Select * from sys.sysfiles


select * from sys.filegroups


--Remove file2:
--==========
Alter database FilegroupDB
Remove File File2_FG1_FilegroupDB


--Verify 
Select * from sys.sysfiles





--===========================================

--Rename a physical filename:


--For instance, change the prior for this one: C:\Users\LT Admin\Desktop\AntonioLopez\File1_FG1_FilegroupDB.ndf'


Alter database FilegroupDB
Modify File
(
	Name = File1_FG1_FilegroupDB,
	FileName = 'C:\Users\LT Admin\Desktop\AntonioLopez\File1_FG1_FilegroupDB.ndf'
)



--Rename a logical filename:
Alter  database FilegroupDB
Modify file 
(
	Name = File1_FG1_FilegroupDB,
	NewName = File1_FG1_FilegroupDB_New
)


--Verify 
Select * from sys.sysfiles

--





go

'QUESTIONS'

/*
+++Filegroup, What is it the porpouse?





*/


--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++






/*

												SYSTEM DATABASE
			
	https://docs.microsoft.com/en-us/sql/relational-databases/databases/system-databases?view=sql-server-ver15 

	A||		Master

	B||		Model
				(I) Templates

	C||		MSDB
			(I) Very important.
			(II) 

	D||		Tempdb
			(I) Temporary work
			(II) -

	E||		Resource
			(I) Cant be seen
			(II) 




	-------------------------------------------------------------------------

	MASTER: Every database get lock into the master system database, its means that control every master system.

	1. Records all the system-level information for an instance of SQL server
	2. Used to store information like server (Instance) Name, Connetcions, SP IDs(sesion process ID), Locations of Other databases.
	

	MODEL
	1. Used to create templates for new databases we create.
	2. Used as template for all databases created on the instance of SQL Server.
	3. All table I create in the following route: AJLR(SQL Server...) -->Databases--> System databases--> Model--> tables--> 
		right botom--> create table.; will appear in any database I create in "system Databases" as "built in"


	MSDB very very important
	1. Used to contain audit reports and history information required for database administrators.
	2. used by SQL Server agent for scheduling alerts and jobs. it is on the left, on the bottom "SQL Server Agent"


	TEMPDB (temporary objects)
	1. Every time you start the system its created.
	2. Used to provide us a temporary space for calculations and also for faster response from SQL server.
	3. Workspace for holding temporary objects or intermediate result sets.

	RESOURCE
	1. this database cnannot be seen in SSMS for security reasons
	2. Resource database is a read-only database that contains system objets. taht are inclueded from SQL  server 2012 and higer versions
	3.System objects are physically persisted in the resource database
	4.Resource databse can be used for sderver repairs and metadata


	DISTRIBUTION
	its all about source and destination
	
	
====================================================================================================
====================================================================================================

								SQL SERVER ARCHITECTER (three categories:)
								------------------------------------------


	A||		Network protocol/external protocols
	B||		Database engine/SQL engine
	C||		SQLOS API



									DATABASE ARCHITECTER
									--------------------


							"Relations between Buffer Vs. Disk":

							
A||		Read-Ahead	Reads/logs
B||		Dirty Pages
C||		Wal(write head log)
D||		Cold pages/Active pages
E||		Lazy writer

 

*/

/*
--												SEVERAL

DBCC  IND 
-----------------------

Worinkg with FILEGROUPS:

A||		Create filegroup

			Alter database FilegroupDB
			Add Filegroup FG1_FilegroupDB


B||		Add a secondary filegroup


C||		Add a file to a filegroup


			Alter database FilegroupDB 
			add file
			(
				Name = File1_FG1_FilegroupDB,
				FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.SECOND_INSTANCE\MSSQL\DATA\File1_FG1_FilegroupDB.ndf'
			) To Filegroup FG1_FilegroupDB


D||		Remove a file	

			Alter database FilegroupDB
			Remove File file3_FG3_FilegroupDB


E||		Remove a filegroup

			Alter database DatabaseName
			Remove filegroup FilegroupName


F||		Rename a physical file

			Alter database FilegroupDB
			Modify File
			(
				Name = File1_FG1_FilegroupDB,
				FileName = 'C:\Users\LT Admin\Desktop\AntonioLopez\File1_FG1_FilegroupDB.ndf'
			)


G||		Rename a logical filename:

			Alter  database FilegroupDB
			Modify file 
			(
				Name = File1_FG1_FilegroupDB,
				NewName = File1_FG1_FilegroupDB_New
			)



*/
GO


'QUESTIONS'

/*
+++Filegroup, What is it the porpouse? it is like having differents folders.

+++		DBCC = Database consistency check // For what is it used?


+++		Console Command?? 

--DBCC  IND ('DatabaseName' or 'Database ID', 'ObjectName' or 'ObjectID', PageType) For what is it used?


=============================================================For what is this command?
Declare @db_id int
Declare @name nvarchar(30)

Select
		@name = name, --as [Database Name],
		@db_id = database_id --as [Database ID]
From sys.databases
Where name = 'AdministrationDB'


Print @db_id
Print @name
=====================================================

+++++++DBCC Traceon(3604)??

===============================================
Declare @db_id int
Declare @name nvarchar(30)

Select
		@name = name, --as [Database Name],
		@db_id = database_id --as [Database ID]
From sys.databases
Where name = 'AdministrationDB'

DBCC Page (@name, 1,256,1)
=================================================




*/


