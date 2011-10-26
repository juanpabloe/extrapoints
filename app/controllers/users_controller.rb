class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path, :notice => "User created!"
    else
      render "new"
    end
  end
  
  def index
   @users = User.all  
  end
  
  def history
    @user = User.find(params[:id])
    history = User.get_history(@user.id)
    if history.class.name == "Array"
    	history = history.reverse
    	@operations = parse_history_result_multiple(history)
    elsif history.class.name == "String"
    	@operations = parse_history_result_singular(history)
    end
    @operations
  end
  
  #Método para parsear el resultado obtenido por el web service de get history
  #TODO cambiar el finalArray por un hash para poder establecer como llaves lo que es cada atributo
  def parse_history_result_multiple (array)
  	records = {}
		array.each_with_index  do |x,y| #se rompe record por record
			arrayEquals = x.split('?')
			values = {}
			arrayEquals.each_with_index  do |i,j|
				field = i
				index_del_igual = field.index("=")
				values[field[0,index_del_igual]] = field[index_del_igual+1..-1]
			end
			records[y] = values
		end	
		records.keys.each_with_index do |index,i|
			fecha_separada = records[index]['date'].split("-") #separamos la fecha en año, mes y dia
			tiempo_separado = records[index]['time'].split(":") #separamos la fecha en hora,minutos y segundos
			created_at = Time.local(fecha_separada[0],fecha_separada[1],fecha_separada[2],
															tiempo_separado[0],tiempo_separado[1],tiempo_separado[2])
			records[index]['created_at'] = created_at
			records[index]['complete_name'] = User.find_by_username(records[index]['user']).complete_name
		end
		records
  end
  
  #Método para parsear el resultado de getHistory cuando regresa un string
  def parse_history_result_singular (string)
  	array_without_qmark = string.split('?')
  	values = {}
  	records = {}
  	array_without_qmark.each_with_index  do |i,j|
			field = i
			index_del_igual = field.index("=")
			values[field[0,index_del_igual]] = field[index_del_igual+1..-1]
		end
		records[0] = values
		records.keys.each_with_index do |index,i|
			fecha_separada = records[index]['date'].split("-") #separamos la fecha en año, mes y dia
			tiempo_separado = records[index]['time'].split(":") #separamos la fecha en hora,minutos y segundos
			created_at = Time.local(fecha_separada[0],fecha_separada[1],fecha_separada[2],
															tiempo_separado[0],tiempo_separado[1],tiempo_separado[2])
			records[index]['created_at'] = created_at
			u = User.find_by_username(records[index]['user'])
			records[index]['complete_name'] = User.find_by_username(records[index]['user']).complete_name
		end
		records
  end
end
