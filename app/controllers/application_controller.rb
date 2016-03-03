require 'rest-client'
# require 'yaml'

class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery


  unless Rails.application.config.consider_all_requests_local
      rescue_from Exception,
                  :with => :render_error
      rescue_from ActiveRecord::RecordNotFound,
                  :with => :render_not_found
      rescue_from ActionController::RoutingError,
                  :with => :render_not_found
      rescue_from ActionController::UnknownController,
                  :with => :render_not_found
      rescue_from ActionController::UnknownAction,
                  :with => :render_not_found
  end

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
            @major = o['major_desc']     
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
            @major = o['major_desc']     
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
            @intl_visa_available = a.intl_visa
            @intl_visa_bypass = a.intl_visa_bypass
            @intl_orientation_available = a.intl_orientation
            @intl_orientation_bypass = a.intl_orientation_bypass
            @intl_medical_available = a.intl_medical
            @intl_medical_bypass = a.intl_medical_bypass
          end  	
  end #end of modules available

  def updateDaMeter
    @start = 0

     if  @account_complete == 1
           @start += 1
     end

     if @verify_complete == 1
            @start += 1
     end

     if @deposit_complete == 1
            @start += 1
     end

     if @communication_complete == 1
            @start += 1
     end

     if @immunization_complete == 1
            @start += 1
     end

     if @residency_complete == 1
            @start += 1
     end

     if @finaid_complete == 1
         @start += 1
     end

     if @housing_fee_complete == 1
         @start += 1
     end

     if @aleks_complete == 1
         @start += 1
     end

     if @orientation_complete == 1
         @start += 1
     end

     if @learning_comm_complete == 1
         @start += 1
     end

     if @oars_complete == 1
         @start += 1
     end

     if @reg_complete == 1
         @start += 1
     end

     if @tuition_complete == 1
        @start += 1
     end

     if @emergency_complete == 1
        @start += 1
     end

     if @fau_alert_complete == 1
        @start += 1
     end

  end

  def updateCompletedStep(znumber)     
    currentstep = 'n/a'
    
    while true
     if  @welcome_complete == 0
         currentstep = 'Welcome'
         break
     end
     if  @account_complete == 0
         currentstep = 'Create Account'
         break
     end

     if @verify_complete == 0
         currentstep = 'Verify Info'
         break
     end

     if @deposit_complete == 0
         currentstep = 'Deposit'
         break
     end

     if @communication_complete == 0
        currentstep = 'Comm. Pref.'
        break
     end

     if @immunization_complete == 0
        currentstep = 'Immunization'
        break
     end

     if @residency_complete == 0
        currentstep = 'Residency'
        break
     end

     if  @finaid_complete == 0
         currentstep = 'Fin. Aid.'
         break
     end
     
     if  @housing_fee_complete == 0
         currentstep = 'Housing & Meal'
         break
     end

     if  @aleks_complete == 0
         currentstep = 'Aleks'
         break
     end

     if  @orientation_complete == 0
         currentstep = 'Orientation'
         break
     end

     if  @learning_comm_complete == 0
         currentstep = 'Learning Communities'
         break
     end

     if  @oars_complete == 0
         currentstep = 'OARS'
         break
     end

     if  @reg_complete == 0
         currentstep = 'Registration'
         break
     end

     if  @reg_complete == 0
         currentstep = 'Registration'
         break
     end

     if @tuition_complete == 0
         currentstep = 'Tuition Payment'
         break
     end

     if @emergency_complete == 0
         currentstep = 'Emergency Contacts'
         break
     end

     if @fau_alert_complete == 0
         currentstep = 'FAU Alert'
         break
     end
    end
    
    # puts YAML::dump('*** @znum ***')       
    # puts YAML::dump(@znum)
    # puts YAML::dump('*** znumber ***') 
    # puts YAML::dump(znumber)
    # puts YAML::dump('*** AFTER ***') 
        
    @ftic = FticModulesAvailable.find_by_znumber(@znum)
    @ftic.current_step = currentstep
    @ftic.save
  end


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


  def update_ftic_verify_module(ftic_id,verify,znumber,netid,isIntl)
    @modules_available = FticModulesAvailable.find(ftic_id)
    @modules_available.verify = verify
    @modules_available.deposit = 1 #unlock deposit
    if isIntl == 1
        @modules_available.intl_visa = 1 #unlock VISA for INTL. Students
    end
    @modules_available.save
    record_activity("Module Update | " + znumber + " | " + netid)   
  end

   
  def update_ftic_learning_module(ftic_id,learning_comm,znumber,netid)
    @modules_available = FticModulesAvailable.find(ftic_id)
    @modules_available.learning_comm = learning_comm
    @modules_available.oars = 1 #unlock oars
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     # if params[:znum]
     #     redirect_to "/home?znum=#{params[:znum]}#step-oars" #redirect to deposit
     # else
     #    redirect_to "/home#step-oars"
     # end  
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

  def sms_send(subscribe,number)
    # api = Clickatell::API.authenticate('3543539', 'rresnick', 'dVAJOFRILWdfGe')
    # api.send_message('19546614509', 'Hello from clickatell')
    # render :nothing => true

          begin
          # Clickatell Settings
          settings = YAML.load_file("#{Rails.root.to_s}/config/config.yml")

          # The Message   
          mobile_number = "1"+number.gsub(/\D/, '') #'19546614509'       # Use comma separated numbers to send the same text message to multiple numbers.
          
          if subscribe == 1
            sms_text = 'You are signed up to receive FAU Student Onboarding Alerts!'            # 160 characters per message part
          elsif subscribe == 0
            sms_text = 'You will no longer recieve FAU Student Onboarding Alerts.'
          else
            sms_text = ''
          end 

          # Build query string
          params = {              
              # :user => 'rresnick',
              # :password => 'dVAJOFRILWdfGe',
              # :api_id => '3543539',
              :user => settings['clickatell']['username'],
              :password => settings['clickatell']['password'],
              :api_id => settings['clickatell']['api_id'],
              :to => mobile_number,
              :from => '13054000747',
              :mo => '1',
              :text => sms_text
          }

          
          # Get the response
         

          # Check for error from API
          if response.split(':').first == 'ERR'
              puts response
          else
              if response.code == 200
                if response.body[0,3] == 'ID:'
                  message_id = response.body.split(' ').last
                  puts 'Checking ' + message_id + ' status...'

                  params = {
                      :user => settings['clickatell']['username'],
                      :password => settings['clickatell']['password'],
                      :api_id => settings['clickatell']['api_id'],
                      :apimsgid => message_id
                  }

                  response = RestClient.get 'https://api.clickatell.com/http/getmsgcharge', :params => params

                  # Check for error from API
                  if response.split(':').first == 'ERR'
                      puts response
                  else
                      data = response.body.split(' ')

                      puts 'status: ' + data[-1]
                      puts 'charge: ' + data[-3]
                  end

                end
              end
          end
      rescue
          puts 'Could not get message charge, double check your settings and internet connection'
      end
  end
  

  protected
    def render_not_found(exception)
       
       ExceptionNotifier::Notifier
        .exception_notification(request.env, exception)
        .deliver

       render :file => 'public/404.html',  :status => :not_found, :layout => false
        
    end

  protected
    def render_error(exception)
      ExceptionNotifier::Notifier
        .exception_notification(request.env, exception)
        .deliver
       render :file => 'public/500.html',  :status => :not_found, :layout => false

    end


end #end of class