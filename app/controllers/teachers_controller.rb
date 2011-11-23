class TeachersController < ApplicationController
  def index
  end

  def menu
    if current_user.student?
      redirect_to menu_students_path
    end
  end

end
