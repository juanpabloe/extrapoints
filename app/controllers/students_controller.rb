class StudentsController < ApplicationController

  after_filter :update_current_user_points, :only => [:withdraw, :donate]
  before_filter :confirm_withdrawals, :only => [:menu]
  before_filter :update_current_user_points, :only => [:menu]
  before_filter :same_user?, :only => [:make_donation]

  def index
  	if params[:search]
    	@students = Student.search(params[:search]).reject { |student| student.id == current_user.id}
    else
    	@students = Student.order("first_name ASC")
    end
    @students
  end

  def show
    @student = Student.find(params[:id])
  end

  def ranking
    @students = Student.ordered
  end

  def menu
  end

  def make_donation
    @student = Student.find(params[:id])
    @donation = Donation.new
  end
  
  def multiple_donation
    @students = Student.find(cookies[:students])
  end
  
  def give_present
    @student = Student.find(params[:id])
    if is_bday?(@student)
      @donation = Donation.new
    else
      redirect_to menu_students_path
    end
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
    	if donation_result.eql? "The amount must not be over"
      	redirect_to make_donation_student_path(to_user), :notice => "Las transacciones deben de ser menores a 100 puntos"
      else 
      	redirect_to make_donation_student_path(to_user), :notice => "Verifica los valores ingresados"
      end
    end
  end

  def make_withdraw
    @student = Student.find(params[:id])
    @withdraw = Withdraw.new
  end

  def withdraw
    to_user = Student.find(params[:withdraw][:to_user_id])
    amount = params[:withdraw][:amount].to_i

    transaction = Withdraw.create_wd(current_user.id, current_user.pin, amount).to_i 

    if Pretransaction.create!(:transaction_id => transaction,
                              :user_id => to_user.id,
                              :user_pin => to_user.pin,
                              :amount => amount,
                              :from_user => current_user.id,
                              :description => params[:withdraw][:description])

      redirect_to menu_teachers_path, :notice => "Ticket de retiro creado exitosamente. Se cobrara una vez que el estudiante inicie sesion."
    else 
      redirect_to make_withdraw_student_path(to_user), :notice => "Verifica los valores ingresados"
    end
  end

  #Metodo para sincronizar el balance de puntos del estudiante con la base de datos de los webservices
  def update_current_user_points
      current_user.update_attributes(:points => User.update_points(current_user.id))
  end

  def confirm_withdrawals
    current_user.pretransactions.each do |p|
      withdraw_result = Withdraw.confirm_wd(p.transaction_id, p.user_id, p.user_pin, p.amount)
      # Cuando el retiro es exitoso, el webservice regresa un mensaje indicando el balance actual
      if withdraw_result.eql? "Your current balance is now"
        #TODO: Refactorizar la creacion del retiro
        withdraw = Withdraw.create!(:to_user => p.user, 
                                    :from_user => User.find(p.from_user),
                                    :amount => p.amount, 
                                    :description => p.description)
        if withdraw.save
          update_user_points(p.user)
          update_user_points(User.find(p.from_user))
          p.destroy
        end
      end
    end
  end


end
