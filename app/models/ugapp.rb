class Ugapp < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="applicant"

	 establish_connection(:ugapp)

	def self.find_user(email,password)
		get = connection.exec_query("SELECT emailaddress firstname, lastname, shapassword  FROM APPLICANT WHERE emailaddress=#{connection.quote(email)} AND shapassword=#{connection.quote(password)}")

		if get.count > 0
			return true
    	else 
    		return false
    	end 
	end


	def self.get_fullname(email,password)
		fullname = connection.exec_query("select concat(concat(firstname,' '),lastname) as fullname FROM APPLICANT WHERE emailaddress=#{connection.quote(email)} AND shapassword=#{connection.quote(password)}")

		return fullname	
	end

end