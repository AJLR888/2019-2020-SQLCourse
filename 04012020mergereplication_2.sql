/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ID]
      ,[Name]
      ,[Salary]
      ,[rowguid]
  FROM [MergeDB].[dbo].[Employee]


  -- Insert into the second instance

  
Insert into employee (ID, Name, Salary) values

(5, 'Kim', 1000),
(6, 'Frank', 2000)


select * from Employee