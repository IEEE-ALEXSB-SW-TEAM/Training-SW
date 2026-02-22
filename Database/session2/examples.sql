-- Select all employees with the first name 'Elvis'
SELECT * FROM employees WHERE first_name = 'Elvis';

-- Retrieve list of female employees with the first name 'Kellie'
SELECT * FROM employees WHERE first_name = 'Kellie' AND gender = 'F';

-- Count the number of annual contracts higher than or equal to $100,00
SELECT COUNT(salary) FROM salaries WHERE salary >= 100000;

-- Find the number of Male (M) and Female (F) employees in the database and order the counts in descending order.
SELECT gender, COUNT(*) AS total_count
FROM employees 
GROUP BY gender
ORDER BY total_count DESC;

-- View titles table
SELECT * FROM titles LIMIT 10;

-- show employee names with their department names
select e.first_name, e.last_name ,d.dept_name from employees e join dept_emp de on e.emp_no = de.emp_no
join departments d on de.dept_no = d.dept_no
limit 10;

-- Insert new employee to employees table
INSERT INTO employees VALUES (999903, '1977-09-14', 'Johnathan', 'Creek', 'M', '1999-01-01');