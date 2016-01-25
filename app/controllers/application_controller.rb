class ApplicationController < ActionController::Base
  layout "application"
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

        output = Banner.find_student_by_z(params[:znum])

        output.each do |o| 
            @znum = o['z_number']      
            znum =  o['z_number']  
            @fname = o['f_name']     
            @mname = o['m_name']
            @lname = o['l_name']
            @term  = o['term']
            @year  = o['year']
            @major = o['sgbstdn_majr_code_1']     
            @street = o['spraddr_street_line1']
            @city = o['spraddr_city']      
            @state = o['spraddr_stat_code'] 
            @zip = o['spraddr_zip'] 
        end     

        record_activity("Proxy Login")
      else
           
        # @znum = 'Z23122293'
        output = Banner.find_student_by_netid(session[:cas_user])
        
        @znum = nil
        znum = nil

        output.each do |o| 
            @znum = o['z_number']      
            znum =  o['z_number']  
            @fname = o['f_name']   
            @mname = o['m_name']  
            @lname = o['l_name']
            @term  = o['term']
            @year  = o['year']
            @major = o['sgbstdn_majr_code_1']     
            @street = o['spraddr_street_line1']
            @city = o['spraddr_city']      
            @state = o['spraddr_stat_code'] 
            @zip = o['spraddr_zip'] 
        end     
      
        record_activity("User Login")

       if znum.nil? || znum.empty? || znum.blank?
        #we can't find you in the system peaches
          redirect_to unauthorized_path
        end 

      end
  end #end of session_config

  def modules_available
  	 	  availability = FticModulesAvailable.where(:znumber => @znum)

          availability.each do |a|
            @ftic_id = a.id
            @welcome_available = a.welcome
            @verify_available = a.verify
            @verify_bypass = a.verifybypass
            @deposit_available = a.deposit
            @deposit_bypass = a.depositbypass
            @account_available = a.account
            @account_bypass = a.accountbypass
            @communication_available = a.communication
            @communication_bypass = a.communicationbypass
            @immunization_available = a.immunization
            @immunization_bypass = a.immunizationbypass
            @finaid_available = a.finaid
            @finaid_bypass = a.finaidbypass
            @housing_fee_available = a.housingfee
            @housingfee_bypass = a.housingfeebypass
            @residency_available = a.residency
            @residency_bypass = a.residencybypass

            # puts YAML::dump('*** BEGIN: residency_available ***')
            # puts YAML::dump(@residency_available)
            # puts YAML::dump('*** END: residency_available ***')

            @housing_meal_plans_available = a.housingmealplan
            @housingmealplanbypass = a.housingmealplanbypass
            @aleks_available = a.aleks
            @aleksbypass = a.aleksbypass
            @oars_available = a.oars
            @oars_bypass = a.oarsbypass
            @learning_comm_available = a.learning_comm
            @learning_commbypass = a.learning_commbypass
            @orientation_available = a.orientation
            @orientationbypass = a.orientationbypass
            @reg_available = a.registration
            @registrationbypass = a.registrationbypass
            @emergency_available = a.emergency
            @emergencybypass = a.emergencybypass
            @fau_alert_available = a.faualert
            @faualertbypass = a.faualertbypass
            @owlcard_available = a.owlcard
            @owlcard_bypass = a.owlcardbypass
            @bookadvance_available = a.bookadvance
            @bookadvance_bypass = a.bookadvancebypass
            @tuition_available = a.tution
            @tuition_bypass = a.tuitionbypass
            @vehicle_reg_available = a.vehiclereg
            @vehicleregbypass = a.vehicleregbypass
            @congrats_available = a.congrats
          end  	
  end #end of modules available


  def record_activity(note)
    @activity = ActivityLog.new
    @activity.netid = session[:cas_user]
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_address = request.env['REMOTE_ADDR']
    @activity.controller = controller_name 
    @activity.action = action_name 
    @activity.params = params.inspect
    @activity.save
  end  


   def update_ftic_verify_module(ftic_id,verify,znumber,netid)
    @modules_available = FticModulesAvailable.find(ftic_id)
    @modules_available.verify = verify
    @modules_available.deposit = 1 #unlock deposit
    @modules_available.save
    record_activity("Module Update | " + znumber + " | " + netid)   
  end


  def update_ftic_communication_module(ftic_id,znumber,netid)
    @modules_available = FticModulesAvailable.find(ftic_id)
    @modules_available.immunization = 1 #unlock immunization
    @modules_available.save

    record_activity("Module Update | " + znumber + " | " + netid) 

     # if params[:znum]
     #     redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect to deposit
     # else
     #    redirect_to "/home#step-immunization"
     # end  
  end

end #end of class