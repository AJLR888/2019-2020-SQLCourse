 
 
 ------------------30/11/19-----------------------------------------




/*
Backup: backups are a mechanism to crate standby copies of the database.

These backups can operate at: 
	-Complete database level
	-Individual filegroupl 
	-Individual filegroup

For data files:
	- Full backup: contains all data from all pages of the entire database.
	- Differencial backup: contains data from such pages which are modified after full backup.

For log files:
	- Regular log backup: contains all data from all log pages from all log files whenever th database log fileis backed up. Then one trn file is created store the backup contents.
	then checkpoint is aout issuse.

	- Tail log back up: convert

Full backpu is also called as "base backup". 
#

										BACKUP OPTIONS:

Compression: for any th backpus, we can use an option "compression".

Formats: to overwrite the bakcup file contents, if any.

Noformat: To append the new backup contents to existing backup file (default)

Differential: 

Copy Only:

Mirrored backup:

Split backup:

Partial backup:

Retain days:

Skip:

Init:

Checksum:

Continue on error:




//////full backup log log log(every hour) differential (every night), I have to restore firstly the full then the full backup then the differential //////

backups---right botom over desktop-S3E....- properties---database settings---backup---C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup-






*/

Select
*
from fn_dblog(null,null)

go

/*
BACKUPS
========

Syntax:
=====

Backup Database [Database or Log] [DatabaseName]
to disk = [Location]
With [backup options]

*/


--Compression: For faster and smaller backups. this option demands more memory and CPU resources. hence, it is advisable to perform backups with compression during off peak hours.


-- Full backup of Master Database:
--======================

Backup Database Master
to Disk = 'MasterDB_Full.bak'
With Compression

--===================================================
Create database EmployeesDB
On primary 
(
	Name = EmployeesDB,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\EmployeesDB.mdf'
),

Filegroup FG1_EmployeesDB
(
	Name = File1_FG1_EmployeesDB,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\File1_FG1_EmployeesDB.ndf'
),

Filegroup FG2_EmployeesDB
(
	Name = File1_FG2_EmployeesDB,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\File1_FG2_EmployeesDB.ndf'
)

Log on 
(
	Name = EmployeesDB_log,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\EmployeesDB_log.ldf'
)

--================================================================
go

Use EmployeesDB


create table Employee
(
	Emp_ID int,
	Emp_Name nvarchar (30)
)
Go
--Insert1
--=====

Insert Into Employee values
(1001, 'Sam'),
(1002, 'Mike'),
(1003, 'Kim'),
(1004, 'John'),
(1005, 'Jonny')
go

Select * from employee


--==========================
-- To report the list of all filegroups in the current atabase:
select * from sys.filegroups
--==============================================

--Full Backup: 1
--=============

Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Full1.bak'

Select * from Employee
--=====================================
--Insert2
--=====
Insert Into Employee values
(2001, 'Sam'),
(2002, 'Mike'),
(2003, 'Kim'),
(2004, 'John'),
(2005, 'Jonny')

go

Select * from employee
go
Select count(*) as [Total Rows] from Employee



--Format:  to overwrite the backup file contents, if we have any...

--Full Backup: 2
--=============
Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Full1.bak'
with format, compression


Select * from Employee





--Insert3
--=====
Insert Into Employee values
(3001, 'Sam'),
(3002, 'Mike')
go

Select count(*) as [Total Rows] from Employee




-- Differencial Backup:
--===============
Backup database EmployeesDB
To disk = 'C:\Backup\EmployeesDB_Diff1.bak'
With Differential


/*
-- 5 rows

--  Full backup: 1 ============= contains 5 rows

-- 5 rows

-- Full backup: 2 ============= 10 rows

--2 Rows

-- Full backup: 3 ============= 12 rows

*/


--Insert4
--=====
Insert Into Employee values
(4001, 'Sam'),
(4002, 'Mike'),
(4003, 'Kim')
go




