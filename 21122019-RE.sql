
--Point in time recovery: How to retreive a table\database at some specific time.

Create database PointIntimeDB

Use PointInTimeDB

Create table Employee
(
ID int,
Name nvarchar(30)
)

go

Insert into Employee values

(1, 'Sam'),
(2, 'Mike')

Select * from Employee

--===============================
--Full backup: 1

Backup database pointintimedb
to disk = 'C:\Backup\PointInTimeDB_Full1.bak'
with stats


Insert into Employee values

(3, 'Kim'),
(4, 'John')


Select * from Employee		--14:58


Delete from Employee		--14:59


Select * from Employee



-- Tail Log backup:
--================

use master 

Backup log PointInTimeDB
to disk = 'C:\Backup\PointInTimeDB_Tail.trn'
with norecovery

--==================================

--Restore full backup: with no recovery

restore database pointintimedb
from disk = 'C:\Backup\PointInTimeDB_Full1.bak'
with norecovery


--Restore full backup: with Recovery
Restore Log PointInTimeDB
From Disk = 'C:\Backup\PointInTimeDB_Tail.trn'
with stopat = '21 December 2019 14:58:59',		--> Point in time recovery
recovery


--------------------------
use PointIntimeDB
-----------------------


Select * from Employee		--15:23


Delete from Employee		--14:24


Select * from Employee


-- If i would do a regular recovery, I would get the table\database\data\file as it was a the last time. for example if at 14:58 there was a table
--but at 15:00 I droped all the information, and, I execute a "regular recovery withount set any specific time" I will get the table, but empty
-- but if I specify I want the data at the time 14:58 I will get all the files as they were at that point.

------------------------------------------------------------------------------------------------------------------------------------














--===========================================================================================================================================



















------------------------------------------------------------------------------------------------------------------------------------











/*

												HOW TO RECOVER A DATABASE TO AT ONE SPECIFIC MOMENT?


1) Create a Tail log backup

2) Restore the last Full backup

3) Restore the log backup specifying the time at which you want to recover the backup.

*/
--===========================================================================================================================================

-- Tail Log backup:
--================

use master 

Backup log PointInTimeDB
to disk = 'C:\Backup\PointInTimeDB_Tail.trn'
with norecovery

--==================================

--Restore full backup: with no recovery

restore database pointintimedb
from disk = 'C:\Backup\PointInTimeDB_Full1.bak'
with norecovery


--Restore full backup: with Recovery
Restore Log PointInTimeDB
From Disk = 'C:\Backup\PointInTimeDB_Tail.trn'
with stopat = '21 December 2019 14:58:59',		--> Point in time recovery
recovery
