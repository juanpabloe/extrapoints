class WithdrawController < ApplicationController
  def index
    @withdrawals = Withdraw.all
  end

  def new
    @withdraw = Withdraw.new
  end

end
