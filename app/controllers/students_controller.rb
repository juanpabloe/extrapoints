class StudentsController < ApplicationController
  def index
  end

  def show
  end

  def ranking
    @students = Student.ordered.page(params[:page]).per(10)
  end

end
