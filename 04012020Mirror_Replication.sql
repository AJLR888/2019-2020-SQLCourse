Create database [DB_Mirroring]		-- Publication Database

go

use [DB_Mirroring]
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
