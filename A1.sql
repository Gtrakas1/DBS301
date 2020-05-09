--***********************************************************
--Name: George Trakas
--ID: 108459173
--Date: June 15th, 2018
--Purpose: Assignment 1 DBS 301
--***********************************************************


--Q1--


--Solution--
--Display the employee number, full employee name, job and hire date of all employees hired in May or November of any year, 
--with the most recently hired employees displayed first. Also, exclude people hired in 1994 and 1995.Full name should be 
--in the form Lastname,  Firstname  with an alias called Full Name. Hire date should point to the last day in May or November 
--of that year (NOT to the exact day) and be in the form of [May 31<st,nd,rd,th> of 1996] with the heading Start Date. 
--Do NOT use LIKE operator. <st,nd,rd,th> means days that end in a 1, should have st, days that end in a 2 should have nd, 
--days that end in a 3 should have rd and all others should have th. You should display ONE row per output line by limiting 
--the width of the Full Name to 25 characters. The output lines should look like this line:


SELECT employee_id AS "Emp#",
       SUBSTR(last_name ||','|| first_name,1,25)  AS "Full Name" ,
       job_id AS "job title",
       to_char(LAST_DAY(hire_date),'[fmMONTH DDth" of "YYYY]') AS "Hire Date"
FROM   employees
WHERE ('YYYY' NOT IN('1994','1995'))
AND to_char(hire_date, 'MON') IN ('MAY','NOV')
ORDER BY hire_date DESC;



--Q2--
--List the employee number, full name, job and the modified salary for all employees whose monthly earning 
--(without this increase) is outside the range $6,000 and $11,000 
--and who are employed as Vice Presidents or Managers (President is not counted here).  
--You should use Wild Card characters for this. 
--VPs will get 30% and managers 20% salary increase.  
--Sort the output by the top salaries (before this increase) firstly.
--Heading will be like Employees with increased Pay
--The output lines should look like this sample line:

SELECT
'Emp# '||employee_id ||
' named ' ||first_name ||' '|| last_name||
' who is ' ||job_id ||
' will have a new salary of '||
' $'||
CASE 
WHEN job_id Like '%VP'
THEN (salary * 1.3)
WHEN job_id LIKE UPPER('%MAN') OR job_id LIKE UPPER('%MGR')
THEN (salary * 1.2)
END AS "Employees with Increased Pay"
FROM employees
WHERE (salary <= 6000 OR salary >= 11000)
AND (job_ID LIKE '%VP' OR job_id LIKE '%MAN' OR job_id LIKE '%MGR')
ORDER BY salary DESC;

--Q3--
--Display the employee last name, salary, job title and manager# of all employees not earning a commission OR if they work in 
--the SALES department, but only  if their total monthly salary with $1000 included bonus and  commission (if  earned) is  
--greater  than  $15,000.  Lets assume that all employees receive this bonus.
--If an employee does not have a manager, then display the word NONE 
--instead. This column should have an alias Manager#.
--Display the Total annual salary as well in the form of $135,600.00 with the 
--heading Total Income. Sort the result so that best paid employees are shown first.

SELECT last_name AS "Last Name",
       to_char(salary,'$999,999.00') AS "Salary",
       job_id AS "Job Title",
       NVL(to_char(manager_id),'None') AS "Manager#",
       ((salary + 1000) * 12) AS "Total Amount"
FROM employees
WHERE NVL(commission_pct,0)=0
AND job_id NOT IN ('SA_REP')
AND ((salary)+1000 +(salary * NVL(commission_pct,0))) > 15000;


--Q4--
-- Display Department_id, Job_id and the Lowest salary for this combination under the alias Lowest Dept/Job Pay, 
-- but only if that Lowest Pay falls in the range $6000 - $18000.
--Exclude people who work as some kind of Representative job from this query and departments IT and SALES as well.
--Sort the output according to the Department_id and then by Job_id.
--You MUST NOT use the Subquery method.
Select LPAD(department_id,3,' ')  ||' ' ||
       SUBSTR(job_id,1,12)||
       ' '||TRIM(to_char(MIN(salary),'$999,999.99'))AS "Lowest Dept/Job Pay"
