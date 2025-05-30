
--=========================================================
Create database BankingDB

On Primary 
(
	Name = BankingDB,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\BankingDB.mdf'
),

Filegroup Accounts
(
	Name = AccountsFile,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\BankingDB_AccountsFile.ndf'
),

Filegroup Insurance
(
	Name = InsuranceFile,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\BankingDB_InsuranceFile.ndf'
)

Log On
(
	Name = BankingDB_log,
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\BankingDB_log.ldf'
)

--=========================================================

Select * from sys.databases

--==========================================================

Use BankingDB

-- Accounts Table  == Accounts Filegroup
Create table Accounts
(
	AccID int,
	AccType varchar(20),
	Balance float
) On Accounts


--=======================

-- Insurance Table  == Insurance Filegroup
Create table Insurance
(
	InsID int,
	InsType varchar(20),
	Balance float
) On Insurance


--================================

-- Insert: 1
--======
Insert into Accounts default values
Insert into Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance

--================================

-- Full Backup: 1
--===========
Backup Database BankingDB
To Disk = 'C:\Backup\BankingDB_Full1.bak'
With Compression, Stats

--================================

-- Insert: 2
--======
Insert into Accounts default values
Insert into Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance

--======================================


-- Differential Backup: 1
--=================
Backup Database BankingDB
To Disk = 'C:\Backup\BankingDB_Diff1.bak'
With Compression, Stats, Differential

--================================


-- Insert: 3
--=======
Insert into Accounts default values
Insert into Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance

--======================================


-- Differential Backup: 2
--=================
Backup Database BankingDB
To Disk = 'C:\Backup\BankingDB_Diff2.bak'
With Compression, Stats, Differential

--================================


-- Insert: 4
--=======
Insert into Accounts default values
Insert into Insurance default values

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance

--======================================


-- Log Backup: 1
--===========
Backup Log BankingDB
To Disk = 'C:\Backup\BankingDB_log.trn'
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

Drop database BankingDB

--========================================

-- Requirement:1 = How to recover entire database ?

-- Requirement:2 = How to recover only ACCOUNTS data from the database ?

--========================================

/*
Requirement:1 = How to recover entire database ?

	Solution:			Using No Recovery :

						-- Step:1 = Restore the latest full backup	: No Recovery

						-- Step:2 = Restore the latest differential backup  : No Recovery

						-- Step:3 = Restore all log backups after above backups  : Recovery
*/

-- Step:1 = Restore the latest full backup	: No Recovery
--=======================================
Restore Database BankingDB
From Disk = 'C:\Backup\BankingDB_Full1.bak'
With NoRecovery


-- Step:2 = Restore the latest differential backup  : No Recovery
--============================================
Restore Database BankingDB
From Disk = 'C:\Backup\BankingDB_Diff2.bak'
With NoRecovery


-- Step:3 = Restore all log backups after above backups  : Recovery
--===============================================
Restore Log BankingDB
From Disk = 'C:\Backup\BankingDB_log.trn'
with Recovery


Use BankingDB

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance


--**************************************************************

/*
-- Requirement:2 = How to recover only ACCOUNTS data from the database ?

	Solution:					 PARTIAL RESTORES :				Using No Recovery :

				-- Step:1 = Restore Metadata First    /// Primary Filegroup from the Full Backup

				-- Step:2 = Restore Accounts Data	: No Recovery

				-- Step:3 = Restore the latest differential backup  : No Recovery

				-- Step:4 = Restore all log backups after above backups  : Recovery

*/

Use master
Drop database BankingDB


-- Step:1 = Restore Metadata First    /// Primary Filegroup from the Full Backup  : NoRecovery
--=======================
Restore Database BankingDB
Filegroup =  'Primary'
From Disk =  'C:\Backup\BankingDB_Full1.bak'
With NoRecovery, Partial



-- Step:2 = Restore Accounts Data	 from the latest full backup : No Recovery
--======================================================
Restore Database BankingDB
Filegroup = 'Accounts'
From Disk =  'C:\Backup\BankingDB_Full1.bak'
With NoRecovery


-- Step:3 = Restore the latest differential backup  : No Recovery
--============================================
Restore Database BankingDB
From Disk = 'C:\Backup\BankingDB_Diff2.bak'
With NoRecovery


-- Step:4 = Restore all log backups after above backups  : Recovery
--===============================================
Restore Log BankingDB
From Disk = 'C:\Backup\BankingDB_log.trn'
with Recovery


Use BankingDB

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance	-- Error
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
Backup Log BankingDB
To Disk = 'C:\backup\BankingDB_Tail_Log.trn'
With NoRecovery


-- Step: 2 = Restore Insurance Filegroup:
--============================
Restore Database BankingDB
Filegroup = 'Insurance'
From Disk =  'C:\Backup\BankingDB_Full1.bak'
With NoRecovery


-- Step:3 = Restore the latest differential backup  : No Recovery
--============================================
Restore Database BankingDB
From Disk = 'C:\Backup\BankingDB_Diff2.bak'
With NoRecovery


-- Step:4 = Restore all log backups after above backups  : Recovery
--===============================================
Restore Log BankingDB
From Disk = 'C:\Backup\BankingDB_log.trn'
with NoRecovery


Restore Log BankingDB
From  Disk = 'C:\backup\BankingDB_Tail_Log.trn'
With Recovery


Use BankingDB

-- Select:
Select COUNT(*) as [Total Rows] from Accounts
Select COUNT(*) as [Total Rows] from Insurance	


Select * from sys.sysfiles








