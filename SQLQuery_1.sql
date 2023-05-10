SELECT
*
FROM 
Analysis.dbo.Career
GO
--Determining the null values in the table--
SELECT
a.Unique_ID, a.Current_Position_Satisfaction_with_the_following_Upward_Mobility,c.Unique_ID,c.Current_Position_Satisfaction_with_the_following_Upward_Mobility
FROM 
Analysis.dbo.Career a
JOIN
Analysis.dbo.Career c 
   ON a.Unique_ID =c.Unique_ID
   AND a.Career_Switch <> c.Career_Switch
WHERE a.Current_Position_Satisfaction_with_the_following_Upward_Mobility IS NULL

--Updating the null value with similar value in the table
UPDATE 
a
SET
Current_Position_Satisfaction_with_the_following_Upward_Mobility = ISNULL(a.Current_Position_Satisfaction_with_the_following_Upward_Mobility,c.Current_Position_Satisfaction_with_the_following_Upward_Mobility)
FROM 
Analysis.dbo.Career a
JOIN
Analysis.dbo.Career c 
   ON a.Unique_ID =c.Unique_ID
   AND a.Career_Switch <> c.Career_Switch
WHERE a.Current_Position_Satisfaction_with_the_following_Upward_Mobility IS NULL

--seperating the values in current_role in the table
SELECT
SUBSTRING( a.Current_Role,1,CHARINDEX(':', a.Current_Role)) AS Career,
SUBSTRING( a.Current_Role,CHARINDEX(':', a.Current_Role,1),LEN(a.Current_Role)) AS Career_Two
FROM 
Analysis.dbo.Career a
WHERE a.Current_Role = 'Data Analysis'

--adding new table for current career position
ALTER TABLE 
Analysis.dbo.Career
ADD  Average_Salary INT
-- Drop '[ColumnName]' from table '[TableName]' in schema '[dbo]'
ALTER TABLE Analysis.dbo.Career
    DROP COLUMN [Average_Salary]
GO


UPDATE
a
SET
a.Career_Main = SUBSTRING( a.Current_Role,CHARINDEX(':', a.Current_Role,1),LEN(a.Current_Role))
FROM 
Analysis.dbo.Career a

--Updating  Career_Maim Column
UPDATE
a 
SET
a.Updated_Country = 'Nigeria'
FROM
Analysis.dbo.Career a
WHERE a.Updated_Country =  'Africa (Nigeria)'
-- WHERE a.Current_Role IS NOT NULL

SELECT
a.Career_Main, LEN(a.Career_Main) AS Total_Length
FROM
Analysis.dbo.Career a
WHERE a.Career_Main IS NULL
SELECT
--SUBSTRING( a.Career_Main,1,CHARINDEX(':', a.Career_Main)) AS Career,
SUBSTRING( a.Career_Main,CHARINDEX(':', a.Career_Main,3),LEN(a.Career_Main)) AS Career_Two
FROM 
Analysis.dbo.Career a



--Replacing a String character
UPDATE
a
SET a.Career_Main = REPLACE(a.Career_Main,':','')
FROM 
Analysis.dbo.Career a

--Updating by removing a set of word in the cell of a column
UPDATE
a
SET
 a.Career_Main = STUFF(
     a.Career_Main,CHARINDEX('Business Intelligence',a.Career_Main),
     LEN('Business Intelligence'),''
 )
FROM
Analysis.dbo.Career a
WHERE a.Career_Main LIKE '%Business Intelligence%';

--keeping a particular word in each cell of a column and remove the rest of the words in that cel--
UPDATE
a
SET
a.Career_Main = CONCAT(
    SUBSTRING( a.Career_Main,1,
        CHARINDEX('Business Intelligence',a.Career_Main)+ LEN('Business Intelligence') -1),
    SUBSTRING(
        a.Career_Main,
        CHARINDEX('Business Intelligence', a.Career_Main,
        CHARINDEX('Business Intelligence', a.Career_Main)+1
        ) + LEN('Business Intelligence'),
        LEN(a.Career_Main)
    )
    
)
FROM 
Analysis.dbo.Career a
WHERE a.Career_Main LIKE '%Business Intelligence%'

UPDATE
a
SET
a.Career_Main =  LEFT(a.Career_Main, CHARINDEX('Business Intelligence',a.Career_Main)+ LEN('Business Intelligence')-1)
FROM
Analysis.dbo.Career a
WHERE CHARINDEX('Business Intelligence',a.Career_Main)>0 