-- Differencial Backup2:
--===============
Backup database EmployeesDB
To disk = 'C:\Backup\EmployeesDB_Diff2.bak'
With Differential

Select count(*) as [Total Rows] from Employee

select * from Employee



--Insert: 5
--=====
Insert Into Employee values
(5001, 'Sam'),
(5002, 'Mike'),
(5003, 'kim')
go

Select count(*) as [Total Rows] from Employee

--===============

/*
What is a Transaction Log Backup?
========================
A transaction log backup is a backup of all the transactions that have occured in the database since the last transaction log akcup /Differential/Full backup was taken.

Note: you need to perform a full bakcup before you can create any T-Log backups.
*/


-- Log backup:
--=========

Backup Log EmployeesDB
To disk = 'C:\backup\EmployeesDB_log.trn'






/*
-- 5 rows

--  Full backup: 1 ============= contains 5 rows

-- 5 rows

-- Full backup: 2 ============= 10 rows

--2 Rows

-- differential backup: 1 ============= 2 rows
-- 3 rows

--Differential backup 2==============5 rows

-- 3 Rows

-- Log backup: 3

*/



--===========================================================

-- Full Filegroup Backup: Primary
--======================
Backup Database EmployeesDB
Filegroup = 'Primary' 
To Disk = 'C:\Backup\EmployeesDB_primary_FG.bak'
With Compression

 
 --Differential Filegroup Backup:
 --=====================
Backup Database EmployeesDB
Filegroup = 'FG1_EmployeesDB'
To disk = 'C:\Backup\EmployeesDB_FG1_EmployeesDB_Diff1.bak'
With Differential, Compression


-- Full file backup: 1
--===========
backup Database EmployeesDB
file = 'File1_FG1_EmployeesDB'
To Disk = 'C:\Backup\EmployeesDB_File1_FG1_EmployeesDB_Full1.bak'
With compression


-- Full file backup: 1
--===========
backup Database EmployeesDB
file = 'File1_FG1_EmployeesDB'
To Disk = 'C:\Backup\EmployeesDB_File1_FG1_EmployeesDB_Full1.bak'
With 
	compression, 
	format, 
	retaindays=30 --File becomes un-usable after 30 days.


-- Differential file backup: 
--===========
backup Database EmployeesDB
file = 'File1_FG1_EmployeesDB'
To Disk = 'C:\Backup\EmployeesDB_File1_FG1_EmployeesDB_Full1.bak'
With 
	compression, 
	format, 
	Differential
--===================================================

--Copy_only = A special type of full backup that cannot be used as a base for differential and log backups. Copy_Only is used fo HA-DR configurations: such as replications, DB mirroring, etc...

Backup Database EmployeesDB
To disk = 'C:\Backup\EmployeesDB_Copy_Only.bak'
With Copy_Only

--==============================================

-- Partial Backups = Backups involving only the Read-Write filegroups. Read-Only filegroups re not included.

--Full Partial Backup:
Backup Database EmployeesDB
Read_Write_Filegroups
To disk = 'C:\Backup\EmployeesDB_Partial.bak'
With compression






--Differential Partial Backup:
Backup Database EmployeesDB
Read_Write_Filegroups
To disk = 'C:\Backup\EmployeesDB_Partial.bak'
With compression, Differential

--=================================================================

--Mirror backups: Backup operation taks place onto multiple physical locations. One mirror to another.
----------------------------------

Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Mirror1.bak' Mirror
To Disk = 'C:\Backups\EmployeesDB_Mirror2.bak'
With Format


--=========================================

--Split Backups: bakcup operation takes place onto multiple physical locations. Onte additional to another. The backup is split into multiple files. Applicable for very large databases.

Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Split1.bak', 
Disk = 'C:\Backups\EmployeesDB_Split2.bak'
With Format

--==================================================================

--**************Backup Audits*********************

--Every backup is auto-audited into MSDB system database,

use msdb

select * from backupset --Contains an entry for each backup we perform on the server.

