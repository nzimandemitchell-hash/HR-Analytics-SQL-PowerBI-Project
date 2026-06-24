SELECT *
FROM [DATA CLEANING].[dbo].[hr_employees]

----------------------------------------------------------------------------------------------------------------------
--MISSING VALUES

SELECT *
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE Email IS  NULL

SELECT COUNT(*)
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE Email IS NULL

----------------------------------------------------------------------------------------------------------------------
--STANDARDIZE THE NAMES 


SELECT firstName
FROM [DATA CLEANING].[dbo].[hr_employees]


UPDATE [DATA CLEANING].[dbo].[hr_employees]
SET FirstName =
UPPER(LEFT(FirstName,1))
+
LOWER(SUBSTRING(FirstName,2,LEN(FirstName)));


UPDATE [DATA CLEANING].[dbo].[hr_employees]
SET LastName =
UPPER(LEFT(LastName,1))
+
LOWER(SUBSTRING(LastName,2,LEN(LastName)));




----------------------------------------------------------------------------------------------------------------------
--REMOVING EXTRA SPACES


SELECT *
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE FirstName <> LTRIM(RTRIM(FirstName));


UPDATE [DATA CLEANING].[dbo].[hr_employees]
SET FirstName = LTRIM(RTRIM(FirstName));


------------------------------------------------------------------------------------------------------------------------
-- REMOVING DUPLICATES

SELECT EmployeeID, COUNT(*)
FROM [DATA CLEANING].[dbo].[hr_employees]
GROUP BY EmployeeID
HAVING COUNT(*) > 1;


WITH DuplicateCTE AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY EmployeeID
ORDER BY EmployeeID) AS RowNum
FROM [DATA CLEANING].[dbo].[hr_employees]
)

DELETE
FROM DuplicateCTE
WHERE RowNum > 1;


----------------------------------------------------------------------------------------------------------------------------------
-- AGE VALUES

SELECT *
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE Age < 18
OR Age > 65;


SELECT Age
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE Age = -1;

SELECT COUNT(*) AS InvalidAgeCount
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE Age = -1;

UPDATE [DATA CLEANING].[dbo].[hr_employees]
SET Age = 'N/A'
WHERE Age = -1;

------------------------------------------------------------------------------------------------------------------------------------
--SALARY OUTLIERS

SELECT *
FROM [DATA CLEANING].[dbo].[hr_employees]
ORDER BY MonthlySalary DESC;

SELECT *
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE MonthlySalary < 0;


-----------------------------------------------------------------------------------------------------------------------------------
--CONVERTING HIRE DATE TO DATE TYPE

SELECT Hire_Date
FROM [DATA CLEANING].[dbo].[hr_employees]


ALTER TABLE hr_employees
ADD Hire_Date DATE;


UPDATE [DATA CLEANING].[dbo].[hr_employees]
SET Hire_Date = TRY_CONVERT(DATE, Hire_Date, 5);


ALTER TABLE hr_employees
DROP COLUMN HireDate;


-----------------------------------------------------------------------------------------------------------------------------
--CREATING AN EMAIL FOR MISSING RECORDS 


SELECT Email
FROM [DATA CLEANING].[dbo].[hr_employees]


UPDATE [DATA CLEANING].[dbo].[hr_employees]
SET Email =
LOWER(FirstName + '.' + LastName + '@company.com')
WHERE Email IS NULL;

---------------------------------------------------------------------------------------------------------------------------
--BUSINESS RULES

SELECT AGE
FROM [DATA CLEANING].[dbo].[hr_employees]


DELETE
FROM [DATA CLEANING].[dbo].[hr_employees]
WHERE Age < 18;


--------------------------------------------------------------------------------------------------------------------------

