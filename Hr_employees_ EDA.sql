SELECT *
FROM  [DATA CLEANING].[dbo].[hr_employees]

-------------------------------------------------------------------------------------------------------------------------------
--SALARY RANKING WITHIN EACH DEPARTMENT


WITH SalaryRank AS
( SELECT EmployeeID, FirstName, LastName,Department, MonthlySalary,
        RANK() OVER (  PARTITION BY Department ORDER BY MonthlySalary DESC
        ) AS SalaryRank
    FROM  [DATA CLEANING].[dbo].[hr_employees] )

SELECT *
FROM SalaryRank
ORDER BY Department, SalaryRank;

----------------------------------------------------------------------------------------------------------------------------------
-- Top 3 HIGHEST PAID DEPARTMENT

WITH TopEarners AS
(
    SELECT  FirstName, LastName,Department, MonthlySalary,
        ROW_NUMBER() OVER ( PARTITION BY Department  ORDER BY MonthlySalary DESC  ) AS RowNum
    FROM  [DATA CLEANING].[dbo].[hr_employees] )

SELECT *
FROM TopEarners
WHERE RowNum <= 3;

----------------------------------------------------------------------------------------------------------------------------------
--DIFFERENCE BETWEEN EMPLOYEE SALARY AND DEPARTEMENT AVERAGE


SELECT EmployeeID,FirstName, LastName, Department, MonthlySalary,
    AVG(MonthlySalary) OVER(PARTITION BY Department) AS DepartmentAverage,
    MonthlySalary -
    AVG(MonthlySalary) OVER(PARTITION BY Department) AS DifferenceFromAverage
FROM  [DATA CLEANING].[dbo].[hr_employees]


-----------------------------------------------------------------------------------------------------------------------------------
--EMPLOYEES EARNING ABOVE AVERAGE


WITH AvgSalary AS

(SELECT *, AVG(MonthlySalary) OVER(PARTITION BY Department) AS DeptAvg
    FROM  ) 

SELECT   FirstName, LastName,Department,MonthlySalary,DeptAvg
FROM  [DATA CLEANING].[dbo].[hr_employees]
WHERE MonthlySalary > DeptAvg

-----------------------------------------------------------------------------------------------------------------------------------
--DEPARTMENT WITH THE HIGHEST AVERAGE SALARY

SELECT TOP 1
    Department,
    AVG(MonthlySalary) AS AverageSalary
FROM  [DATA CLEANING].[dbo].[hr_employees]
GROUP BY Department
ORDER BY AverageSalary DESC;


-----------------------------------------------------------------------------------------------------------------------------------
--TOTAL OF SALARIES


SELECT EmployeeID,  FirstName, LastName, MonthlySalary, SUM(MonthlySalary) 
OVER( ORDER BY EmployeeID) AS RunningTotalSalary
FROM  [DATA CLEANING].[dbo].[hr_employees];


-----------------------------------------------------------------------------------------------------------------------------------
--YOUNGEST AND OLDEST BY EACH DEPARTMENT


WITH AgeRanks AS
(
SELECT Department,FirstName, LastName, Age,
    ROW_NUMBER() OVER(  PARTITION BY Department ORDER BY Age ASC ) AS YoungestRank,
    ROW_NUMBER() OVER(  PARTITION BY Department ORDER BY Age DESC   ) AS OldestRank
FROM  [DATA CLEANING].[dbo].[hr_employees])

SELECT *
FROM AgeRanks
WHERE YoungestRank = 1
OR OldestRank = 1;



--------------------------------------------------------------------------------------------------------------------------------------
--AGE GROUP RESTRICTIONS


SELECT
CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END AS AgeGroup,
COUNT(*) AS TotalEmployees
FROM  [DATA CLEANING].[dbo].[hr_employees]
GROUP BY
CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 45 THEN '36-45'
    WHEN Age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END;


--------------------------------------------------------------------------------------------------------------------------------
--- SALARY STATISTICS

SELECT
    MIN(MonthlySalary) AS MinimumSalary,
    MAX(MonthlySalary) AS MaximumSalary,
    AVG(MonthlySalary) AS AverageSalary
FROM   [DATA CLEANING].[dbo].[hr_employees] ;



-----------------------------------------------------------------------------------------------------------------------------
---EMPLOYEEES BY CITY

SELECT
    City,
    COUNT(*) AS NumberOfEmployees
FROM [DATA CLEANING].[dbo].[hr_employees]
GROUP BY City
ORDER BY NumberOfEmployees DESC;


-----------------------------------------------------------------------------------------------------------------------------
--SALARY BANDS

SELECT
CASE
    WHEN MonthlySalary < 20000 THEN 'Low Income'
    WHEN MonthlySalary BETWEEN 20000 AND 40000 THEN 'Middle Income'
    ELSE 'High Income'
END AS SalaryCategory,
COUNT(*) AS Employees
FROM [DATA CLEANING].[dbo].[hr_employees]
GROUP BY
CASE
    WHEN MonthlySalary < 20000 THEN 'Low Income'
    WHEN MonthlySalary BETWEEN 20000 AND 40000 THEN 'Middle Income'
    ELSE 'High Income'
END;


----------------------------------------------------------------------------------------------------------------------------
-- PERCENTAGES OF EMPLOYEES PER STATUS

SELECT
    EmploymentStatus,
    COUNT(*) AS Employees,
    ROUND(
        COUNT(*)*100.0/
        (SELECT COUNT(*) FROM  [DATA CLEANING].[dbo].[hr_employees]),2
    ) AS Percentage
FROM  [DATA CLEANING].[dbo].[hr_employees]
GROUP BY EmploymentStatus;


----------------------------------------------------------------------------------------------------------------------------