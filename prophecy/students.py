import csv
from cs50 import SQL

db = SQL("sqlite3///roster.db")

with open("students.csv", "r") as file:
    reader = csv.DictReader(file)
    for row in reader:
        id = int(row['id'])
        student = row['student_name']
        house = row['house']
        head = row['head']
        db.execute('INSERT INTO students(id, student_name) VALUE(?,?)', id, student)
        #db.execute('INSERTO INTO houses(house, student_id) VALUE(?,?)')

