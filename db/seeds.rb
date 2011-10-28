# Rake task para insertar en BD a los users de ExtraPoints
require 'csv'

puts "Aqui no mas actualizando la BD ;)"

User.delete_all

puts "Creando profesores"
CSV.open("ExtraPoints_Teachers.csv", "r").each do |row|
  Teacher.create!(:username => row[3], :password => row[4], :first_name => row[0], :last_name => row[1], :dob => row[2], :pin => row[5], :points => row[6])
end

puts "Creando estudiantes"
CSV.open("ExtraPoints_Users.csv", "r").each do |row|
  Student.create!(:username => row[3], :password => row[4], :first_name => row[0], :last_name => row[1], :dob => row[2], :pin => row[5], :points => row[6])
end

puts "Limpiando nombres y apellidos"
User.all.each do |u|
  u.first_name = u.first_name.strip
  u.last_name = u.last_name.strip
  u.save
end

