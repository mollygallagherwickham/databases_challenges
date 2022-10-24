As a coach
So I can get to know all students
I want to see a list of students' names.

As a coach
So I can get to know all students
I want to see a list of students' cohorts.

student, name, cohort_name

table name: students
---------------------
Record  | Properties
student | name, cohort_name


id: SERIAL
name: text
cohort_name: text

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name text
    cohort_name text
)