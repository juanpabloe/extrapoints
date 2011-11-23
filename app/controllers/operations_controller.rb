class OperationsController < ApplicationController

  def index
    #Solo puedo revisar el historial de transacciones de mi usuario
    @operations = Operation.where("from_user_id = #{current_user.id} OR to_user_id = #{current_user.id}").order("created_at DESC")
  end

  def show
    @operation = Operation.find(params[:id])
  end

  def new
    if (params[:operation] == "donation" || (params[:operation] == "withdraw" and current_user.teacher?)) and params[:to_student] != current_user.id
      @student = Student.find(params[:to_student])
      @operation = Operation.new(:op_type => params[:operation], :to_user_id => params[:to_student])
    else
      redirect_to students_path, :notice => "Operacion invalida"
    end
  end

  def give_present
    @student = Student.find(params[:to_student])
    if is_bday?(@student)
      @operation = Operation.new(:op_type => "donation")
    else
      redirect_to menu_students_path
    end
  end
  
  def multiple
		if (params[:operation] == "donation" || params[:operation] == "withdraw")
      session[:to_students] = params[:to_students]
      session[:op_type] = params[:operation]
      redirect_to new_multiple_user_operations_path(current_user)
    else
      redirect_to students_path, :notice => "Operacion invalida"
    end			
  end
  
  def new_multiple
  	@students_names = Student.find(session[:to_students]).map{ |s| s.complete_name}.join(", ")
  end
  
  def create_multiple
  	to_users = Student.find(session[:to_students])
    @multiple = { :amount_over => false, :multiple => true }

  	if session[:op_type] == 'donation'
			to_users.each do |user|
				@operation = Operation.new(:amount => params[:operation_amount],
																	:description => params[:operation_description],
																	:op_type => session[:op_type], 
																	:to_user_id => user.id)
        make_donation(user)
      end
	  elsif session[:op_type] == 'withdraw'
		  to_users.each do |user|
        make_withdraw(user, params[:operation_amount], params[:operation_description])
		  end
	  end
    if @multiple[:amount_over] and @multiple[:multiple]
      redirect_to new_multiple_user_operations_path(current_user),
        :notice => "Las transacciones deben de ser menores a 100 puntos"
    elsif @multiple[:multiple] and @multiple[:error]
      redirect_to new_multiple_user_operations_path(current_user), 
        :notice => "Verifica los valores ingresados"
    else 
      redirect_to user_operations_path(current_user)
    end
  end

  def create
    @operation = Operation.new(params[:operation])
    to_user = Student.find(params[:operation][:to_user_id])
    @multiple = { :amount_over => false, :multiple => false }

    if @operation.op_type == "donation"
      make_donation(to_user)
    elsif @operation.op_type == "withdraw" and current_user.teacher?
      make_withdraw(to_user, @operation.amount, @operation.description)
    end
  end


  private


  def make_donation(to_user)
    donation_result = Operation.new_donation(current_user.id, @operation.amount, current_user.pin, to_user.username) 

    # Cuando la transferencia es exitosa, el webservice regresa un mensaje indicando el balance actual
    if donation_result.eql? "Your current balance is now"
      @operation.from_user = current_user
      @operation.after_balance = to_user.points + @operation.amount
      if @operation.save
        update_user_points(to_user)
      end
    else
      if @multiple[:multiple]
        if donation_result.eql? "The amount must not be over"
          return @multiple = { :amount_over => true, :multiple => true }
        else
          return @multiple = { :amount_over => false, :multiple => true, :error => true }
        end
      else
        if donation_result.eql? "The amount must not be over"
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "donation"),
            :notice => "El monto debe de ser menor a 100 puntos y mayor a 0"
        else 
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "donation"), 
            :notice => "Verifica los valores ingresados"
        end
      end
    end
  end

  def make_withdraw(to_user, amount, description)
    transaction = Operation.new_withdraw(current_user.id, current_user.pin, amount)
    t_id = transaction[:transaction_id].to_i
    error = transaction[:error_message][0..26]

    if error.eql? "none"
      Pretransaction.create!(:transaction_id => t_id,
                             :user_id => to_user.id,
                             :user_pin => to_user.pin,
                             :amount => amount,
                             :from_user => current_user.id,
                             :description => description)
      if !@multiple[:multiple]
        flash[:error] = "Ticket de retiro creado exitosamente. Se cobrara una vez que el estudiante inicie sesion."
        redirect_to menu_teachers_path
      end
    else 
      if @multiple[:multiple]
        if error.eql? "The amount must not be over"
          return @multiple = { :amount_over => true, :multiple => true }
        else
          return @multiple = { :amount_over => false, :multiple => true, :error => true }
        end
      else
        if error.eql? "The amount must not be over"
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "withdraw"),
            :notice => "Las transacciones deben de ser menores a 100 puntos"
        else 
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "withdraw"), 
            :notice => "Verifica los valores ingresados"
        end
      end
    end
  end

end
