class ApplicationController < ActionController::Base
  protect_from_forgery
  

  def session_config
    session[:usertype]  = nil
      @znum = nil
      
      if !session[:cas_user].nil?
         @displayname = session[:cas_user]
     
      else
         @displayname = 'N/A'
      end
      
      if params[:znum] 
        #this is to allow impersonation
        @znum = params[:znum]
        znum = params[:znum]
        record_activity("Proxy Login")
      else
     
        # puts YAML::dump(' *** BEGIN CAS USER  ***')      
        # puts YAML::dump(session[:cas_user])
        # puts YAML::dump('*** END CAS USER ***')      
      
        # @znum = 'Z23122293'
        output = Banner.find_student_by_netid(session[:cas_user])
         
        znum = nil

        output.each do |o| 
            @znum = o['z_number']      
            znum =  o['z_number']                  
        end     
      
        record_activity("User Login")

        if znum.nil? || znum.empty? || znum.blank?
        #we can't find you in the system peaches
          redirect_to unauthorized_path
        end 

      end
  end
end
