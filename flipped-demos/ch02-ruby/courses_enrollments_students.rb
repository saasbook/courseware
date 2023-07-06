class Student
  def initialize(name, sid)
    @name = name
    @sid = sid  # ask: why no name collision between @sid and sid?  What is scope of each?
  end
  # maybe use manually-written getter/setter first, then switch to attr_accessor
  def name
    # scope: which vars can this method 'see'?
    @name
  end
  def name=(new_name)
    @name = new_name
  end
  attr_accessor :sid
end

class Course
  attr_accessor :title, :cid, :enroll_cap
  attr_reader :students   # why not attr_accessor?
  
  def initialize(title,cid,cap)
    @title,@cid,@enroll_cap = title,cid,cap  # note, doesn't matter what local var names are
    @students = []                           # what happens if we fail to init this to []?
  end

  # v1: a course enrolls a student
  def enroll(student)           # what is the type of `student` ?
    if @students.length < enroll_cap # why not @enroll_cap ?
      @students << student
      return @students          # convention
    else
      return nil                # convention; but now no way to indicate what happened
    end
  end

  # v2: save error info
  #  add attr_reader :errors to the above, and logic to populate an errors string
  attr_reader :error
  def initialize(title,cid,cap)
    @title,@cid,@enroll_cap = title,cid,cap  # note, doesn't matter what local var names are
    @students = []
    @error = nil                # what would happen if we didn't init this to nil?
  end

  def enroll(student)           # what is the type of `student` ?
    if @students.length < enroll_cap # why not @enroll_cap ?
      @students << student
      return @students          # convention
    else
      @error = "Class is full"
      return nil                # convention; but now no way to indicate what happened
    end
  end

  # how about dropping?
  def drop(student)
    deleted_student = @students.delete(student)
    unless deleted_student
      @error = "Student was never enrolled"
      nil
    else
      deleted_student
    end
  end
end

