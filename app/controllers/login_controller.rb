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

      #Ugapp.find_user('ihartstein.test1@gmail.com', Base64.strict_encode64(Digest::SHA1.digest('12341234')))

      if authenticated
        @message = 'i found yo ass'

       
        session[:fullname] = Ugapp.get_fullname(params[:email], base64_passwd)
        #session[:displayname] = Ugapp.get_fullname(params[:email], base64_passwd)

        puts YAML::dump(session[:fullname])


        # session.delete(:cas_user)

        redirect_to gatewayed_home_path
      else
        @message = 'nopity nope nope'
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