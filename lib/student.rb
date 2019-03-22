class Student
  attr_accessor :id, :name, :grade

  # def initialize(id, name, grade)
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    all_students = DB[:conn].execute("SELECT * FROM students;") #an array of arrays
    all_students.collect {|array| new_from_db(array)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    student = DB[:conn].execute("SELECT * FROM students WHERE students.name == name") #returns an array in an array
    student_object = new_from_db(student[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql)#array of arrays
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    students = DB[:conn].execute(sql)#array of arrays
    all_but_12th = students.collect {|array| new_from_db(array)}
   end

  def self.first_X_students_in_grade_10(n)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    DB[:conn].execute(sql,n)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    student = DB[:conn].execute(sql)
    student_instance = new_from_db(student[0])
    student_instance
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    DB[:conn].execute(sql, x)
  end
end
