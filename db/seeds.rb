# Rake task para insertar en BD a los users de ExtraPoints
require 'csv'

puts "Hola"

User.delete_all
puts "Creando estudiantes"
CSV.open("ExtraPoints_Users.csv", "r").each do |row|
  Student.create!(:username => row[3], :password => row[4], :first_name => row[0], :last_name => row[1], :dob => row[2], :pin => row[5], :points => row[6])
end

puts "Creando profesores"
CSV.open("ExtraPoints_Teachers.csv", "r").each do |row|
  Teacher.create!(:username => row[3], :password => row[4], :first_name => row[0], :last_name => row[1], :dob => row[2], :pin => row[5], :points => row[6])
end
  
