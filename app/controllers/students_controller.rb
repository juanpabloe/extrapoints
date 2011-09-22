class StudentsController < ApplicationController
  def index
    @students = Student.search(params[:search])
  end

  def show
    @student = Student.find(params[:id])
  end

  def ranking
    @students = Student.ordered.page(params[:page]).per(10)
  end

  def menu
  end

  def make_donation
    @student = Student.find(params[:id])
    @donation = Donation.new
  end

  def donate
    from_user = Student.find(session[:user_id])
    to_user = Student.find(params[:donation][:to_user_id])
    amount = params[:donation][:amount].to_i

    donation_res = Donation.begin_transfer(session[:user_id_ws], amount, from_user.pin, "a00123456") 
    
    debugger
    if donation_res.eql? "Your current balance is now"
      #@donation.update_attributes(:points => amount, :from_user_id => from_user.id, :to_user_id => to_user.id)
      redirect_to donations_path
    end
  end

end
