# v2: save error info, and add #full? and #drop.
# Starts from courses_enrollments_students_v1.rb.

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
  attr_reader :error      # v2: how the caller finds out what went wrong

  def initialize(title,cid,cap)
    @title,@cid,@enroll_cap = title,cid,cap  # note, doesn't matter what local var names are
    @students = []
    @error = nil                # what would happen if we didn't init this to nil?
  end

  # asking a question about the object, rather than making the caller do the
  # arithmetic.  Ruby convention: methods returning true/false end in '?'
  def full?
    @students.length >= enroll_cap  # why not @enroll_cap ?
  end

  def enroll(student)           # what is the type of `student` ?
    if full?
      @error = "Class is full"
      nil                       # convention
    else
      @students << student
      @students                 # convention
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

# ---------------------------------------------------------------------------
# Discussion: `attr_reader :students` is weaker than it looks.  It protects the
# instance *variable* (you can't repoint it at a different array), but it hands
# out the array itself, so the caller can mutate it and sail right past #enroll:
#
#   course = Course.new("CS 169A", 12345, 2)
#   course.students << "Priya Raghunathan"   # works, bypasses enroll
#   course.students << "Diego Ferreira"
#   course.students << "Wei Zhang"           # 3 students, cap of 2
#   course.students = []                     # NoMethodError: undefined method 'students='
#
# (On Ruby 3.3 that last message uses a backquote, `students='; 3.4 switched to
# a straight quote.  Same error either way.)
#
# So how do we hand out the roster without handing out the right to change it?
# Two things to try live, in place of `attr_reader :students`:
#
#   def students
#     @students.freeze      # caller's << now raises FrozenError...
#   end
#
#   ...but careful: that freezes the *real* array, so once anyone has called
#   #students, #enroll raises FrozenError too.  `@students.dup.freeze` hands
#   back a frozen copy and leaves the original writable.
#
#   def students
#     @students.each        # no block, so this returns an Enumerator: the
#   end                     # caller can each/map/select over the students,
#                           # but has no handle on the array to mutate
# ---------------------------------------------------------------------------
