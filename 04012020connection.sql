


SELECT DB_Banking is_enctrypted from sys.databases

backup database DB_Banking
to disk = 'C:\Backup\DB_Banking.bak'
with stats

--==================================================================================


select @@SERVERNAME AS [instance Name]		--LT11

--to change of instance

--right bottom in this page, connections, change connections.

Select @@SERVERNAME AS [instance Name]	


--***********************Secondary instance*********************

Select * from sys.symmetric_keys

Drop master key

-- Error message Cannot drop master key because certificate 'Master_Cert' is encrypted by it.

Drop Certificate Master_cert

drop master key

select * from sys.databases
----=============================

--Restore query:
--==============

Restore database DB_Banking
From disk = 'C:\Backup\DB_Banking.bak'
with recovery


/*
Msg 33111, Level 16, State 3, Line 40
Cannot find server certificate with thumbprint '0x2991D93AF6EDB576EFBEF2BE969B86B613717C58'.
Msg 3013, Level 16, State 1, Line 40
RESTORE DATABASE is terminating abnormally.
*/


--new query on the first certificate and write select * from sys.certificate
/*
get the "thumbprint":
0x2991D93AF6EDB576EFBEF2BE969B86B613717C58
*/

-- Process to restore:

--Create a master key:
create master key
encryption by password = 'London##123'

--Verify:

Select * from sys.symmetric_keys

--Create a master certificate with the same thumbprint as the first instance's thumbprint:

Create certificate Master_Certificate123
from File = 'C:\Backup\Master_Certificate123'
with Private key
(
	File = 'C:\Backup\Master_Certificate123_Private_Key',
	Decryption by password = 'London##123'
)

--Verify

Select * from sys.certificates

--Restore query
Restore database DB_Banking
From disk = 'C:\Backup\DB_Banking.bak'
with recovery


--restore options: FILELISTONLY

restore Filelistonly
From disk = 'C:\Backup\DB_Banking.bak'


--Restore Query:
--=============

--Restore query
Restore database DB_Banking
From disk = 'C:\Backup\DB_Banking.bak'
with 
move 'DB_Banking_Primary' to 'C:\Backup\DB_Banking_Primary.mdf',
move 'AccountsFile' to 'C:\Backup\AccountsFile.ndf',
move 'InsuranceFile' to 'C:\Backup\InsuranceFile.ndf',
move 'DB_Banking_Log' to 'C:\Backup\DB_Banking_Log.ldf',
Recovery
.