REM DML Retrieval operations
REM*************************

REM ********************************************************************
REM SSN COLLEGE OF ENGINEERING (An Autonomous Institution)
REM DEPARTMENT OF INFORMATION TECHNOLOGY
REM ********************************************************************
REM UIT2311 - DATABASE TECHNOLOGY LAB | III SEMESTER
REM ASSIGNMENT-2: DML FUNDAMENTALS
REM ********************************************************************
REM Note: Do not MODIFY/UPDATE the contents in this file. Use as it is.

REM Create the EMPLOYEES table to hold the employee personnel 
REM information for the company.
REM HR.EMPLOYEES has a self referencing foreign key to this table.

Prompt ******  Dropping EMPLOYEES table ....

DROP TABLE employees CASCADE CONSTRAINTS;

Prompt ******  Creating EMPLOYEES table ....

CREATE TABLE employees
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
	CONSTRAINT     emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

ALTER TABLE employees
ADD ( CONSTRAINT     emp_emp_id_pk
                     PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_manager_fk
                     FOREIGN KEY (manager_id)
                      REFERENCES employees
    ) ;

REM ***************************insert data into the EMPLOYEES table

Prompt ******  Populating EMPLOYEES table ....

INSERT INTO employees VALUES 
        ( 100
        , 'Steven'
        , 'King'
        , 'SKING'
        , '515.123.4567'
        , TO_DATE('17-JUN-1987', 'dd-MON-yyyy')
        , 'AD_PRES'
        , 24000
        , NULL
        , NULL
        , 90
        );