SELECT
 LEFT(a.Career_Main, CHARINDEX('Business Intelligence',a.Career_Main)+ LEN('Business Intelligence')-1)
FROM
Analysis.dbo.Career a
WHERE CHARINDEX('Business Intelligence',a.Career_Main)>0 
--searching for a key word in the column
SELECT
a.[Working _Industry]
FROM 
Analysis.dbo.Career a
WHERE a.[Working _Industry] LIKE '%Other (Please Specify):%'

UPDATE
a
SET
a.Industry =  REPLACE(a.[Working _Industry],'Other (Please Specify):','')
FROM
Analysis.dbo.Career a

--triming the Ethnicity  to populate the skin color column
SELECT
TRIM( LEFT(a.Q13_Ethnicity, CHARINDEX('or',a.Q13_Ethnicity)-2)), LEN(TRIM( LEFT(a.Q13_Ethnicity, CHARINDEX('or',a.Q13_Ethnicity)-2)))
FROM
Analysis.dbo.Career a
WHERE CHARINDEX('or',a.Q13_Ethnicity)>0 

--populating the skin color column
UPDATE
a
SET
a.Skin_Color =TRIM( LEFT(a.Q13_Ethnicity, CHARINDEX('or',a.Q13_Ethnicity)-2))
FROM
Analysis.dbo.Career a
WHERE CHARINDEX('or',a.Q13_Ethnicity)>0 


SELECT
CASE 
WHEN a.Q13_Ethnicity LIKE '%African%' THEN 'BLack'
WHEN a.Q13_Ethnicity LIKE '%Black%' THEN 'BLack'
WHEN a.Q13_Ethnicity LIKE '%WHite%' THEN 'WHite'
WHEN a.Q13_Ethnicity LIKE '%Latino%' THEN 'Latino'
WHEN a.Q13_Ethnicity LIKE '%Asian%' THEN 'Asian'
WHEN a.Q13_Ethnicity LIKE '%Prefer not to ans%' THEN 'Human'
WHEN a.Q13_Ethnicity LIKE '%Bla%' THEN 'BLack'
WHEN a.Q13_Ethnicity LIKE '%Nigeria%' THEN 'Black'
WHEN a.Q13_Ethnicity LIKE '%Indian%' THEN 'Asian'
WHEN a.Q13_Ethnicity LIKE '%Bi-racial people should be able to check 2 options in 2022. %' THEN 'Human'
 ELSE 'White' END AS Color_Skin,TRIM(a.Q13_Ethnicity) , a.Skin_Color,REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') --TRIM( LEFT(a.Q13_Ethnicity,LEN('Other (Please Specify):')))
FROM 
Analysis.dbo.Career a
WHERE a.Skin_Color IS NULL

--updating null value with the right color skin
UPDATE
a
SET
a.Skin_Color =TRIM(CASE 
WHEN a.Q13_Ethnicity LIKE '%African%' THEN 'BLack'
WHEN a.Q13_Ethnicity LIKE '%Black%' THEN 'BLack'
WHEN a.Q13_Ethnicity LIKE '%WHite%' THEN 'WHite'
WHEN a.Q13_Ethnicity LIKE '%Latino%' THEN 'Latino'
WHEN a.Q13_Ethnicity LIKE '%Asian%' THEN 'Asian'
WHEN a.Q13_Ethnicity LIKE '%Prefer not to ans%' THEN 'Human'
WHEN a.Q13_Ethnicity LIKE '%Bla%' THEN 'BLack'
WHEN a.Q13_Ethnicity LIKE '%Nigeria%' THEN 'Black'
WHEN a.Q13_Ethnicity LIKE '%Indian%' THEN 'Asian'
WHEN a.Q13_Ethnicity LIKE '%Bi-racial people should be able to check 2 options in 2022. %' THEN 'Human'
 ELSE 'White' END)
FROM
Analysis.dbo.Career a
WHERE a.Skin_Color IS NULL

--Data cleaning for Country column
SELECT
TRIM(CASE 
WHEN a.Country LIKE '%Other (Please Specify):%' THEN REPLACE(a.Country,'Other (Please Specify):','')
 ELSE a.Country END )AS Updated_Country, a.Country
FROM 
Analysis.dbo.Career a

--populating the updated_country column with the country column
UPDATE
a
SET
a.Updated_Country = TRIM(CASE 
WHEN a.Country LIKE '%Other (Please Specify):%' THEN REPLACE(a.Country,'Other (Please Specify):','')
 ELSE a.Country END )
FROM
Analysis.dbo.Career a

