--*****************************************************
--Name: George Trakas
--ID: 108459173
--Date: June 5th,2018
--Purpose: Lab 5 DBS301
--*****************************************************

--Q1--
--Display department Name,City,Street address and postal code 
--for departments sorted by city and department name

--Solution

SELECT D.department_name AS "Dept. Name",
       L.city AS "City",
       L.street_address AS "Address",
       L.postal_code AS "PstCode"
FROM  departments D, locations L
WHERE D.location_id = L.location_id
ORDER BY L.city,D.department_name;

--Q2--
--Display full name of employees as a single field
--with format of Last,First their hire date,salary,
--department name and city but only for departments with
--names starting with an A or S sorted by department name
--employee name

SELECT E.Last_name ||' '|| E.first_name AS "Employee Name",
       E.hire_date AS "Hire Date",
       to_char(NVL(E.salary,0),'$99999.99')AS "Salary",
       D.department_name AS "Dept. Name",
       L.city AS "City"
       FROM (employees E INNER JOIN departments D
        ON E.department_id=D.department_id)
        INNER JOIN locations L
        ON L.location_id=D.location_id
        Where (D.department_name LIKE 'A%' OR D.department_name LIKE 'S%')
        ORDER BY D.department_Name,"Employee Name";


        
--Q3--
--Display full name of manager of each department in States/provinces
--of Ontario,Cali and Washington along with department name,postal code and 
--province name. Sort by city and then by department name
--Solution--

SELECT E.Last_name ||' '|| E.first_name AS "Manager Name",
       D.department_name "Dept. Name",
       L.city AS "City",
       L.postal_code AS "PstCode",
       L.state_province "State/Province"
 FROM (employees E INNER JOIN departments D
        ON E.department_id=D.department_id)
         INNER JOIN Locations L
          ON L.location_id=D.location_id
           WHERE (E.job_id Like '%_MAN' OR E.job_id LIKE '%_PRES')
             AND L.state_province IN ('Ontario','California','Washington')
              ORDER BY city,department_name;

--Q4--
--Display employee's last name and emp number along with their
--manager's last name and manager number. Label columns Employee,Emp#
--Manager and Mgr# respectively
--Solution--
SELECT E.last_name AS "Employee",
       E.employee_id AS "Emp#",
       M.last_name AS "Manager",
       M.employee_id AS "Mgr#"
From employees E LEFT OUTER JOIN employees M
    ON (E.manager_id = M.employee_id) 
      ORDER BY "Mgr#","Emp#";
 --Q5--
 --Dispaly department name,city,street address,postal code and 
 --country name for all Departments.Use the join and USING form of syntax
 --Sort by department name descending
 --Solution--
 
 SELECT D.department_name AS "Dept. Name",
       L.city AS "City",
       L.street_address AS "Address",
       L.postal_code AS "PstCode",
       C.country_name AS "Country"
 FROM departments D LEFT JOIN Locations L
 USING (location_id)
 LEFT JOIN countries C
 USING (country_id)
 ORDER BY D.department_name DESC;

--Q6--
--Solution--
--Display full name of employees,their hire date,
--and salary together with their 
--department name only for departments with
--names starting with an A or S Full name should be in format
--a. First/Last. Use the Join and ON form of syntax
--b. Sort the output by department name and then by last name
--Solution--

SELECT E.first_name ||' '|| E.last_name AS "Employee Name",
       E.hire_date ||' '||
       to_char(NVL(E.salary,0),'$99999.99')||' '|| 
       D.department_name AS "HireDate/ Salary/ Dept.Name"
       FROM (employees E INNER JOIN departments D
        ON E.department_id=D.department_id)
        Where (D.department_name LIKE UPPER('A%') 
        OR D.department_name LIKE UPPER('S%'))
        ORDER BY D.department_Name,"Employee Name";

--Q7--
--Rewrite previous by using Old Join method
--Solution--

SELECT E.first_name ||' '|| E.last_name AS "Employee Name",
       E.hire_date ||' '||
       to_char(NVL(E.salary,0),'$99999.99')||' '|| 
       D.department_name AS "HireDate/ Salary/ Dept.Name"
       FROM employees E,departments D
        WHERE (E.department_id=D.department_id)
        AND (D.department_name LIKE UPPER('A%') 
        OR D.department_name LIKE UPPER('S%'))
        ORDER BY D.department_Name,"Employee Name";
--Q8--
--Display full name of the manager of each department in provinces 
--Ontario,Cali and Washington plus department name,city,postal code
-- and province name. Full shoul in formant as follows:
--a. Last,First. Use the Join and ON form of syntax
--b. Sort the outpout by city and department name
--Solution--

SELECT E.Last_name ||' '|| E.first_name AS "Manager Name",
       D.department_name "Dept. Name",
       L.city AS "City",
       L.postal_code AS "PstCode",
       L.state_province "State/Province"
 FROM (employees E INNER JOIN departments D
        ON E.department_id=D.department_id)
         INNER JOIN Locations L
          ON L.location_id=D.location_id
           WHERE (E.job_id Like '%_MAN' OR E.job_id LIKE '%_PRES')
             AND L.state_province IN ('Ontario','California','Washington')
              ORDER BY city,department_name;
--Q9--
--Rewrite the previous question using standard Join method
--Solution--

SELECT E.Last_name ||' '|| E.first_name AS "Manager Name",
       D.department_name "Dept. Name",
       L.city AS "City",
       L.postal_code AS "PstCode",
       L.state_province "State/Province"
 FROM employees E,departments D,locations L
WHERE L.location_id=D.location_id
 AND  D.department_id=E.department_id
 AND  (E.job_id Like '%_MAN' OR E.job_id LIKE '%_PRES')
 AND L.state_province IN ('Ontario','California','Washington')
              ORDER BY city,department_name;

--Q10--
--Display dept. Name and Highest,Lowest and Average pay per each
--department.Name these results High,Low and Avg
--a. Use JOIN and ON form of the syntax
--b. Sort by departmen with highest average salary shown first
--Solution--

SELECT  D.department_name AS "Department Name",
        to_char(MAX(NVL(E.salary,0)),'$999,999.99') AS "Highest",
        to_char(MIN(NVL(E.salary,0)),'$999,999.99') AS "Lowest",
        to_char(AVG(NVL(E.salary,0)),'$999,999.99') AS "Average"
FROM    (employees E RIGHT JOIN departments D
ON      E.department_id=D.department_id)
GROUP BY D.department_name
ORDER BY "Average" DESC;
       
--Q11--
--Display employee last name and employee number along with manager
--last name and manager number. Label the columns Employee,
--a. Emp#,Manager,and Mgr#,respectively. Include employees who do
--b. NOT have a manager and also employees who do NOT supervise anyone
--(or you could say managers without employees to supervise)
--Solution--

SELECT E.last_name AS "Employee",
       E.employee_id AS "Emp#",
       M.last_name AS "Manager",
       M.employee_id AS "Mgr#"
From employees E RIGHT OUTER JOIN employees M
    ON (E.manager_id = M.employee_id)
      ORDER BY "Mgr#","Emp#";

