--**************************************************
--Name: GEORGE TRAKAS
--Student ID: 108459173
--Purpose: DBS301 LAB3
--Date: May 25th 2018
--*************************************************

--Q1--
--Display tommorows date in the following format--
--September 16th, of year 2016--
--Result depends on the day you tun/execute it--
--Solution--

SELECT to_char(sysdate+1,'MonDD"th of year" YYYY')
FROM DUAL;

--Q2--
--display last name,first name salary in departments 20,50 and 60--
--Add a column called "Good salary" that increases salary by %5--
-- Then add a column that multiplies (increased salary minus salary) by 12--
-- Call it "Annual Pay Increase"--
--Solution--

SELECT  last_name AS "Last Name",
        first_name AS "First Name",
        salary AS "Salary",
        (salary * 1.05) AS "Good Salary",
        (((salary * 1.05)-salary) * 12) AS "Annual Pay Increase"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN(20,50,60);

--Q3--
-- Write a query that displays Full Name and Job Title in the following format--
-- DAVIES, CURTIS is ST_CLERK
-- Only employees whose last name end with S and First Names start with C or K--
--Label the Column "Person and Job Title--
--Solution--

SELECT  UPPER(LAST_NAME)  || ', ' || 
       UPPER(FIRST_NAME) ||' is ' || 
       JOB_ID AS "Person And JOB"
FROM EMPLOYEES
WHERE  (UPPER(LAST_NAME) LIKE '%S')
        AND
        (UPPER(FIRST_NAME) LIKE 'C%' OR UPPER(FIRST_NAME) LIKE 'K%');
--Q4--
--Display Last Name hire date and calculate YEARS between TODAY and the day they were hired--
--Label the column Years Worked--
--Order the results by number of years employed. Round to the closest whole number--
--Solution--

SELECT LAST_NAME AS "LAST NAME",
       HIRE_DATE AS "HIRED",
       ROUND(TO_NUMBER(sysdate-hire_date)/ 365) AS "Years Worked"
       FROM EMPLOYEES
       WHERE hire_date<'01-JAN-1992'
       ORDER BY ROUND(TO_NUMBER(sysdate-hire_date)/ 365) DESC;
--Q5--
--Display city name,country codes and state province names--
--only for the cities that start with S and have a character length--
--of at 8 characters--
--If State Province is Null then Label it 'Unknown Province'--
--Solution
       
 SELECT city AS "City",
        COUNTRY_ID As "Country Code",
 (
 CASE
 WHEN
        STATE_PROVINCE IS NULL
 THEN
        STATE_PROVINCE ||'Unknown Province'
 ELSE   
         STATE_PROVINCE
 END) AS "States and Provinces"
 FROM LOCATIONS
 WHERE (UPPER(city) LIKE 'S%' AND LENGTH(city) >=8);
 
 --Q6--
 --Display last name,first name hire date and salary review date.
 -- which is the first Thursday after a year of sercivce but only if they--
 --were hired after 1997
 -- Label the column REVIEW DAY
 --Format the dates to look like
 --THURSDAY,August the Thirty-First of year 1998
 --Sort by review date
 --Solution--
 
 Select last_name AS "Last Name",
        Hire_date AS "Hire Date",
 to_char(next_day(add_months(hire_date,12),'Thursday'),'fmDAY, Month "the" fmDdspth "of year" YYYY') AS "REVIEW DAY"
 FROM EMPLOYEES
 WHERE Hire_date > '31-DEC-97'
 ORDER BY to_char(next_day(add_months(hire_date,12),'Thursday'),'fmDAY, Month "the" fmDdspth "of year" YYYY') DESC;
 
        