FROM employees
WHERE job_id NOT LIKE UPPER('%REP%') AND job_id NOT LIKE UPPER('%IT%') AND job_id NOT LIKE UPPER('%SA%') 
GROUP BY department_id,job_id
HAVING MIN(salary)>=6000 and MIN(salary) <=18000
ORDER BY department_id,job_id;

--Q5--
--Display last_name, salary and job for all employees who earn more than all lowest paid employees per department 
--outside the US locations.Exclude President and Vice Presidents from this query.
--Sort the output by job title ascending.
--You need to use a Subquery and Joining with the NEW (Oracle9i) method.
Select last_name AS "Last Name",
       salary AS "Salary",
       job_id AS "Job Title"
From employees 
WHERE salary > ALL(
Select MIN(salary)       
FROM employees 
JOIN departments USING (department_id)
JOIN locations USING (location_id)
WHERE country_id NOT LIKE UPPER('US')
GROUP BY department_id
)
AND department_id NOT IN ('90')--(UPPER(job_id) NOT LIKE ('%PRES') AND UPPER(job_id) NOT LIKE2('%VP'))
ORDER BY job_id;

--Q6--
--Who are the employees (show last_name, salary and job) who work either in IT or MARKETING department 
--and earn more than the worst paid person in the ACCOUNTING department. 
--Sort the output by the last name alphabetically.
--You need to use ONLY the Subquery method (NO joins allowed).
--Solution--

SELECT
last_name,
salary,
job_id
FROM employees
WHERE salary >(
    SELECT MIN(salary)
    FROM employees
    WHERE department_id =(
        SELECT department_id
        FROM departments
        WHERE UPPER(department_name) IN ('ACCOUNTING')))
AND department_id IN(
    SELECT department_id
    From departments
    WHERE UPPER(department_name) IN ('IT','MARKETING'))
ORDER BY last_name;

--Q7--
--Display alphabetically the full name, job, salary (formatted as a currency amount incl. thousand separator, but no decimals) 
--and department number for each employee who earns less than the best paid unionized employee (i.e. not the president nor any 
--manager nor any VP), and who work in either SALES or MARKETING department.Full name should be displayed as Firstname  
--Lastname and should have the heading Employee. Salary should be left-padded with the = symbol till the width of 12 characters. 
--It should have an alias Salary.
--You should display ONE row per output line by limiting the width of the 	Employee to 25 characters.
--The output lines should look like this sample line:

SELECT SUBSTR(first_name ||' '||last_name,1,25) AS "Employee",
       job_id AS "Job Title",
       LPAD('=',12,'=') AS "Padding",
       to_char(salary,'$999,999') AS "Salary",
       department_id AS "DEPT#"
FROM employees
WHERE salary <(
SELECT  MAX(salary)
From employees
WHERE department_id NOT IN ('90'))
AND department_id IN (
SELECT department_id
FROM departments
WHERE UPPER(department_name) IN('MARKETING','SALES'))
AND UPPER(job_id) NOT LIKE ('%MAN');

--Q8--
--Tricky One
--Display department name, city and number of different jobs in each department. 
--If city is null, you should print Not Assigned Yet.
--This column should have alias City.
--Column that shows # of different jobs in a department should have the heading # of Jobs
--You should display ONE row per output line by limiting the width of the City to 25 characters.
--You need to show complete situation from the EMPLOYEE point of view, meaning include also employees who work for NO department 
--(but do NOT display empty departments) and from the CITY point of view 
--meaning you need to display all cities without departments as well.
--You need to use Outer Joining with the NEW (Oracle9i) method.

Select  NVL(department_name,' ') AS "Department Name",
       SUBSTR(NVL(CITY,'Not Yet,Assigned'),1,25) AS "City",
       COUNT(job_id) AS "# of Jobs"
       FROM departments d LEFT OUTER JOIN employees e
       ON d.department_id=e.department_id
       FULL OUTER JOIN locations l 
       ON d.location_id=l.location_id
       GROUP BY d.department_name,SUBSTR(NVL(CITY,'Not Yet,Assigned'),1,25);
