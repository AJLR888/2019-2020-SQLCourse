Create database [Merge]		-- Publication Database

go

use [Merge]		-- Publication Database

go

create table Employee		-- Article
(
	ID int primary key,
	Name nvarchar(30),
	Salary int
)
go 

Insert into employee values

(1, 'Sam', 1000),
(2, 'Mike', 2000)

go

Select * from employee


--Merge publication:
/*
The Publisher and Subscribers can update the published data independently after the Subscribers receive an initial snapshot of the published data. Changes are merged periodically. Microsoft SQL Server Compact Edition can only subscribe to merge publications.

*/


/*
All merge articles must contain a uniqueidentifier column with a unique index and the ROWGUIDCOL property. SQL Server adds a uniqueidentifier column to published tables that do not have one when the first snapshot is generated. 

Adding a new column will:
     » Cause INSERT statements without column lists to fail
     » Increase the size of the table
     » Increase the time required to generate the first snapshot 

SQL Server will add a uniqueidentifier column with a unique index and the ROWGUIDCOL property to each of the following tables. 

	[dbo].[Employee]

*/


Insert into employee (ID, Name, Salary) values

(3, 'Kim', 1000),
(4, 'Frank', 2000)

select * from employee


.