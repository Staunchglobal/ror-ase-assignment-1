#imported the csv library to read csv files , extract data and create new csv files
# imported the prawn library that will help us create a pdf and write our content in it with some styling and spacing options..
require 'csv'
require 'prawn'

#created menu that will appear and user can access mutiple options.
def menu
  puts
  puts '-------LMS---------'
  puts 'Welcome to our LMS'
  puts
  puts '---MENU---'
  puts "1- Find student by id"
  puts "2- Find subject and scores by id"
  puts "3- Calculates the percentage of score of all subjects for a student by id"
  puts "4- Calculate the letter grade based on the percentage by id"
  puts "5- Export all students' basic information to a CSV file."
  puts "6- Export all students' subject marks to a CSV file."
  puts "7- Generates a PDF report for a student, including their details by id"
  puts
  puts "Press Option no to access the option."
  puts "Type 'exit' to quit the program" 
end

#defined a function to run that menu in a loop until user enter exit.
def run_menu(lms)
  loop do
    menu #menu wil display once.
    option = gets.chomp #user will select option out of the menu

  #  then defined conditions for each option and called the function of LMS by passing its instance in the function.
    case option
    when "1"
      puts "Enter your id"
      id = gets.chomp.to_i
      student = lms.find_student(id)
      if student
        puts "Student name is #{student.name} and his age is #{student.age}"
      else
        puts "No student with such ID exists."
      end

    when "2"
      puts "Enter your id"
      id = gets.chomp.to_i
      subjects = lms.student_scores(id)
      
      if subjects.nil? # if id is not present or that id does not have subjects
        puts "No subjects found for this ID."
      else
        subjects.each { |subject| puts subject }
      end
    

    when "3"
      puts "Enter your id"
      id = gets.chomp.to_i
      percentage=lms.student_percentage(id)
      if percentage.is_a?(String) # if percentage function return else condition 
        puts percentage
      else
        puts "Percetange of scorees of all subjects for this student is : #{percentage}"
      end
      

    when "4"
      puts "Enter your id"
      id = gets.chomp.to_i
      grade=lms.student_grade(id)
      if grade.length == 1 || grade.length == 2 # because grade is of maximum length 2
      puts "Letter grade based on percetnage of student is : #{grade}"
      else
        puts grade
      end
    
    when "5"
      puts "Downloading CSV FILE of students......."
      lms.export_students
      puts "Downloaded"

    when "6"
      puts "Downloading CSV FILE of SUBJECTS......."
      lms.export_subjects
      puts "Downloaded"

    when "7"
      puts "Enter your id"
      id = gets.chomp.to_i
      lms.export_student_report(id)

    when "exit"
      puts "Leaving the program"
      break

    else
      puts "Invalid entry. Please retry "
    end
  end
end

#defined a class Student that will store relevant details regarding student and add subjects through subject instance.
class Student
 attr_accessor :id, :name, :age, :subjects

  def initialize(id,name,age)
    @id=id
    @name=name
    @age=age
    @subjects=[]
  end

  def add_subject(subject)
    subjects << subject
  end

end

#defined a class subject that will store relevant details regarding subject detailss
class Subject
  attr_accessor :name, :student_id, :score
  def initialize(student_id,name,score)
    @student_id=student_id
    @name=name
    @score=score
  end
end

class LMS
  attr_accessor :students
  def initialize
    @students = {} #initialized student hash
  end

  # in this function we passed the file_path, kept headers true so that we can directly get its data from headers rather than indexes.
  def load_students(file_path)
    CSV.foreach(file_path, headers: true) do |line|

      student_id=line['id'].to_i
      name=line['name']
      age=line['age'].to_i

      @students[student_id] = Student.new(student_id,name,age)
      # stored student data in hash of user by keeping its id as key

    end
  end

  # in this function we passed the file_path, kept headers true so that we can directly get its data from headers rather than indexes.
  # or else we can use FILE to open it and separate by delimeters nd store them.
  def load_subjects(file_path)
    CSV.foreach(file_path, headers: true) do |line|
      student_id=line['student_id'].to_i
      subject_name=line['subject_name']
      score=line['score'].to_i
      if @students[student_id]
      subject=Subject.new(student_id,subject_name,score)
      @students[student_id].add_subject(subject) 
      # we have a method in student class that will add subjects thorugh its instance passed to that fucntion.
      end

    end
  end
