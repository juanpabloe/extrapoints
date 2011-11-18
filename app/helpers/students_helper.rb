module StudentsHelper

  def is_bday?(student)
    student.dob == Time.new.strftime('%m-%d')
  end



end
