create schema EMPLOYEE;
select * from employee.data_science_team;
select * from employee.emp_record_table;
select * from employee.proj_table;
/* 2. create  ER Diagram for the given employee database.*/
/*3 Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.*/
select EMP_ID, FIRST_NAME,LAST_NAME,GENDER,DEPT from employee.emp_record_table;
/*4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
less than two, greater than four 	between two and four*/
select  EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING from  employee.emp_record_table where EMP_RATING<2;
select  EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING from  employee.emp_record_table where EMP_RATING>4;
select  EMP_ID,FIRST_NAME,LAST_NAME,GENDER,DEPT,EMP_RATING from  employee.emp_record_table  where EMP_RATING between 2 and 4;
/* 5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.*/
SELECT 
    FIRST_NAME,
    LAST_NAME,
    CONCAT(contactFirstName)
    ' ',
    (contactLastName) AS concat_name
FROM
    employee.emp_record_table 
    where dept ='FINACE';
    /*6.Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).*/
    select * from   employee.emp_record_table where role ='PRESIDENT';
	select * from employee.emp_record_table order by 'PRESIDENT';
    	/*7.Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.*/   
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM
    employee.data_science_team
WHERE
    DEPT = 'FINANCE' 
UNION SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM
    employee.emp_record_table
WHERE
    DEPT = 'FINANCE';
    SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM
    employee.data_science_team
WHERE
    DEPT = 'HEALTHCARE'
UNION SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, DEPT
FROM
    employee.emp_record_table
WHERE
    DEPT = 'HEALTHCARE';
    /*8.Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.*/
   SELECT 
    e.EMP_ID, e.FIRST_NAME, e.LAST_NAME, e.DEPT, e.EMP_RATING,d.MAX_EMP_RATING
FROM
    employee.emp_record_table e
        JOIN
    (SELECT 
        DEPT, MAX(EMP_RATING) AS MAX_EMP_RATING
    FROM
        employee.emp_record_table e
    GROUP BY DEPT)d ON 
    e.DEPT = d.DEPT
ORDER BY e.EMP_ID , e.DEPT;
/*9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.*/
SELECT 
    ROLE,
    MIN(SALARY) AS MIN_SALARY,MAX(SALARY) AS MAX_SALARY
FROM
    employee.emp_record_table
GROUP BY ROLE
ORDER BY ROLE;
/*10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.*/
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EXP
FROM
    employee.emp_record_table
WHERE
    EXP >= 0
ORDER BY EXP;
/* 11.Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.*/
CREATE VIEW HighSalaryEmployees AS
SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    ROLE, 
    SALARY, 
    COUNTRY
FROM 
    employee.emp_record_table
WHERE 
    SALARY > 6000
    order by COUNTRY DESC;
/*12.	Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.*/
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM
    employee.emp_record_table
WHERE
    EXP > (select 10)
ORDER BY EXP DESC;
/*13.Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.*/
select * from   employee.emp_record_table;
DELIMITER &&
CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, EXP
FROM
    employee.emp_record_table
WHERE
    EXP > (select 3);
END &&
DELIMITER ;
call GetExperiencedEmployees();
/*14.	Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.*/
CREATE FUNCTION get_job_profile(EXP INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE job_profile VARCHAR(50);

    IF EXP <= 2 THEN
        SET job_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP <= 5 THEN
        SET job_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP <= 10 THEN
        SET job_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP <= 12 THEN
        SET job_profile = 'LEAD DATA SCIENTIST';
    ELSEIF EXP <= 16 THEN
        SET job_profile = 'MANAGER';
    ELSE
        SET job_profile = 'UNDEFINED'; -- Handle cases beyond 16 years of experience
    END IF;

    RETURN job_profile;
END &&

DELIMITER ;
SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE AS ASSIGNED_ROLE,
    DEPT,
    EXP,
    get_job_profile(EXP) AS EXPECTED_ROLE,
    CASE
        WHEN ROLE = get_job_profile(EXP) THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS PROFILE_MATCH
FROM
    employee.emp_record_table
WHERE
    DEPT = 'FINANCE';




/*15.	Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.*/
CREATE INDEX idx_first_name ON employee.emp_record_table(FIRST_NAME(100));
 SELECT
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    DEPT
FROM
    employee.emp_record_table
WHERE
    FIRST_NAME = 'Eric';
    select * from   employee.emp_record_table;
 /*16.Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).*/
 SELECT 
    EMP_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    SALARY, 
    EMP_RATING, 
    (0.05 * SALARY * EMP_RATING) AS BONUS
FROM 
    employee.emp_record_table;
/*17.	Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.*/
SELECT 
    CONTINENT, COUNTRY, AVG(SALARY) AS avg_salary
FROM
    employee.emp_record_table
GROUP BY CONTINENT , COUNTRY
ORDER BY CONTINENT , COUNTRY;




