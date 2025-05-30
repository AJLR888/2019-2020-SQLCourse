Create database [Peer]		-- Publication Database

go

use [Peer]
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

select * from employee


/*
Peer-to-Peer publication:
Peer-Peer publication enables multi-master replication. The publisher streams transactions to all the peers in the topology. All peer nodes can read and write changes and the changes are propagated to all the nodes in the topology.
*/



Insert into employee values

(3, 'Sam', 1000),
(4, 'Mike', 2000)



.