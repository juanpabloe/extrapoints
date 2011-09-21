class StudentsController < ApplicationController
  def index
    @students = Student.search(params[:search])
  end

  def show
    @student = Student.find(params[:id])
    @donation = Donation.new
  end

  def ranking
    @students = Student.ordered.page(params[:page]).per(10)
  end

  def menu
  end

  def donate
    from_user = Student.find(params[:from_user_id])
    to_user = Student.find(params[:to_user_id])
    
  end

end
