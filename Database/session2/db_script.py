import mysql.connector
from dotenv import load_dotenv
import os

# load env variables
load_dotenv()

host = os.environ.get("HOST")
user = os.environ.get("DB_USER")
port = os.environ.get("PORT")
password = os.environ.get("PASSWORD")
db = os.environ.get("DB_NAME")

mydb = mysql.connector.connect(
    host=host, user=user, password=password, port=port, database=db
)

print("my database object: ", mydb)

mycursor = mydb.cursor()

mycursor.execute(
    "select e.first_name, e.last_name ,d.dept_name from employees e \
                 join dept_emp de on e.emp_no = de.emp_no \
                 join departments d on de.dept_no = d.dept_no \
                 limit 10;"
)
myresult = mycursor.fetchall()

for x in myresult:
    print(x)

# insert data uncoment them
# sql = "INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)"
# val = (999904, "1977-09-14", "Johnathan", "Creek", "M", "1999-01-01")
# mycursor.execute(sql, val)

# mydb.commit()

# print(mycursor.rowcount, "record inserted.")
