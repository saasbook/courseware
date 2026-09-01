# Livecoding scaffold: the skeleton of v1, with the method bodies removed.
# Fill these in as a group; courses_enrollments_students_v1.rb is one way
# to finish it, and _v2 takes it further.

class Student
  def initialize(name, sid)
    # ask: why no name collision between @sid and sid?  What is scope of each?
  end

  # maybe use manually-written getter/setter first, then switch to attr_accessor
  def name
    # scope: which vars can this method 'see'?
  end

  def name=(new_name)
  end

  # ...and what does `attr_accessor :sid` give us for free?
end

class Course
  # which of title, cid, enroll_cap, students should be readable?  writable?

  def initialize(title, cid, cap)
    # what happens if we fail to initialize the student list to []?
  end

  # a course enrolls a student
  def enroll(student)           # what is the type of `student` ?
    # what should this return when it works?  when the class is full?
  end
end
