# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

s = Student.create(:first_name => "Alejandro", :last_name => "Mancillas", :pin => "1234", :dob => "1990-20-23",
              :username => "a00123456", :points => 100)
s.password = "123456789"
s.save

s = Student.create(:first_name => "Adriana", :last_name => "Perez", :pin => "1234", :dob => "1990-20-23",
              :username => "a00123", :points => 100)
s.password = "123"
s.save

s = Student.create(:first_name => "Jose", :last_name => "Gonzalez", :pin => "1234", :dob => "1990-20-23",
              :username => "a00111", :points => 100)
s.password = "111"
s.save

s = Teacher.create(:first_name => "Lorena", :last_name => "Gomez", :pin => "1234", :dob => "1990-20-23",
              :username => "a00123", :points => 10000)
s.password = "123"
s.save
