
--=========================================================
Create database DB_Banking

On Primary 
(
	Name = DB_Banking,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DB_Banking.mdf'
),

Filegroup Accounts
(
	Name = AccountsFile,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DB_Banking_AccountsFile.ndf'
),

Filegroup Insurance
(
	Name = InsuranceFile,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DB_Banking_InsuranceFile.ndf'
)

Log On
(
	Name = DB_Banking_log,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DB_Banking_log.ldf'
)

--=========================================================

Select * from sys.databases

--==========================================================

Use DB_Banking

-- tbl_Accounts Table  == Accounts Filegroup
Create table tbl_Accounts
(
	AccID int,
	AccType varchar(20),
	Balance float
) On Accounts


--=======================

-- tbl_Insurance Table  == Insurance Filegroup
Create table tbl_Insurance
(
	InsID int,
	InsType varchar(20),
	Balance float
) On Insurance


--================================

-- Insert: 1
--======
Insert into tbl_Accounts default values
Insert into tbl_Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance

--================================

-- Full Backup: 1
--===========
Backup Database DB_Banking
To Disk = 'C:\Backup\DB_Banking_Full1.bak'
With Compression, Stats

--================================

-- Insert: 2
--======
Insert into tbl_Accounts default values
Insert into tbl_Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance

--======================================


-- Differential Backup: 1
--=================
Backup Database DB_Banking
To Disk = 'C:\Backup\DB_Banking_Diff1.bak'
With Compression, Stats, Differential

--================================


-- Insert: 3
--=======
Insert into tbl_Accounts default values
Insert into tbl_Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance

--======================================


-- Differential Backup: 2
--=================
Backup Database DB_Banking
To Disk = 'C:\Backup\DB_Banking_Diff2.bak'
With Compression, Stats, Differential

--================================


-- Insert: 4
--=======
Insert into tbl_Accounts default values
Insert into tbl_Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance

--======================================


-- Log Backup: 1
--===========
Backup Log DB_Banking
To Disk = 'C:\Backup\DB_Banking_log.trn'
With Compression, Stats

--================================





/*

2 rows

Full backup - 1

2 rows

Differential backup - 1

2 rows

Differential backup - 2

2 rows

Log Backup - 1

*/


--*****************************************************************************


-- Database Crashed:

Use master

Drop database DB_Banking

--========================================

-- Requirement:1 = How to recover entire database ?

-- Requirement:2 = How to recover only ACCOUNTS data from the database ?

--========================================

/*
Requirement:1 = How to recover entire database ?

	Solution:			Using Stand By :

						-- Step:1 = Restore the latest full backup	: Stand By

						-- Step:2 = Restore the latest differential backup  : Stand By

						-- Step:3 = Restore all log backups after above backups  : Recovery
*/

-- Step:1 = Restore the latest full backup	: Stand By
--=======================================
Restore Database DB_Banking
From Disk = 'C:\Backup\DB_Banking_Full1.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'


Use DB_Banking

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance


Use master

-- Step:2 = Restore the latest differential backup  : Stand By
--============================================
Restore Database DB_Banking
From Disk = 'C:\Backup\DB_Banking_Diff2.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'



-- Step:3 = Restore all log backups after above backups  : Recovery
--===============================================
Restore Log DB_Banking
From Disk = 'C:\Backup\DB_Banking_log.trn'
with Recovery




Use DB_Banking

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance



--****************************************************************************


/*
-- Requirement:2 = How to recover only ACCOUNTS data from the database ?

	Solution:					 PARTIAL RESTORES :				Using No Recovery :

				-- Step:1 = Restore Metadata First    /// Primary Filegroup from the Full Backup

				-- Step:2 = Restore Accounts Data	: No Recovery

				-- Step:3 = Restore the latest differential backup  : No Recovery

				-- Step:4 = Restore all log backups after above backups  : Recovery

*/

Use master
Drop database DB_Banking


-- Step:1 = Restore Metadata First    /// Primary Filegroup from the Full Backup  : NoRecovery
--=======================
Restore Database DB_Banking
Filegroup =  'Primary'
From Disk =  'C:\Backup\DB_Banking_Full1.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak', Partial



-- Step:2 = Restore Accounts Data	 from the latest full backup : Stand By
--======================================================
Restore Database DB_Banking
Filegroup = 'Accounts'
From Disk =  'C:\Backup\DB_Banking_Full1.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'




-- Step:3 = Restore the latest differential backup  : Stand By
--============================================
Restore Database DB_Banking
From Disk = 'C:\Backup\DB_Banking_Diff2.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'





-- Step:4 = Restore all log backups after above backups  : Recovery
--===============================================
Restore Log DB_Banking
From Disk = 'C:\Backup\DB_Banking_log.trn'
with Recovery


Use DB_Banking

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance	-- Error
-- Error: The query processor is unable to produce a plan for the table or view 'Insurance' because the table resides in a filegroup that is not online.


Select * from sys.sysfiles

--******************************************************************************


/*
- How to get remaining part of database online ?

Solution : Tail Log Backup  (It is used to convert the state of the database from online to restoring)
-- This is applicable for Online Databases Only.
*/

Use master

-- Step: 1 = Tail Log Backup:
--====================
Backup Log DB_Banking
To Disk = 'C:\backup\DB_Banking_Tail_Log.trn'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'


-- Step: 2 = Restore Insurance Filegroup:
--============================
Restore Database DB_Banking
Filegroup = 'Insurance'
From Disk =  'C:\Backup\DB_Banking_Full1.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'




-- Step:3 = Restore the latest differential backup  : Stand By
--============================================
Restore Database DB_Banking
From Disk = 'C:\Backup\DB_Banking_Diff2.bak'
With StandBy = 'C:\Backups\DB_Banking_StandBy.bak'




-- Step:4 = Restore all log backups after above backups  : Recovery
--===============================================
Restore Log DB_Banking
From Disk = 'C:\Backup\DB_Banking_log.trn'
with StandBy = 'C:\Backups\DB_Banking_StandBy.bak'


Restore 
Log DB_Banking
From  Disk = 'C:\backup\DB_Banking_Tail_Log.trn'
With Recovery









Use DB_Banking

-- Select:
Select COUNT(*) as [Total Rows] from tbl_Accounts
Select COUNT(*) as [Total Rows] from tbl_Insurance	


Select * from sys.sysfiles








































