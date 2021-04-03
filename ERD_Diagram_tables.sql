-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
--Create departments table and import csv file.

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

--Create employees table and import csv file.
CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

--Create dept_emp table and import csv file.
CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

--Create dept_managers table and import csv file.
CREATE TABLE "dept_managers" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

--Create salaries table and import csv file.
CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" BIGINT   NOT NULL
);

----Create titles table and import csv file.
CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_managers" ADD CONSTRAINT "fk_dept_managers_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_managers" ADD CONSTRAINT "fk_dept_managers_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_title_id" FOREIGN KEY("title_id")
REFERENCES "employees" ("emp_no");

--1. List the following details of each employee: employee number, last name, first name, gender, and salary.

SELECT employees.emp_no, 
employees.last_name,
employees.first_name,
employees.sex,
salaries.salary
FROM employees
LEFT JOIN salaries
ON employees.emp_no = salaries.emp_no
ORDER BY emp_no

--2. List employees who were hired in 1986.

SELECT * FROM employees
WHERE DATE_PART('year',hire_date) = 1986
ORDER BY emp_no;

--3. List the manager of each department with the following information: 
--department number, department name, the manager's employee number, 
--last name, first name.

SELECT dept_managers.dept_no, 
departments.dept_name,
dept_managers.emp_no,
employees.last_name, 
employees.first_name
FROM dept_managers
LEFT JOIN departments
ON dept_managers.dept_no = departments.dept_no
LEFT JOIN employees 
ON dept_managers.emp_no = employees.emp_no
ORDER BY emp_no

--4. List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

SELECT
employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_name
FROM employees 
INNER JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments ON departments.dept_no=dept_emp.dept_no
order by emp_no;

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."

SELECT * FROM employees
WHERE first_name = 'Hercules' AND last_name like 'B%';

-- 6. List all employees in the Sales department, including their
-- employee number, last name, first name, and department name.

SELECT 
employees.emp_no, 
employees.last_name, 
employees.first_name,
departments.dept_name
FROM employees 
LEFT JOIN dept_emp 
ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales';

-- 7. List all employees in the Sales and Development departments, including their 
--employee number, last name, first name, and department name.

SELECT 
employees.emp_no, 
employees.last_name, 
employees.first_name,
departments.dept_name
FROM employees 
LEFT JOIN dept_emp 
ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments 
ON departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name in ('Sales', 'Development')

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;