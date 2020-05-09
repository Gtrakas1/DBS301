--***********************************************************
--Name: George Trakas
--ID: 108459173
--Date: June 13th, 2018
--Purpose: Lab 6 DBS 301
--***********************************************************

--Q1
--SET AUTOCOMMIT ON(do this each time you log on) so any updates
--deletes and inserts are automatically committed before you exit
--Solution--
SET AUTOCOMMIT ON;

--Q2--
-- Create an Insert statement to do this. Add youself as the employee 
--with a NULL salary,0.2 commission_pct, in department 90,Manager 100. 
--You started TODAY
--Solution

INSERT INTO employees VALUES (
    108,
    'GEORGE',
    'TRAKAS',
    'GTRAKAS',
    '123.456.7890',
    TO_DATE(SYSDATE),
    'CEO',
    NULL,
    '0.2',
    100,
    90
);

--Oops Names are all caps

UPDATE employees
SET
    first_name = 'George',
    last_name = 'Trakas'
WHERE
    employee_id = 108;

--Q3--
--Create an Update statement to: Change the salary of the employees
--with a last name of Matos and Whalen to be 2500
--Solution--

UPDATE employees
SET
    salary = 2500
WHERE
    ( last_name IN (
        'Matos',
        'Whalen'
    ) );

--Q4--
--Display the last names of all employees who are in the same dept.
--as the employee named Abel
--Solution

SELECT
    last_name AS "Last Name"
FROM
    employees
WHERE
    department_id = (
        SELECT DISTINCT
            department_id
        FROM
            employees
        WHERE
            upper(last_name) LIKE 'ABEL'
    )
ORDER BY
    last_name;
--Q5--
--Display the last name of the lowest paid employees
--Solution

SELECT
    last_name AS "Last Name"
FROM
    employees
WHERE
    salary IN (
        SELECT
            MIN(salary)
        FROM
            employees
    )
ORDER BY
    last_name;
--Q6--
--Dislpay the cities that the lowest paid employee(s) are in
--Solution

SELECT
    upper(city) AS "City"
FROM
    locations
WHERE
    location_id IN (
        SELECT
            location_id
        FROM
            departments
        WHERE
            department_id IN (
                SELECT
                    department_id
                FROM
                    employees
                WHERE
                    salary = (
                        SELECT
                            MIN(salary)
                        FROM
                            employees
                    )
            )
    );

--Q7--
-- Display the last name,department_id. and salary of
-- of the lowest paid employee(s) in each department
--Sort by Department_ID.(HINT: careful with dept 60)
--Solution--

SELECT
    e.last_name AS "Last Name",
    e.department_id AS "department",
    TO_CHAR(e.salary,'$999,999.99') AS "Salary"
FROM
    employees e
WHERE
    salary <= (
        SELECT
            MIN(salary)
        FROM
            employees e2
        WHERE
            e.department_id = e2.department_id
    )
ORDER BY
    department_id;

/*SELECT E.last_name,
       E.department_id,
       E.salary 
       FROM employees E, (
       SELECT department_id,
       MIN(salary)AS "SALARY"
       FROM employees
       GROUP by department_id
       ) EM
       WHERE E.department_id=EM.department_id 
       AND E.salary=EM.salary;*/
--Q8--
--Display the last name of the lowest paid employee(s) in each city
--Solution

SELECT
    e.last_name AS "Last Name"
FROM
    employees e
WHERE
    salary <= (
        SELECT
            MIN(salary)
        FROM
            employees e2
        WHERE
            e.department_id = e2.department_id
            AND e2.department_id IN (
                SELECT
                    department_id
                FROM
                    (
                        SELECT
                            upper(city)
                        FROM
                            locations
                    )
            )
    )
ORDER BY
    department_id;


/*SELECT E.last_name
       FROM employees E, (
       SELECT department_id,
       MIN(salary) AS "SALARY"
       FROM employees
       GROUP by department_id
       ) EM, (
       SELECT department_id,
              location_id
       FROM departments) D,
      (
      SELECT DISTINCT location_id,
              City
       FROM Locations)L
       WHERE E.department_id=EM.department_id 
       AND E.salary=EM.salary
       AND D.department_id=E.department_id
       AND L.location_id=D.location_id;*/
--Q9--
--Display last name and salary for all employees who earn less than the lowest salary in ANY department.  
--Sort the output by top salaries first and then by last name.

SELECT
    last_name AS "Last Name",
    TO_CHAR(salary,'$999,999.99') AS "Salary"
FROM
    employees
WHERE
    salary < (
        SELECT
            MIN(salary)
        FROM
            employees
        WHERE
            department_id = ANY (
                SELECT
                    COUNT(department_id)
                FROM
                    employees
            )
    )
ORDER BY
    salary DESC,
    last_name;
--Q10--
--Display last name,job title and salary for all employees whose salary  
--matches any from the IT Department. DO NOT use Join method.

SELECT
    last_name,
    job_id,
    salary
FROM
    employees
WHERE
    salary = ANY (
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id LIKE ( 'IT_PROG' )
    )
ORDER BY
    job_id;