INSERT INTO employees VALUES 
        ( 101
        , 'Neena'
        , 'Kochhar'
        , 'NKOCHHAR'
        , '515.123.4568'
        , TO_DATE('21-SEP-1989', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees VALUES 
        ( 102
        , 'Lex'
        , 'De Haan'
        , 'LDEHAAN'
        , '515.123.4569'
        , TO_DATE('13-JAN-1993', 'dd-MON-yyyy')
        , 'AD_VP'
        , 17000
        , NULL
        , 100
        , 90
        );

INSERT INTO employees VALUES 
        ( 103
        , 'Alexander'
        , 'Hunold'
        , 'AHUNOLD'
        , '590.423.4567'
        , TO_DATE('03-JAN-1990', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 9000
        , NULL
        , 102
        , 60
        );

INSERT INTO employees VALUES 
        ( 104
        , 'Bruce'
        , 'Ernst'
        , 'BERNST'
        , '590.423.4568'
        , TO_DATE('21-MAY-1991', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 6000
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 105
        , 'David'
        , 'Austin'
        , 'DAUSTIN'
        , '590.423.4569'
        , TO_DATE('25-JUN-1997', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 4800
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 106
        , 'Valli'
        , 'Pataballa'
        , 'VPATABAL'
        , '590.423.4560'
        , TO_DATE('05-FEB-1998', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 4800
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 107
        , 'Diana'
        , 'Lorentz'
        , 'DLORENTZ'
        , '590.423.5567'
        , TO_DATE('07-FEB-1999', 'dd-MON-yyyy')
        , 'IT_PROG'
        , 4200
        , NULL
        , 103
        , 60
        );

INSERT INTO employees VALUES 
        ( 124
        , 'Kevin'
        , 'Mourgos'
        , 'KMOURGOS'
        , '650.123.5234'
        , TO_DATE('16-NOV-1999', 'dd-MON-yyyy')
        , 'ST_MAN'
        , 5800
        , NULL
        , 100
        , 50
        );

INSERT INTO employees VALUES 
        ( 141
        , 'Trenna'
        , 'Rajs'
        , 'TRAJS'
        , '650.121.8009'
        , TO_DATE('17-OCT-1995', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 142
        , 'Curtis'
        , 'Davies'
        , 'CDAVIES'
        , '650.121.2994'
        , TO_DATE('29-JAN-1997', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 3100
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 143
        , 'Randall'
        , 'Matos'
        , 'RMATOS'
        , '650.121.2874'
        , TO_DATE('15-MAR-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2600
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 144
        , 'Peter'
        , 'Vargas'
        , 'PVARGAS'
        , '650.121.2004'
        , TO_DATE('09-JUL-1998', 'dd-MON-yyyy')
        , 'ST_CLERK'
        , 2500
        , NULL
        , 124
        , 50
        );

INSERT INTO employees VALUES 
        ( 149
        , 'Eleni'
        , 'Zlotkey'
        , 'EZLOTKEY'
        , '011.44.1344.429018'
        , TO_DATE('29-JAN-2000', 'dd-MON-yyyy')
        , 'SA_MAN'
        , 10500
        , .2
        , 100
        , 80
        );

INSERT INTO employees VALUES 
        ( 174
        , 'Ellen'
        , 'Abel'
        , 'EABEL'
        , '011.44.1644.429267'
        , TO_DATE('11-MAY-1996', 'dd-MON-yyyy')
        , 'SA_REP'
        , 11000
        , .30
        , 149
        , 80
        );

INSERT INTO employees VALUES 
        ( 176
        , 'Jonathon'
        , 'Taylor'
        , 'JTAYLOR'
        , '011.44.1644.429265'
        , TO_DATE('24-MAR-1998', 'dd-MON-yyyy')
        , 'SA_REP'
        , 8600
        , .20
        , 149
        , 80
        );

INSERT INTO employees VALUES 
        ( 178
        , 'Kimberely'
        , 'Grant'
        , 'KGRANT'
        , '011.44.1644.429263'
        , TO_DATE('24-MAY-1999', 'dd-MON-yyyy')
        , 'SA_REP'
        , 7000
        , .15
        , 149
        , NULL
        );

INSERT INTO employees VALUES 
        ( 200
        , 'Jennifer'
        , 'Whalen'
        , 'JWHALEN'
        , '515.123.4444'
        , TO_DATE('17-SEP-1987', 'dd-MON-yyyy')
        , 'AD_ASST'
        , 4400
        , NULL
        , 101
        , 10
        );

INSERT INTO employees VALUES 
        ( 201
        , 'Michael'
        , 'Hartstein'
        , 'MHARTSTE'
        , '515.123.5555'
        , TO_DATE('17-FEB-1996', 'dd-MON-yyyy')
        , 'MK_MAN'
        , 13000
        , NULL
        , 100
        , 20
        );

INSERT INTO employees VALUES 
        ( 202
        , 'Pat'
        , 'Fay'
        , 'PFAY'
        , '603.123.6666'
        , TO_DATE('17-AUG-1997', 'dd-MON-yyyy')
        , 'MK_REP'
        , 6000
        , NULL
        , 201
        , 20
        );

INSERT INTO employees VALUES 
        ( 205
        , 'Shelley'
        , 'Higgins'
        , 'SHIGGINS'
        , '515.123.8080'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_MGR'
        , 12000
        , NULL
        , 101
        , 110
        );

INSERT INTO employees VALUES 
        ( 206
        , 'William'
        , 'Gietz'
        , 'WGIETZ'
        , '515.123.8181'
        , TO_DATE('07-JUN-1994', 'dd-MON-yyyy')
        , 'AC_ACCOUNT'
        , 8300
        , NULL
        , 205
        , 110
        );

COMMIT;

REM ***************************END OF insert data into the EMPLOYEES table

SELECT * FROM employees;

REM 9. Display first name, job id and salary of all the employees.
REM ----------------------------------------------------------------

SELECT first_name, job_id, salary FROM employees;


REM ----------------------------------------------------------------


REM 10. Display the id, name(first & last), salary and annual salary of 
REM	all the employees. Sort the employees by first name. Label the  
REM	columns as shown below:(EMPLOYEE_ID, FULL NAME, MONTHLY SAL, 
REM	ANNUAL SALARY)
REM ----------------------------------------------------------------

SELECT employee_id EMPLOYEE_ID, first_name||' '||last_name
FULL_NAME, salary MONTHLY_SAL, (12*salary) ANNUAL_SALARY FROM 
employees ORDER BY first_name;


REM ----------------------------------------------------------------


REM 11. List the different jobs in which the employees are working for.
REM ----------------------------------------------------------------

SELECT DISTINCT(job_id) FROM employees;


REM ----------------------------------------------------------------


REM 12. Display the id, first name, job id, salary and commission of 
REM	employees who are earning commissions.
REM ----------------------------------------------------------------

SELECT employee_id, first_name, job_id, salary, commission_pct FROM
employees WHERE commission_pct IS NOT NULL;


REM ----------------------------------------------------------------


REM 13. Display the details (id, first name, job id, salary and  
REM	dept id) of employees who are MANAGERS.
REM ----------------------------------------------------------------

SELECT employee_id, first_name, job_id, salary, department_id FROM
employees WHERE manager_id IS NOT NULL;


REM ----------------------------------------------------------------


REM 14. Display the details of employees other than sales representatives 
REM	(id, first name, hire date, job id, salary and dept id) who are 
REM	hired after '01-May-1999' or whose salary is at least 10000.
REM ----------------------------------------------------------------

SELECT employee_id, first_name, hire_date, job_id, salary, department_id 
FROM employees WHERE (hire_date > '01-May-1999' OR salary >= 10000) AND
job_id <> 'SA_REP';


REM ----------------------------------------------------------------


REM 15. Display the employee details (first name, salary, hire date and
REM	dept id) whose salary falls in the range of 5000 to 15000 and 
REM	his/her name begins with any of characters (A,J,K,S). 
REM	Sort the output by first name.
REM ----------------------------------------------------------------

SELECT first_name, salary, hire_date, department_id from employees 
WHERE (salary >= 5000 AND salary <= 15000) AND (first_name LIKE 'A%' OR 
first_name LIKE 'J%' OR first_name LIKE 'K%' OR first_name 
LIKE 'S%') ORDER BY first_name;


REM ----------------------------------------------------------------


REM 16. Display the experience of employees in no. of years and months 
REM	who were hired after 1998. Label the columns as: 
REM	(EMPLOYEE_ID, FIRST_NAME, HIRE_DATE, EXP-YRS, EXP-MONTHS)
REM ----------------------------------------------------------------


SELECT employee_id EMPLOYEE_ID, first_name FIRST_NAME, 
hire_date HIRE_DATE, EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM hire_date) EXP_YRS,
(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM hire_date))*12 EXP_MONTHS FROM employees 
WHERE hire_date > '31-Dec-1998';


REM ----------------------------------------------------------------


REM 17. Display the total number of departments.
REM ----------------------------------------------------------------

SELECT COUNT(DISTINCT(department_id)) FROM employees;


REM ----------------------------------------------------------------


REM 18. Show the number of employees hired by year-wise. Sort the 
REM	result by year-wise.
REM ----------------------------------------------------------------

SELECT COUNT(employee_id), EXTRACT(YEAR FROM hire_date) from employees 
GROUP BY EXTRACT(YEAR FROM hire_date) ORDER BY 
EXTRACT(YEAR FROM hire_date);


REM ----------------------------------------------------------------


REM 19. Display the minimum, maximum and average salary, number of 
REM	employees for each department. Exclude the employee(s) who 
REM	are not in any department. Include the department(s) with at 
REM	least 2 employees and the average salary is more than 10000. 
REM	Sort the result by minimum salary in descending order.
REM ----------------------------------------------------------------

SELECT MIN(salary), MAX(salary), AVG(salary), COUNT(employee_id) 
from employees GROUP BY department_id HAVING department_id IS NOT NULL
AND COUNT(employee_id) >= 2 AND AVG(salary) > 10000  
ORDER BY MIN(salary) DESC;

REM ----------------------------------------------------------------



