class StudentsController < ApplicationController

  def index
    @students = Student.all.order(:last_name)
  end

end
