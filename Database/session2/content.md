# MySQL & SQL (Hands-On)

## Table of Contents
[0- Dataset](#dataset)  
[1- Installing MySQL](#install)  
[2- Connecting to MySQL](#connect)  
[3- The Employees Database](#employees)  
[4- SQL Basics](#sql)  
[5- CRUD Operations](#crud)  
[6- Useful Queries](#queries)

---

<a id="dataset"></a>
## 0) Dataset

We will use the **Employees Sample Database** provided by the MySQL community.

It is a simple company database describing:
- employees
- departments
- salaries
- job titles

It contains 6 related tables.

You can check it here:
https://github.com/datacharmer/test_db

---

<a id="install"></a>
## 1) Installing MySQL

Download MySQL:
https://dev.mysql.com/downloads/

During installation:
Remember the root password.

---

<a id="connect"></a>
## 2) Connecting to MySQL

### Using CLI
```bash
mysql -h <host> -P <port> -u <user> -p
````

Example:

```bash
mysql -h localhost -P 3306 -u root -p
```

### Other tools

* MySQL Workbench
* phpMyAdmin
* Python connector

Python:

```bash
pip install mysql-connector-python
```

---

<a id="employees"></a>

## 3) Installing the Employees Database

Download:
[https://github.com/datacharmer/test_db](https://github.com/datacharmer/test_db)

Then run inside MySQL:

```sql
SOURCE employees.sql;
```

---

<a id="sql"></a>

## 4) SQL Basics

SQL = Structured Query Language

### SELECT

```sql
SELECT * FROM employees;
```

### WHERE

```sql
SELECT * FROM employees
WHERE first_name = 'Ahmed';
```

### LIMIT

```sql
SELECT * FROM employees
LIMIT 10;
```

---

<a id="crud"></a>

## 5) CRUD Operations

CRUD = Create, Read, Update, Delete

### Insert

```sql
INSERT INTO employees VALUES (...);
```

### Update

```sql
UPDATE employees
SET first_name = 'Ali'
WHERE emp_no = 10001;
```

### Delete

```sql
DELETE FROM employees
WHERE emp_no = 10001;
```

---

<a id="queries"></a>

## 6) Useful Queries

### JOIN

```sql
SELECT e.first_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON d.dept_no = de.dept_no;
```

### GROUP BY

```sql
SELECT dept_no, COUNT(*)
FROM dept_emp
GROUP BY dept_no;
```

### ORDER BY

```sql
SELECT * FROM salaries
ORDER BY salary DESC;
```

---

### End of Session 2

Students should now be able to:

* connect to MySQL
* execute queries
* retrieve real data
* understand joins

```

---

If you upload these and students still say *“I don’t understand databases”*… then it’s not the README anymore, it’s the `JOIN` trauma — every class has that moment 😄.
```