--Compairing values by joining the same table 
SELECT
-- TRIM(CASE 
-- WHEN c.Q13_Ethnicity LIKE '%African American%' THEN 'United States'

--  ELSE 'United Kingdom' END) AS Join_Column,
a.Updated_Country,a.Q13_Ethnicity, a.Country
FROM
Analysis.dbo.Career a
JOIN
Analysis.dbo.Career c 
   ON a.Unique_ID =c.Unique_ID
WHERE a.Updated_Country = 'Other (Please Specify)'

--updating values 'Other (Please Specify)' in column 'Updated_Country'
UPDATE
a
SET 
a.Updated_Country = TRIM(CASE 
WHEN c.Q13_Ethnicity LIKE '%African American%' THEN 'United States'

 ELSE 'United Kingdom' END)
FROM
Analysis.dbo.Career a
JOIN
Analysis.dbo.Career c 
   ON a.Unique_ID =c.Unique_ID
WHERE a.Updated_Country = 'Other (Please Specify)'

--cleaning and calculating the average salary
SELECT
FORMAT(CASE 
WHEN a.Anunual_Salary LIKE '%41k-65k%' THEN ((65+41)/2)*1000
WHEN a.Anunual_Salary LIKE '%150-225k%' THEN ((225+150)/2)*1000
WHEN a.Anunual_Salary LIKE '%125k-150k%' THEN ((150+125)/2)*1000
WHEN a.Anunual_Salary LIKE '%225k+%' THEN 255*1000
WHEN a.Anunual_Salary LIKE '%106k-125%' THEN ((125+106)/2)*1000
WHEN a.Anunual_Salary LIKE '%66k-85%' THEN ((85+66)/2)*1000
WHEN a.Anunual_Salary LIKE '%86k-105%' THEN ((105+86)/2)*1000

 ELSE  40*1000 END,'C0') AS Average_salary,TRIM(a.Anunual_Salary)  --TRIM( LEFT(a.Q13_Ethnicity,LEN('Other (Please Specify):')))
FROM 
Analysis.dbo.Career a

--Altering the data type of Average_Salary Column
ALTER TABLE Analysis.dbo.Career 
ALTER COLUMN Average_Salary INT

--Populating the values for the 'Average_Salary' Column
UPDATE
a
SET 
a.Average_Salary = 
    CASE 
        WHEN a.Anunual_Salary LIKE '%41k-65k%' THEN ((65+41)/2)*1000
        WHEN a.Anunual_Salary LIKE '%150-225k%' THEN ((225+150)/2)*1000
        WHEN a.Anunual_Salary LIKE '%125k-150k%' THEN ((150+125)/2)*1000
        WHEN a.Anunual_Salary LIKE '%225k+%' THEN 255*1000
        WHEN a.Anunual_Salary LIKE '%106k-125%' THEN ((125+106)/2)*1000
        WHEN a.Anunual_Salary LIKE '%66k-85%' THEN ((85+66)/2)*1000
        WHEN a.Anunual_Salary LIKE '%86k-105%' THEN ((105+86)/2)*1000

 ELSE  40*1000 END

FROM
Analysis.dbo.Career a


--cleaning and age grouping
-- The Silent Generation: Born 1928-1945 (78-95 years old)
-- Baby Boomers: Born 1946-1964 (59-77 years old)
-- Gen X: Born 1965-1980 (43-58 years old)
-- Millennials: Born 1981-1996 (27-42 years old)
-- Gen Z: Born 1997-2012 (11-26 years old)
-- Gen Alpha: Born early 2010s-2025 (0-about 10 years old)
SELECT
CASE 
WHEN a.Age>=78  THEN 'Silent Generation'
WHEN a.Age>=59  THEN 'Baby Boomers'
WHEN a.Age>=43 THEN 'Gen X'
WHEN a.Age>=27  THEN 'Millennials'
WHEN a.Age>=11  THEN 'Gen Z'
 ELSE 'Gen Alpha' END AS Age_Group,TRIM(a.Average_Salary)

FROM 
Analysis.dbo.Career a

--Populating the values for the 'Age_Group' Column
UPDATE
a
SET 
a.Age_Group = TRIM(
CASE 
WHEN a.Age>=78  THEN 'Silent Generation'
WHEN a.Age>=59  THEN 'Baby Boomers'
WHEN a.Age>=43 THEN 'Gen X'
WHEN a.Age>=27  THEN 'Millennials'
WHEN a.Age>=11  THEN 'Gen Z'
 ELSE 'Gen Alpha' END 
)
FROM
Analysis.dbo.Career a

