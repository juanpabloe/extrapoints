class DonationsController < ApplicationController

  def index
    @donations = Donation.all
  end

  def new
    @donation = Donation.new
  end

  def multiple
    cookies[:students] = params[:students]
    redirect_to multiple_donation_students_path
  end

end
