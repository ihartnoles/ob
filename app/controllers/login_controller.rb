class LoginController < ApplicationController

	# before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => [:login, :do_manual_login, :home ]
 #  	before_filter CASClient::Frameworks::Rails::Filter, :except => [:login, :do_manual_login, :home ]

	def login
      @login = Login.new
  		#a cas_user is already set so let's send them thru to home
  		if !session[:cas_user].nil?
  			redirect_to home_path  		
  		end

     	#this is to display manual login
  	end

  	def do_manual_login

      require 'digest/sha1'
      require 'base64'

      #sha1   = Digest::SHA1.digest('bicboi')
      sha1  = Digest::SHA1.digest(params[:password])
      base64_passwd = Base64.strict_encode64(sha1)
      authenticated = Ugapp.find_user(params[:email], base64_passwd)

      if authenticated
        @message = 'Authenticated!'
    
        session[:fullname] = Ugapp.get_fullname(params[:email], base64_passwd)
      
        # session.delete(:cas_user)

        redirect_to home_path
      else
        @message = 'Failed Authentication'
        #redirect_to unauthorized_path
      end

  		#validate and authenticate here if they provide valid credentails then pass them on to the home_path
  		
  		# if #manual authentication passed
  		# 	#manual authentication passed
  		# 	redirect_to home_path
  		# else
  		# 	#authentication failed
  		# 	redirect_to_login_path
  		# end

  	end

end