--schema for students database
CREATE TABLE students(
    id INTEGER,
    student_name TEXT,
    PRIMARY KEY(id)
);

CREATE TABLE houses(
    house TEXT,
    student_id INTEGER,
    FOREIGN KEY(student_id) REFERENCES students(id)
);

CREATE TABLE assignments(
    head TEXT,
    student_id INTEGER,
    FOREIGN KEY(student_id) REFERENCES students(id)
);

