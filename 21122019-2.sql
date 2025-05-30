--SECURITY

/*
Security objects:

- Login
	server level security objectos to establish connection to server.


- Users
	Dataase security objectes to establish connection to database & objects

- Roles
	Used to group multiple login & multiple users for common permissions.

-Schemas
	Used to group dabasbase objects for common permissions.




	1.- how to modify control verify authentication modes?

create a new log, the new log doesnt have access to the databases created for another "users"

instance-->Security-->Login-->right botom on one of the users
----------------------
Servers Roles
------------------
using mapping... and so on review that.
------------------------------
level permissions
---------------------------
go to a db in particular and click on security and click on users to allow/asign the level of security.
-------------------------

difference between roles and users.

-----------------------------
securables------search-----all objects of type

grant with grant revoke.....
------------------------

permissions for database tables etc are different
--------------------------------------------

SECURITY, roles, database roles, new database role

SELECT database user or role, 
---general----owner----browser


create a group of permissions for a group of users


*/





----------------------------------------------------------------
--Create a schema:

create schema Sales

-- verify
 Select * from sys.schemas


 -- Table name has to be in 2-part format:

 Create table Sales.employee 
  (
	ID int,
	Name nvarchar(30),
	Salary int
 )
 go

 Insert into sales.employee values

 (1,'Sam', 1200),
 (2,'Mike', 1200),
 (3,'Kim', 1200)
 
 select * from sales.employee
 
 --==================================================


 select * 
 from [AdventureWorks2014].sys.schemas

 --======================================================
 select * from [AdventureWorks2014].Sales.SalesReason



 -- Copy all rows and columns from an existing table into a new table: 

 Select 
		SalesReasonID,
		Upper(Name) as [Name],
		Lower(ReasonType) as [Reason],
		Convert(nvarchar, ModifiedDate, 103) as [Date]
		into Sales.SalesReason
 From [AdventureWorks2014].sales.SalesReason 
 where SalesReasonID between 1 and 8

 --verify:

 Select * from Sales.SalesReason

 

 Select
		TerritoryID,
		Name,
		CountryRegionCode,
		[Group]
		Into Sales.Salesterritory
 from [AdventureWorks2014].Sales.SalesTerritory

 -------------------



 Select * from sales.Salesterritory

 truncate table sales.salesterritory

 select * from sales.salesterritory


 --Copy date/rows from existing table into another existing table:

Insert into sales.Salesterritory
Select
		Name,
		CountryRegionCode,
		[Group]
from [AdventureWorks2014].Sales.SalesTerritory
where CountryRegionCode = 'US'

Select * from sales.Salesterritory


