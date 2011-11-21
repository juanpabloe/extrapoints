class OperationsController < ApplicationController

  def index
    #Solo puedo revisar el historial de transacciones de mi usuario
    @operations = Operation.where("from_user_id = #{current_user.id} OR to_user_id = #{current_user.id}").order("created_at DESC")
  end

  def show
    @operation = Operation.find(params[:id])
  end

  def new
    if (params[:operation] == "donation" || params[:operation] == "withdraw") and params[:to_student] != current_user.id
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
  	if session[:op_type] == 'donation'
			to_users.each do |user|
				operation = Operation.new(:amount => params[:operation_amount],
																	:description => params[:operation_description],
																	:op_type => session[:op_type], 
																	:to_user_id => user.id)
				donation_result = Operation.new_donation(current_user.id, params[:operation_amount], current_user.pin, user.username)
				# Cuando la transferencia es exitosa, el webservice regresa un mensaje indicando el balance actual
		    if donation_result.eql? "Your current balance is now"
		      operation.from_user = current_user
		      operation.after_balance = user.points + operation.amount
		      if operation.save
		        update_user_points(user)
		      end
		    else
		      if donation_result.eql? "The amount must not be over"
		        redirect_to new_multiple_user_operations_path(current_user),
		          :notice => "Las transacciones deben de ser menores a 100 puntos"
		      else
		        redirect_to new_multiple_user_operations_path(current_user), 
		          :notice => "Verifica los valores ingresados"
		      end
		    end 
			end
	  elsif session[:op_type] == 'withdraw'
		  to_users.each do |user|
				#Llama al webservice													
			 	transaction = Operation.new_withdraw(current_user.id, current_user.pin, params[:operation_amount]).to_i 

				if Pretransaction.create!(:transaction_id => transaction,
				                          :user_id => user.id,
				                          :user_pin => user.pin,
				                          :amount => params[:operation_amount],
				                          :from_user => current_user.id,
				                          :description => params[:operation_description])
				else 
				    redirect_to new_multiple_user_operations_path(current_user), 
		          :notice => "Verifica los valores ingresados"
				end 	
		  end
	  end #se acaba withdra
  	redirect_to user_operations_path(current_user)
  end

  def create
    @operation = Operation.new(params[:operation])
    to_user = Student.find(params[:operation][:to_user_id])

    if @operation.op_type == "donation"
      donation_result = Operation.new_donation(current_user.id, @operation.amount, current_user.pin, to_user.username) 

      # Cuando la transferencia es exitosa, el webservice regresa un mensaje indicando el balance actual
      if donation_result.eql? "Your current balance is now"
        @operation.from_user = current_user
        @operation.after_balance = to_user.points + @operation.amount
        if @operation.save
          update_user_points(current_user)
          update_user_points(to_user)
          redirect_to user_operations_path(current_user)
        end
      else
        if donation_result.eql? "The amount must not be over"
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "donation"),
            :notice => "Las transacciones deben de ser menores a 100 puntos"
        else 
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "donation"), 
            :notice => "Verifica los valores ingresados"
        end
      end
    elsif @operation.op_type == "withdraw" and current_user.teacher?
      transaction = Operation.new_withdraw(current_user.id, current_user.pin, @operation.amount).to_i 

      if Pretransaction.create!(:transaction_id => transaction,
                                :user_id => to_user.id,
                                :user_pin => to_user.pin,
                                :amount => @operation.amount,
                                :from_user => current_user.id,
                                :description => @operation.description)

        redirect_to menu_teachers_path, :notice => "Ticket de retiro creado exitosamente. Se cobrara una vez que el estudiante inicie sesion."
      else 
          redirect_to new_user_operation_path(current_user, :to_student => to_user.id, :operation => "withdraw"), 
            :notice => "Verifica los valores ingresados"
      end
    end
  end

end
