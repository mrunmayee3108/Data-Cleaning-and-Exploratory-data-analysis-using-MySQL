-- data cleaning 

USE PROJECT;

SELECT * 
FROM DATACLEANING;

CREATE TABLE `DATA`
LIKE DATACLEANING;

INSERT INTO `DATA`
SELECT * 
FROM DATACLEANING;

SELECT *
FROM `DATA`;

-- 1. removing duplicates

CREATE TABLE DATA2 (
  `ID` int DEFAULT NULL,
  `Name` text,
  `Age` bigint DEFAULT NULL,
  `Date_of_Birth` text,
  `Email` text,
  `Salary` double DEFAULT NULL,
  `Join_Date` text,
  `Department` text,
  `Phone` text,
  `Address` text,
  `Gender` text,
  `Marital_Status` text,
  `Notes` text,
  `Random_String` text,
  `Flag` text,
  `Temp_Code` bigint DEFAULT NULL,
  `row_num` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM DATA2;
INSERT INTO DATA2
SELECT *, ROW_NUMBER() OVER(PARTITION BY ID, Name, Age, Date_of_Birth, Email, Salary, Join_Date, Department, Phone, Address, Gender, Marital_Status, Notes, Random_String, Temp_Code, Flag) AS row_num FROM DATA;
SELECT *
FROM DATA2;
SELECT * 
FROM DATA2 
WHERE row_num > 1;
-- NO DUPLICATES!
-- IF DUPLICATES -> 
-- SET SQL_SAFE_UPDATES = 0;
-- DELETE FROM DATA2 WHERE row_num > 1;
ALTER TABLE DATA2 DROP COLUMN Random_String;
ALTER TABLE DATA2 DROP COLUMN FLAG;
ALTER TABLE DATA2
ADD COLUMN AGE_GRP VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;
UPDATE DATA2
SET AGE_GRP = CASE
    WHEN AGE BETWEEN 20 AND 30 THEN '20-30'
    WHEN AGE BETWEEN 31 AND 40 THEN '31-40'
    WHEN AGE BETWEEN 41 AND 50 THEN '41-50'
    WHEN AGE BETWEEN 51 AND 60 THEN '51-60'
    ELSE '60+'
END;
SELECT * 
FROM DATA2;
ALTER TABLE DATA2 DROP COLUMN ROW_NUM;
UPDATE DATA2
SET NOTES = 'Average' 
WHERE NOTES = '' OR NOTES IS NULL;
UPDATE DATA2
SET GENDER = 'Not specified'
WHERE GENDER = '' OR GENDER IS NULL;
UPDATE DATA2 
SET ADDRESS = 'No permanent address' 
WHERE ADDRESS = '' OR ADDRESS IS NULL;
SELECT * FROM DATA2 WHERE ADDRESS LIKE '%permanent%';
UPDATE DATA2
SET PHONE = 'Not available'
WHERE PHONE = '' OR PHONE IS NULL;
SELECT * FROM DATA2 WHERE PHONE LIKE '%available';
SELECT Date_of_Birth, Join_Date FROM DATA2;

-- Update all dates to standard YYYY-MM-DD format 
UPDATE DATA2
SET Date_of_Birth = CASE
    WHEN TRIM(Date_of_Birth) LIKE '__-__-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%d-%m-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__-_-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%d-%m-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_-__-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%d-%m-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_-_-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%d-%m-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '____.__.__' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%Y.%m.%d'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '____/__/__' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%Y/%m/%d'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '____-__-__' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%Y-%m-%d'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__/__/____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__.__.____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__-__-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m-%d-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_/__/____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__/_/____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_/_/____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_.__.____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__._.____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_._.____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_-__-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m-%d-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '__-_-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m-%d-%Y'), '%Y-%m-%d')
    WHEN TRIM(Date_of_Birth) LIKE '_-_-____' THEN DATE_FORMAT(STR_TO_DATE(TRIM(Date_of_Birth), '%m-%d-%Y'), '%Y-%m-%d')
    ELSE TRIM(Date_of_Birth)
END;