--cleaning and Getting individual culture
SELECT
CASE 
WHEN a.Q13_Ethnicity LIKE '%or%' THEN TRIM( RIGHT(a.Q13_Ethnicity,LEN(a.Q13_Ethnicity)- LEN(TRIM( LEFT(a.Q13_Ethnicity, CHARINDEX('or ',a.Q13_Ethnicity)-2)))-4))
 ELSE a.Q13_Ethnicity END AS Culture--,TRIM(a.Average_Salary) , a.Skin_Color,REPLACE(a.Q13_Ethnicity,'Other (Please Specify):',''), LEN(TRIM( LEFT(a.Q13_Ethnicity, CHARINDEX('or ',a.Q13_Ethnicity)-2))) --TRIM( LEFT(a.Q13_Ethnicity,LEN('Other (Please Specify):')))
FROM 
Analysis.dbo.Career a
WHERE CHARINDEX('or ',a.Q13_Ethnicity)>0 


--Populating the values for the 'Age_Group' Column
UPDATE
a
SET 
a.Culture = TRIM(
CASE 
WHEN a.Q13_Ethnicity LIKE '%or%' THEN TRIM( RIGHT(a.Q13_Ethnicity,LEN(a.Q13_Ethnicity)- LEN(TRIM( LEFT(a.Q13_Ethnicity, CHARINDEX('or ',a.Q13_Ethnicity)-2)))-4))
--WHEN a.Q13_Ethnicity LIKE '%Other (Please Specify):%' THEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','')
 ELSE a.Q13_Ethnicity END
)
FROM
Analysis.dbo.Career a
WHERE CHARINDEX('or ',a.Q13_Ethnicity)>0 





--getting the right value for the null by compairng the colums in the tavble
SELECT
CASE 
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%African%' THEN 'African'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Asian%' THEN 'Asian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%indian%' THEN 'Indian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Caucasian%' THEN 'Caucasian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Half%' THEN 'Asian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%N/A%' THEN 'White American'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Bla%' THEN 'United Kingdom'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Arab%' THEN 'Arabian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','')LIKE '%Nigerian%' THEN 'African'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Bi-racial people should be able to check 2 options in 2022. %' THEN 'Human'
 ELSE 'White' END AS Updated_Culture,
a.Culture, a.Updated_Country, REPLACE(a.Q13_Ethnicity,'Other (Please Specify):',''),c.Skin_Color
FROM
Analysis.dbo.Career a
JOIN
Analysis.dbo.Career c 
   ON  
   a.Unique_ID =c.Unique_ID
   AND a.Skin_Color = c.Skin_Color
WHERE a.Culture IS NULL





--Populating the null values in the 'Culture' Column
UPDATE
a
SET 
a.Culture = TRIM(
CASE 
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%African%' THEN 'African'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Asian%' THEN 'Asian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%indian%' THEN 'Indian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Caucasian%' THEN 'Caucasian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Half%' THEN 'Asian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%N/A%' THEN 'White American'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Bla%' THEN 'United Kingdom'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Arab%' THEN 'Arabian'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','')LIKE '%Nigerian%' THEN 'African'
WHEN REPLACE(a.Q13_Ethnicity,'Other (Please Specify):','') LIKE '%Bi-racial people should be able to check 2 options in 2022. %' THEN 'Human'
 ELSE 'White' END
)
FROM
Analysis.dbo.Career a
WHERE a.Culture IS NULL

--paritione by query
SELECT
Career.Updated_Country, Career.Career_Main, Career.Gender,
COUNT(Career.Gender) OVER (PARTITION BY Career.Gender) AS TotalGender
FROM 
Analysis.dbo.Career AS Career

--knowing the total number of profession by grouping them
SELECT 
Career.Career_Main, COUNT(Career.Career_Main) As totalGoupCareer
FROM 
Analysis.dbo.Career AS Career
GROUP BY Career.Career_Main
HAVING COUNT(Career.Career_Main)>1
ORDER BY Career.Career_Main



 --Data that will be imported to excel and Power Bi
SELECT 
    Career.Unique_ID,
    Career.Gender,
    Career.Education,
    Career.Industry,
    Career.Age_Group,
    Career.Career_Main,
    Career.Skin_Color,
    Career.Updated_Country,
    Career.Average_Salary,
    Career.Culture,
    Career.Career_Switch,
    Career.Dificulty_in_breaking_into_Data
FROM 
Analysis.dbo.Career As Career