#this function checks wheter that astudent exists or not and return its instance to get related data for user.
  def find_student(id)
   @students[id]? @students[id] : nil 
  end

  # this function wil find the subjects and related scores and display to user.
  def student_scores(id)
    student = find_student(id)
    if student && !student.subjects.empty? # this is because if student exists but he has not added any subject.
      student.subjects.map { |subject| "#{subject.name} : #{subject.score}" }
      # Map will return an array that we wil use above to show relevant details
    end
  end
  

  def student_percentage(id)
    student=find_student(id)
    if student && !student.subjects.empty? # here i checked if student with that ID exists and also whether subjects for that student id are empty or not.
      total_sum=0
      student.subjects.each do |subject| 
        total_sum+=subject.score #it will store total sum of  scores
      end
      total_subjects=student.subjects.count
      return total_sum.to_f/total_subjects 
    else
      "This ID does not exist. Cant compute percentage"
    end
  end

  def student_grade(id)
    percentage=student_percentage(id) # we get the percentage of student to give him grade
    if percentage.is_a?(String) #if percentage function return string it will exit here
      puts "Can't calculate grade for an id that does not exist."
      return percentage
    end
    case percentage
    when 90..100
        "A"
    when 80..90
          "B"
    when 70..80
          "C"
    when 60..70
          "D"
    when 50..60
          "D+"
    else
          "F"
    end
  end

  # here I directly used the values of hash initialized above to store data of student into csv file.
  def export_students
    headings=%W[Student_ID Student_name Student_age]
    CSV.open("students_data.csv",'w') do |file|
      file << headings
     @students.each_value do |student|
       content=[student.id,student.name,student.age]
       file << content
     end
    end
  end

  #here I used the values of student hash to get instance of student and store subject details to csv file
  def export_subjects
    headings=%w[Student_ID Subject_name Scores]
    CSV.open("subjects_data.csv",'w') do |file|
      file << headings
     @students.each_value do |student|
       student.subjects.each do |subject|
       content=[subject.student_id, subject.name, subject.score]
       file << content
       end
     end
    end
  end
 
  # I have use dthe prawn library to creat a pdf for user. It's syntax was easy as as comapred to wicked_pdf and PDFKit
  def export_student_report(id)
    student = find_student(id)
    if student && !student.subjects.empty?
      #here i required prawn above to usee it and generated a pdf 
      Prawn::Document.generate("student_report_#{student.name}.pdf") do |pdf|
        pdf.text "Student Report", size: 24, style: :bold # we can customize size and style and color of text
        pdf.move_down 20 # it just gives us space downwards
        pdf.text "Personal Details", size: 16
        pdf.move_down 10
        pdf.text "Student Name : #{student.name}"
        pdf.text "Student ID : #{student.id}"
        pdf.text "Student Age : #{student.age}"
        pdf.move_down 10
        pdf.text "Educational Details", size: 16
        pdf.move_down 10
        pdf.text " Subject : Scores"
  
        student.subjects.each do |subject|
          pdf.text " #{subject.name} : #{subject.score}"
        end
  
        pdf.move_down 10
        percentage = student_percentage(id)
        pdf.text "Percentage : #{percentage}"

        grade = student_grade(id)
         pdf.text "Grade : #{grade}"
        pdf.move_down 10
      end
      puts "PDF Generated Successfully for #{student.name}"
    else
      puts "NO user of such ID exists"
    end
  end
  

end

   
lms=LMS.new
lms.load_students("students.csv")
lms.load_subjects("subjects.csv")
run_menu(lms)



