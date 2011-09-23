class OperationsController < ApplicationController

  def index
    @operations = Operation.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @operation = Operation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @operation }
    end
  end

  def new

  end

end