UPDATE DATA2
SET Join_Date = CASE
    WHEN Join_Date IS NULL OR TRIM(Join_Date) = '' THEN NULL
    WHEN TRIM(Join_Date) LIKE '__/__/____' AND STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_/__/____' AND STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__/_/____' AND STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_/_/____' AND STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%d/%m/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__-__-____' AND STR_TO_DATE(TRIM(Join_Date), '%m-%d-%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m-%d-%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__-_-____' AND STR_TO_DATE(TRIM(Join_Date), '%m-%d-%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m-%d-%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_-__-____' AND STR_TO_DATE(TRIM(Join_Date), '%d-%m-%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%d-%m-%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_-_-____' AND STR_TO_DATE(TRIM(Join_Date), '%d-%m-%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%d-%m-%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '____.__.__' AND STR_TO_DATE(TRIM(Join_Date), '%Y.%m.%d') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%Y.%m.%d'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '____/__/__' AND STR_TO_DATE(TRIM(Join_Date), '%Y/%m/%d') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%Y/%m/%d'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '____-__-__' AND STR_TO_DATE(TRIM(Join_Date), '%Y-%m-%d') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%Y-%m-%d'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__.__.____' AND STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_.__.____' AND STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__._.____' AND STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_._.____' AND STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m.%d.%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__/__/____' AND STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_/__/____' AND STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '__/_/____' AND STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y'), '%Y-%m-%d')
    WHEN TRIM(Join_Date) LIKE '_/_/____' AND STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y') IS NOT NULL THEN DATE_FORMAT(STR_TO_DATE(TRIM(Join_Date), '%m/%d/%Y'), '%Y-%m-%d')
    ELSE NULL
END;
SELECT *
FROM DATA2
ORDER BY SALARY DESC;
SELECT * 
FROM DATA2
WHERE Date_of_Birth = '' or Date_of_Birth IS NULL;
UPDATE DATA2
SET Date_of_Birth = 'Not mentioned' 
WHERE Date_of_Birth = '' or Date_of_Birth IS NULL;
SELECT * 
FROM DATA2
WHERE Date_of_Birth LIKE '%mentioned';
SELECT * 
FROM DATA2
WHERE Department = '' or Department IS NULL;
-- data cleaning complete !!
SELECT * FROM DATA2;

-- EXPLORATORY DATA ANALYSIS --

DESCRIBE DATA2;  
SELECT COUNT(*) AS total_rows FROM DATA2;  

SELECT DISTINCT NAME, SALARY
FROM DATA2
WHERE SALARY = (SELECT MAX(SALARY) FROM DATA2);

SELECT * FROM DATA2 WHERE NOTES = 'Great employee';

SELECT * FROM DATA2 WHERE SALARY = '' OR SALARY IS NULL; 

SELECT 
MIN(SALARY) AS MIN_SAL,
MAX(SALARY) AS MAX_SAL,
AVG(SALARY) AS AVG_SAL,
STDDEV(SALARY) AS STD_DEV,
COUNT(SALARY) AS COUNT_OF_PEOPLE
FROM DATA2;

SELECT DISTINCT DEPARTMENT
FROM DATA2
WHERE SALARY < 1000000;

SELECT DISTINCT DEPARTMENT
FROM DATA2
WHERE SALARY = (SELECT MAX(SALARY) FROM DATA2);

SELECT DISTINCT DEPARTMENT
FROM DATA2
WHERE SALARY = (SELECT MIN(SALARY) FROM DATA2);

SELECT DEPARTMENT, `NAME`, COUNT(*) 
AS frequency
FROM DATA2
GROUP BY DEPARTMENT, `NAME`
ORDER BY frequency DESC;

-- finding the second highest salary AND THE NAME OF THE PERSON 
SELECT DISTINCT NAME, SALARY AS SECOND_HIGHEST_SALARY
FROM DATA2
WHERE SALARY = (SELECT MAX(SALARY) FROM DATA2 WHERE SALARY < (SELECT MAX(SALARY) FROM DATA2));

-- Fetch all employees whose names contain the letter “a” exactly twice.
SELECT DISTINCT NAME
FROM DATA2
WHERE LENGTH(LOWER(NAME)) - LENGTH(REPLACE(LOWER(NAME), 'a', '')) = 2;

-- PEOPLE EARNING MORE THAN THE AVG SALARY
SELECT DISTINCT NAME 
FROM DATA2
WHERE SALARY > (SELECT AVG(SALARY) FROM DATA2);

-- MOST OF THE PEOPLE ARE OF AGE-> ??
SELECT AGE, COUNT(*) AS FREQ
FROM DATA2
GROUP BY AGE
ORDER BY FREQ DESC
LIMIT 1;

-- Fetch records where the JOIN date is within the last 6 MONTHS from today.
SELECT * 
FROM DATA2
WHERE Join_Date >= CURRENT_DATE - INTERVAL 6 MONTH;

--  how many employees share the same salary.
SELECT SALARY, COUNT(*) AS SAME_SALARY_EMPLOYEES
FROM DATA2
GROUP BY SALARY;

-- Fetch all employees whose salaries fall within the top 10% of their department.
SELECT DISTINCT NAME, SALARY, DEPARTMENT
FROM (
	SELECT DISTINCT NAME, SALARY, DEPARTMENT, NTILE(10) OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS SALARY_RANK
    FROM DATA2
    ) AS RANKED
WHERE SALARY_RANK = 1;

-- SUM OF SALARY DEPT WISE
SELECT DEPARTMENT, SUM(SALARY) AS TOTAL_SALARY
FROM DATA2
GROUP BY DEPARTMENT
ORDER BY SUM(SALARY) DESC;

SELECT MIN(Join_Date) , MAX(Join_Date)
FROM DATA2;

-- YOUNGEST EMPLOYEES
SELECT NAME, YEAR(Date_of_Birth) AS BIRTH_YEAR 
FROM DATA2
ORDER BY BIRTH_YEAR DESC
LIMIT 5;

-- FINDING BIRTH MONTHS OF EMPLOYEES
SELECT NAME, EMAIL, SUBSTRING(Date_of_Birth,6,2) AS BIRTH_MONTH
FROM DATA2
ORDER BY BIRTH_MONTH;

-- TOP 5 HIGHEST PAID EMPLOYEES
SELECT DISTINCT NAME ,DEPARTMENT, Salary FROM DATA2
ORDER BY Salary DESC
LIMIT 5;

-- EMP IN EACH DEPT
SELECT DEPARTMENT, COUNT(*) AS TOTAL_EMP
FROM DATA2
GROUP BY DEPARTMENT
ORDER BY TOTAL_EMP ASC;

-- EMP WITH DUPLICATE NAMES
SELECT NAME, COUNT(*) AS Count
FROM DATA2
GROUP BY NAME
HAVING Count > 1;

-- Rank employees by salary within department
SELECT DISTINCT NAME, DEPARTMENT, SALARY,
RANK() OVER(PARTITION BY DEPARTMENT ORDER BY SALARY DESC) AS SALARY_RANK
FROM DATA2;

-- Birthdays this month
SELECT NAME, DEPARTMENT, Date_of_Birth 
FROM DATA2 
WHERE MONTH(Date_of_Birth) = MONTH(CURDATE());

 -- Upcoming work anniversaries THIS MONTH
SELECT NAME, DEPARTMENT, Join_Date
FROM DATA2
WHERE MONTH(Join_Date) = MONTH(CURDATE());














    
    