Select * from backupmediafamily  --Contains an entry for each backup location...

Select * from backupmediaset  -- Contains information about backup options like mirror, Compression, Init, etc...



Select
		Type,
		backup_finish_date,
		* 
from backupset as b
Order by b.backup_finish_date desc

----------------------------------------

/*
Backup Type:
=========

D			=		 Full, Copy_Only, Mirror, and Split backups
I			=		 Differential or Incremental backups
L			=		 Log backups
F			=		 Full Filegroup and File bakcups
G			=		 Differential filegroups and File backups
P			=		 Partial Full Backup (Read_Write_filegroups)
Q			=		 Partial differential backup
*/



-- Req: 1 =  Audit for last full backup: DatabaseName, Type, Location, and Date (BackupFinishDate)

Select * from backupset  --(DB_Name, Type, and Date) 
Select * from backupmediafamily  --(Location or Physical Device Name)
--=================================================================

Select
			B.database_name as [Database Name],
			B.type as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
-----------------------------------------------------------------------



Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id

--========================================

Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
order by B.Backup_finish_date desc
--------------------------------------------------------------------------------------------

Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc


--------------------------------------------------------------------
Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc

----------------------------------------------------------------------

Select
			Top 1
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc

----------------------------------------------------------------------
use EmployeesDB

Select
			Top 1
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			Convert(nvarchar, B.backup_finish_date, 103) as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc



---------------------------------------------------------



Create Procedure usp_backupaudit
@Type char,
@db_name nvarchar(20)
As
Begin	
			Select
			Top 1
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			Convert(nvarchar, B.backup_finish_date, 103) as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = @type and B.database_name = @db_name
order by B.Backup_finish_date desc
End


exec usp_backupaudit 'D',  'EmployeesDB'































































 ----------------------------------------------30/11/19-----------------------------------------




/*

																BACKUPS

A||		Definition:

B|| Operational level:

	(i)		Complete database
	(ii)	Individual filegroup

C|| Data\Log files:
	(i)		Data files
		1.- Full backup
		2.- Differencial backup

	(ii)	Log files
		1.- Regular Log backup
		2.-	Tail Log backup


Note: Full backup is also called Base backup




															BACKUP OPTIONS:


A.		Compression: for any th backpus, we can use an option "compression".

B.		Formats: to overwrite the bakcup file contents, if any.

C.		Noformat: To append the new backup contents to existing backup file (default)

D.		Differential: 

E.		Copy Only:

F.		Mirrored backup:

G.		Split backup:

H.		Partial backup:

I.		Retain days:

J.		Skip:

K.		Init:

L.		Checksum:

M.		Continue on error:




//////full backup log log log(every hour) differential (every night), I have to restore firstly the full then the full backup then the differential //////

backups---right botom over desktop-S3E....- properties---database settings---backup---C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup-






*/

Select
*
from fn_dblog(null,null)

go

/*
BACKUPS
========

Syntax:
=====

Backup Database [Database or Log] [DatabaseName]
to disk = [Location]
With [backup options]

*/


--Compression: For faster and smaller backups. this option demands more memory and CPU resources. hence, it is advisable to perform backups with compression during off peak hours.


-- Full backup of Master Database:
--======================

Backup Database Master
to Disk = 'MasterDB_Full.bak'
With Compression

--===================================================
Create database EmployeesDB
On primary 
(
	Name = EmployeesDB,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\EmployeesDB.mdf'
),

Filegroup FG1_EmployeesDB
(
	Name = File1_FG1_EmployeesDB,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\File1_FG1_EmployeesDB.ndf'
),

Filegroup FG2_EmployeesDB
(
	Name = File1_FG2_EmployeesDB,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\File1_FG2_EmployeesDB.ndf'
)

Log on 
(
	Name = EmployeesDB_log,
	Filename = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\EmployeesDB_log.ldf'
)

--================================================================
go

Use EmployeesDB


