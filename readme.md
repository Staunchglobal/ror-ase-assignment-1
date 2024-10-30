
# Simple LMS with File Loading

This goal of this assignment is to make a simple Learning Management System (LMS) in Ruby that loads student and subject data from files and enables access to each student's subjects and scores.

## Features

- Loads student and subject data from files into Ruby objects.
- Provides access to each student's subjects and scores.
- Calculates student percentage and grade.
- Exports data to CSV and generates PDF reports for individual students.

## Files and Data

Create two files to represent students and subjects data: `students.txt` and `subjects.txt`.

### `students.csv`

Each line represents a student in the following format:

```plaintext
student_id,name,age
```

#### Example content:

```plaintext
1,John Doe,20
2,Jane Smith,22
3,Emily White,19
```

### `subjects.csv`

Each line represents a student's subject enrollment in the following format:

```plaintext
student_id,subject_name,score
```

#### Example content:

```plaintext
1,Math,85
1,Science,92
2,Math,78
3,English,88
3,Science,91
```

## Classes

### `Student` Class

- **Attributes**: 
  - `id`
  - `name`
  - `age`
  - `subjects` (an array of `Subject` instances)
  
- **Methods**:
  - `add_subject(subject)`: Adds a `Subject` object to the student's subjects array.

### `Subject` Class

- **Attributes**: 
  - `name`
  - `score`
  - `student_id`

- **Methods**:
  - `initialize(name, student_id ,score)`: Initializes the `Subject` object with a name and score.

### `LMS` Class

- **Attributes**:
  - `students` (a hash with student ID as the key and `Student` object as the value)

- **Methods**:
  - `load_students(file_path)`: Loads student data from `students.txt` and creates `Student` objects.
  - `load_subjects(file_path)`: Loads subjects from `subjects.txt` and adds them to the corresponding `Student` objects.
  - `find_student(id)`: Finds and returns a `Student` object by ID.
  - `student_scores(id)`: Returns a list of subjects and scores for a given student ID.
  - `student_percentage(student_id)`: Calculates the percentage of score of all subjects for a student.
  - `student_grade(student_id)`: Determines the letter grade based on the percentage.
  - `export_students`: Exports all students' basic information to a CSV file.
  - `export_subject_marks`: Exports all students' subject marks to a CSV file.
  - `export_student_report(student_id)`: Generates a PDF report for a student, including their details, subjects, marks, percentage, and grade.

## Usage

1. Load student and subject data from `students.csv` and `subjects.csv`.
2. Use LMS methods to access student data and export reports.

## Submission Instructions

It should be one file name `lms.rb` which should include all the classes, attributes and methods
