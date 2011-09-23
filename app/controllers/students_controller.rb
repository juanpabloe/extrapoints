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

    donation_result = Donation.begin_transfer(session[:user_id_ws], amount, from_user.pin, to_user.username) 
    if donation_result.eql? "Your current balance is now"
      #TODO: Refactorizar la creacion de la donacion
      @donation = Donation.create(:amount => amount, :description => params[:donation][:description])
      @donation.from_user = from_user
      @donation.to_user = to_user
      if @donation.save
        redirect_to donations_path
      end
    else 
       render "make_donation", :notice => "Error!"
    end
  end

end