create table Employee
(
	Emp_ID int,
	Emp_Name nvarchar (30)
)
Go
--Insert1
--=======

Insert Into Employee values
(1001, 'Sam'),
(1002, 'Mike'),
(1003, 'Kim'),
(1004, 'John'),
(1005, 'Jonny')
go

Select * from employee


--==========================
-- To report the list of all filegroups in the current atabase:
select * from sys.filegroups
--==============================================

--Full Backup: 1
--=============

Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Full1.bak'

Select * from Employee
--=====================================
--Insert2
--=====
Insert Into Employee values
(2001, 'Sam'),
(2002, 'Mike'),
(2003, 'Kim'),
(2004, 'John'),
(2005, 'Jonny')

go

Select * from employee
go
Select count(*) as [Total Rows] from Employee



--Format:  to overwrite the backup file contents, if we have any...

--Full Backup: 2
--=============
Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Full1.bak'
with format, compression


Select * from Employee





--Insert3
--=====
Insert Into Employee values
(3001, 'Sam'),
(3002, 'Mike')
go

Select count(*) as [Total Rows] from Employee




-- Differencial Backup:
--===============
Backup database EmployeesDB
To disk = 'C:\Backup\EmployeesDB_Diff1.bak'
With Differential


/*
-- 5 rows

--  Full backup: 1 ============= contains 5 rows

-- 5 rows

-- Full backup: 2 ============= 10 rows

--2 Rows

-- Full backup: 3 ============= 12 rows

*/


--Insert4
--=====
Insert Into Employee values
(4001, 'Sam'),
(4002, 'Mike'),
(4003, 'Kim')
go




-- Differencial Backup2:
--===============
Backup database EmployeesDB
To disk = 'C:\Backup\EmployeesDB_Diff2.bak'
With Differential

Select count(*) as [Total Rows] from Employee

select * from Employee



--Insert: 5
--=====
Insert Into Employee values
(5001, 'Sam'),
(5002, 'Mike'),
(5003, 'kim')
go

Select count(*) as [Total Rows] from Employee

--===============

/*
What is a Transaction Log Backup?
========================
A transaction log backup is a backup of all the transactions that have occured in the database since the last transaction log akcup /Differential/Full backup was taken.

Note: you need to perform a full bakcup before you can create any T-Log backups.
*/


-- Log backup:
--=========

Backup Log EmployeesDB
To disk = 'C:\backup\EmployeesDB_log.trn'






/*
-- 5 rows

--  Full backup: 1 ============= contains 5 rows

-- 5 rows

-- Full backup: 2 ============= 10 rows

--2 Rows

-- differential backup: 1 ============= 2 rows
-- 3 rows

--Differential backup 2==============5 rows

-- 3 Rows

-- Log backup: 3

*/



--===========================================================

-- Full Filegroup Backup: Primary
--======================
Backup Database EmployeesDB
Filegroup = 'Primary' 
To Disk = 'C:\Backup\EmployeesDB_primary_FG.bak'
With Compression

 
 --Differential Filegroup Backup:
 --=====================
Backup Database EmployeesDB
Filegroup = 'FG1_EmployeesDB'
To disk = 'C:\Backup\EmployeesDB_FG1_EmployeesDB_Diff1.bak'
With Differential, Compression


-- Full file backup: 1
--===========
backup Database EmployeesDB
file = 'File1_FG1_EmployeesDB'
To Disk = 'C:\Backup\EmployeesDB_File1_FG1_EmployeesDB_Full1.bak'
With compression


-- Full file backup: 1
--===========
backup Database EmployeesDB
file = 'File1_FG1_EmployeesDB'
To Disk = 'C:\Backup\EmployeesDB_File1_FG1_EmployeesDB_Full1.bak'
With 
	compression, 
	format, 
	retaindays=30 --File becomes un-usable after 30 days.


-- Differential file backup: 
--===========
backup Database EmployeesDB
file = 'File1_FG1_EmployeesDB'
To Disk = 'C:\Backup\EmployeesDB_File1_FG1_EmployeesDB_Full1.bak'
With 
	compression, 
	format, 
	Differential
