class Student < ActiveRecord::Base
	def full_name 
		last_name.upcase + ", " + first_name.capitalize + " " + middle_name.capitalize 
    end
    def course_year
    	course.upcase + " " + year_level.to_s
    end
end
