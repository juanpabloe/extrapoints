module ApplicationHelper
	def is_home_page?
		return request.path_parameters[:action] == "menu"
	end

end
