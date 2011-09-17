class StudentsController < ApplicationController
  def index
  end

  def show
  end

  def ranking
    @students = Student.order("points").page(params[:page]).per(10)
  end

end
