class StudentsController < ApplicationController

  after_filter :update_current_user_points, :only => [:withdraw, :donate]
  before_filter :confirm_withdrawals, :only => [:menu]
  before_filter :update_current_user_points, :only => [:menu]
  before_filter :same_user?, :only => [:make_donation]

  def index
    @students = Student.order("first_name ASC").reject { |student| student.id == current_user.id}
  end

  def show
    @student = Student.find(params[:id])
  end

  def ranking
    @students = Student.ordered_for_ranking
  end

  def menu
  	 remove_temp_sessions
    if current_user.teacher?
      redirect_to menu_teachers_path
    end
  end

  private

  def remove_temp_sessions
    session[:op_type] = nil
    session[:to_students] = nil
  end
  
  #Metodo para sincronizar el balance de puntos del estudiante con la base de datos de los webservices
  def update_current_user_points
      current_user.update_attributes(:points => User.update_points(current_user.id))
  end

  #Filtro que revisa si el usuario tiene retiros pendientes por cobrar si el profesor los creo
  def confirm_withdrawals
    current_user.pretransactions.each do |p|
      withdraw_result = Operation.confirm_withdraw(p.transaction_id, p.user_id, p.user_pin, p.amount)
      # Cuando el retiro es exitoso, el webservice regresa un mensaje indicando el balance actual
      if withdraw_result.eql? "Your current balance is now"
        if Operation.create!(:to_user_id => p.user_id, 
                             :from_user_id => p.from_user,
                             :op_type => "withdraw",
                             :amount => p.amount, 
                             :after_balance => (current_user.points - p.amount),
                             :description => p.description)
          update_user_points(p.user)
          update_user_points(User.find(p.from_user))
          p.destroy
        end
      end
    end
  end


end
