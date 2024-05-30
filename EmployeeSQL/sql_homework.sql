--DROP TABLE IF EXISTS departments;
--DROP TABLE IF EXISTS employees;
--DROP TABLE IF EXISTS dept_employees;
--DROP TABLE IF EXISTS dept_manager;
--DROP TABLE IF EXISTS salaries;
--DROP TABLE IF EXISTS titles;
--DROP TABLE titles CASCADE;
--DROP TABLE employees CASCADE;
--DROP TABLE departments CASCADE;

-- Data engineering 
-- Creating tables

CREATE TABLE departments (
    dept_no character varying(4) PRIMARY KEY NOT NULL,
    dept_name character varying(60) NOT NULL
);

CREATE TABLE titles (
    title_id character varying(10) PRIMARY KEY NOT NULL,
    title character varying(100) NOT NULL
);

CREATE TABLE employees (
    emp_no integer PRIMARY KEY NOT NULL,
    emp_title_id character varying(10)NOT NULL,
    birth_date date NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    sex character varying(1)NOT NULL,
    hire_date date NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE dept_employees (
    emp_no integer NOT NULL,
    dept_no character varying(10) NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_manager (
	dept_no character varying(10) NOT NULL,
    emp_no INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE salaries (
    emp_no integer PRIMARY KEY NOT NULL ,
    salary integer NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- Data Analysis

-- List the employee number, last name, first name, sex, and salary of each employee
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;


-- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '01/01/1986' AND '12/31/1986'
ORDER BY hire_date ASC;

--List the manager of each department along with their department number, department name,
--employee number, last name, and first name
SELECT 
    d.dept_no,
    d.dept_name,
    e.emp_no,
    e.last_name,
    e.first_name
FROM 
    departments d
JOIN 
    dept_manager dm ON d.dept_no = dm.dept_no 
JOIN 
    employees e ON dm.emp_no = e.emp_no;

--List the department number for each employee along with that employee’s employee number, last name,
--first name, and department name
SELECT de.dept_no,
	d.dept_name,
	de.emp_no,
	e.first_name,
	e.last_name
FROM dept_employees de
JOIN departments d ON de.dept_no = d.dept_no
JOIN employees e ON de.emp_no = e.emp_no;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name
--begins with the letter B
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name
SELECT e.emp_no, e.last_name, e.first_name	
FROM dept_employees de
JOIN departments d ON de.dept_no = d.dept_no
JOIN employees e ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales';

--List each employee in the Sales and Development departments, including their employee number, last 
--name, first name, and department name
SELECT e.emp_no, e.last_name, e.first_name	
FROM dept_employees de
JOIN departments d ON de.dept_no = d.dept_no
JOIN employees e ON de.emp_no = e.emp_no
WHERE d.dept_name IN ('Sales', 'Development');

--List the frequency counts, in descending order, of all the employee last names
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;

