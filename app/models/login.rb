 class Login
 	include ActiveModel::Validations
  	include ActiveModel::Conversion
  	extend ActiveModel::Naming

  	 attr_accessor :email, :password


  	 def new_record?
  		(id.nil? || (id == 0))
	 end

  	 def persisted?
    	false
  	end
 end