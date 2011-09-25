class StudentsController < ApplicationController
  def index
    @students = Student.search(params[:search]).reject { |student| student.id == current_user.id}
  end

  def show
    @student = Student.find(params[:id])
  end

  def ranking
    # Para actualizar el balance de puntos de cada estudiante por si alguno cambio
    @students = Student.ordered.limit(10).each { |s| update_user_points(s) }
  end

  def menu
  end

  def make_donation
    @student = Student.find(params[:id])
    @donation = Donation.new 
  end

  def donate
    from_user = User.find(session[:user_id])
    to_user = Student.find(params[:donation][:to_user_id])
    amount = params[:donation][:amount].to_i

    donation_result = Donation.begin_transfer(session[:user_id_ws], amount, from_user.pin, to_user.username) 

    # Cuando la transferencia es exitosa, el webservice regresa un mensaje indicando el balance actual
    if donation_result.eql? "Your current balance is now"
      #TODO: Refactorizar la creacion de la donacion
      @donation = Donation.create(:amount => amount, :description => params[:donation][:description])
      @donation.from_user = from_user
      @donation.to_user = to_user
      if @donation.save
        update_user_points(from_user)
        update_user_points(to_user)
        redirect_to history_user_path(from_user)
      end
    else
       redirect_to make_donation_student_path(to_user), :notice => "El valor especificado es mayor a tus puntos actuales"
    end
  end

  #Metodo para sincronizar el balance de puntos del estudiante con la base de datos de los webservices
  def update_user_points(user)
      user.update_attributes(:points => User.update_points(user.id))
  end



end
