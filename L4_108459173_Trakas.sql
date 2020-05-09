--*****************************************************
--Name: George Trakas
--ID: 108459173
--Date: May 31st, 2018
--Purpose: LAB 4 DBS301
--*****************************************************

--Q1--
--Display the difference between the Average pay and Lowest
--pay in the company.Format the output to look like currencty
--Solution
--Getting this solution was a nightmare with all the brackets.Hard times
SELECT  to_char(ROUND(AVG(NVL(salary,0))-(MIN(NVL(salary,0))),2),'$999,999.99') 
        AS "Real Amount"
        FROM Employees;

--Q2--
--Display the department number and highest,lowest and Average pay per each department
--Name these results High,Low and Avg. sort output so department with the highest average is displayed first
--Format output to currency where appropriate
--Solution--

SELECT department_id AS "Department Num",
        to_char(MAX(NVL(salary,0)),'$999,999.99') AS "Highest",
        to_char(MIN(NVL(salary,0)),'$999,999.99') AS "Lowest",
        to_char(AVG(NVL(salary,0)),'$999,999.99') AS "Average"
        FROM EMPLOYEES
        GROUP BY department_id
        ORDER BY "Average" DESC;

--Q3--
--Display how many people work the same job in the same department
--Name them Dept#,Job and How Many. Include only jobs that have more than one person
--Sort output so that jobs with the most people involved are shown first
--Solution--
SELECT department_id AS "DEPT#", 
       job_id AS "Job",
COUNT(DISTINCT employee_id) AS "How many"
    FROM Employees
    GROUP BY department_id,job_id
    HAVING COUNT(job_id) > 1
    ORDER BY  COUNT(employee_id) DESC;
    
 --Q4--
 --For each job title display the job title and total amount paid each month
 --for this type of the job. Exclude AD_PRES and AD_VP
 --also include jobs that require more than $12,0000. Sort to top paid jobs
 
 Select job_id AS "Job",
       to_char(SUM(NVL(salary,0)/(12.25)),'$999,999.99') AS "Total Paid"
       FROM EMPLOYEES
       WHERE job_id NOT IN('AD_PRES','AD_VP')
       AND salary > 12000.0
       GROUP BY job_id;
       
 --Q5--
 --For each manager number display how many persons he / she supervises.
 -- Exclude managers with number 100,101,102 and include managers that supervise
 --more than 2 ppl. sort output so that manager numbers with the most supervised
 --ppl show first
 --Solution--
 SELECT manager_id AS "ManagerId",
 COUNT(job_id) AS "Supervised Emp"
 FROM Employees
 WHERE manager_id NOT IN(100,101,102)
 GROUP BY manager_id
 HAVING COUNT(job_id) > 2;
 
 --Q6--
 --For each dept# show the latest and earliest hire date, BUT
 --exclude departments 10 and 20
 --exclude those departments where the last person was hired in this century;
 --Sort the output so that the most recent, meaning latest hire dates, are shown first;
 --Solution--
 
 SELECT department_id AS "Dept#",
 to_char((MIN(hire_date)),'DDth-Mon-YYYY')AS "First Hire",
 to_char((MAX(hire_date)),'DDth-Mon-YYYY')AS "Last Hire"
 FROM employees
 WHERE DEPARTMENT_ID NOT IN (10,20)
 GROUP BY department_id
 Having MAX(hire_date)  < '31-DEC-99'
 ORDER BY 'YYYY' DESC;
 
       