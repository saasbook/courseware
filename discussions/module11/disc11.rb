class Employee
  attr_reader :name, :title attr_reader :salary

  def initialize(name, title, salary, payroll)
    @name = name
    @title = title
    @salary = salary
    @payroll = payroll
  end

  def salary(new_salary)
    @salary = new_salary
    @payroll.update(self)
  end
end

class SimpleWriter
  def initialize(path)
    @file = File.open(path, 'w')
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def close
    @file.close
  end
end

class Pond
  def initialize(number_ducks)
    @ducks = number_ducks.times.inject([]) do |ducks, i|
      ducks << Duck.new("Duck#{i}")
      ducks
    end
  end

  def simulate_one_day
    @ducks.each {|duck| duck.speak}
    @ducks.each {|duck| duck.eat}
    @ducks.each {|duck| duck.sleep}
  end
end

class SimpleLogger
  attr_accessor :level ERROR,WARNING,INFO = 1,2,3

  def initialize
    @log = File.open("log.txt", "w") @level = WARNING
  end

  def error(msg)
    ..
  end

  def warning(msg)
    ..
  end

  def info(msg)
    ..
  end
end