--===================================================

--Copy_only = A special type of full backup that cannot be used as a base for differential and log backups. Copy_Only is used fo HA-DR configurations: such as replications, DB mirroring, etc...

Backup Database EmployeesDB
To disk = 'C:\Backup\EmployeesDB_Copy_Only.bak'
With Copy_Only

--==============================================

-- Partial Backups = Backups involving only the Read-Write filegroups. Read-Only filegroups re not included.

--Full Partial Backup:
Backup Database EmployeesDB
Read_Write_Filegroups
To disk = 'C:\Backup\EmployeesDB_Partial.bak'
With compression






--Differential Partial Backup:
Backup Database EmployeesDB
Read_Write_Filegroups
To disk = 'C:\Backup\EmployeesDB_Partial.bak'
With compression, Differential

--=================================================================

--Mirror backups: Backup operation taks place onto multiple physical locations. One mirror to another.
----------------------------------

Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Mirror1.bak' Mirror
To Disk = 'C:\Backups\EmployeesDB_Mirror2.bak'
With Format


--=========================================

--Split Backups: bakcup operation takes place onto multiple physical locations. Onte additional to another. The backup is split into multiple files. Applicable for very large databases.

Backup Database EmployeesDB
To Disk = 'C:\Backup\EmployeesDB_Split1.bak', 
Disk = 'C:\Backups\EmployeesDB_Split2.bak'
With Format

--==================================================================

--**************Backup Audits*********************

--Every backup is auto-audited into MSDB system database,

use msdb

select * from backupset --Contains an entry for each backup we perform on the server.

Select * from backupmediafamily  --Contains an entry for each backup location...

Select * from backupmediaset  -- Contains information about backup options like mirror, Compression, Init, etc...



Select
		Type,
		backup_finish_date,
		* 
from backupset as b
Order by b.backup_finish_date desc

----------------------------------------

/*
Backup Type:
=========

D			=		 Full, Copy_Only, Mirror, and Split backups
I			=		 Differential or Incremental backups
L			=		 Log backups
F			=		 Full Filegroup and File bakcups
G			=		 Differential filegroups and File backups
P			=		 Partial Full Backup (Read_Write_filegroups)
Q			=		 Partial differential backup
*/



-- Req: 1 =  Audit for last full backup: DatabaseName, Type, Location, and Date (BackupFinishDate)

Select * from backupset  --(DB_Name, Type, and Date) 
Select * from backupmediafamily  --(Location or Physical Device Name)
--=================================================================

Select
			B.database_name as [Database Name],
			B.type as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
-----------------------------------------------------------------------



Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id

--========================================

Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
order by B.Backup_finish_date desc
--------------------------------------------------------------------------------------------

Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc


--------------------------------------------------------------------
Select
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc

----------------------------------------------------------------------

Select
			Top 1
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			B.backup_finish_date as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc

----------------------------------------------------------------------
use EmployeesDB

Select
			Top 1
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			Convert(nvarchar, B.backup_finish_date, 103) as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = 'D' and B.database_name = 'EmployeesDB'
order by B.Backup_finish_date desc



---------------------------------------------------------



Create Procedure usp_backupaudit
@Type char,
@db_name nvarchar(20)
As
Begin	
			Select
			Top 1
			B.database_name as [Database Name],
			Case B.type
								when 'D' then 'Full'
								when 'I' then 'Differential'
								when 'L' then 'Log'
							Else 'Some often backup'
			end as [Backup Type],
			M.physical_device_name as [Location],
			Convert(nvarchar, B.backup_finish_date, 103) as [Date]
From backupset as B 
Join backupmediafamily as M
On B.media_set_id = M.media_set_id
Where B.type = @type and B.database_name = @db_name
order by B.Backup_finish_date desc
End


exec usp_backupaudit 'D',  'EmployeesDB'