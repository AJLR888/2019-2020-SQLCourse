Create database [Transactional]		-- Publication Database

go

use [Transactional]
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



--transactional publication
/*
Transactional publication:
The Publisher streams transactions to the Subscribers after they receive an initial snapshot of the published data.

*/


Insert into employee values

(3, 'Kim', 1000),
(4, 'Frank', 2000)








.