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
      rescue_from TinyTds::Error,
                  :with => :render_dberror
  end

  def session_config
    session[:usertype]  = nil
      @znum = nil
      
      if !session[:cas_user].nil?
         @displayname = session[:cas_user]     
      else
         @displayname = 'N/A'
      end
      
       session[:current_summer_term] = '2015-2016'
      # session[:current_summer_aidy] = '1516'
       session[:current_fall_term] = '2016-2017'
      # session[:current_fall_aidy] = '1617'

      @current_summer_term = '2015-2016'
      @current_summer_term_in = '201605'
      @current_summer_aidy = '1516'

      @current_fall_term = '2016-2017'
      @current_fall_term_in = '201608'
      @current_fall_aidy = '1617'

      @current_spring_term_in = '201608'

   
      if request.server_name.include?('owldone')
         @sso_url = 'bannersso.fau.edu'         
      else
         @sso_url = 'sctformsalt.fau.edu:8484'      
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
            @street = o['street_line1']
            @city = o['city']      
            @state = o['state'] 
            @zip = o['zip'] 
            @street2 = o['street2_line1']
            @city2 = o['city2']      
            @state2 = o['state2'] 
            @zip2 = o['zip2'] 
            @netid = o['gobtpac_external_user']
            @email = o['goremal_email_address']
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
            @street = o['street_line1']
            @city = o['city']      
            @state = o['state'] 
            @zip = o['zip'] 
            @street2 = o['street2_line1']
            @city2 = o['city2']      
            @state2 = o['state2'] 
            @zip2 = o['zip2'] 
            @netid = o['gobtpac_external_user']
            @email = o['goremal_email_address']
        end     
      
        record_activity("User Login")
        
        #begin: TRANSFER STATUS CHECK
        transfer_status = Banner.transfer_status(znum)
        if transfer_status.count > 0  
           transfer_status.each do |ts|
              if ts['sgrsatt_atts_code'] == 'TRAA'              
              redirect_to transfer_path
             end
          end
        end
        #end: TRANSFER STATUS CHECK

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
            @summer_finaid_available = 1
            @summer_finaid_bypass = 0
            @housing_fee_available = a.housingfee
            @housingfee_bypass = a.housingfeebypass
            @residency_available = a.residency
            @residency_bypass = a.residencybypass           
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

    if @communication_complete == 0
        currentstep = 'Communication Preference'
        break
     end

     if @deposit_complete == 0
         currentstep = 'Deposit'
         break
     end

     if  @finaid_complete == 0 && @isInternationalStudent == 0
         currentstep = 'Financial Aid'
         break
     end
    

     if @immunization_complete == 0
        currentstep = 'Immunization'
        break
     end

     if @residency_complete == 0 && @isInternationalStudent == 0
        currentstep = 'Residency'
        break
     end

         
     if  @housing_fee_complete == 0
         currentstep = 'Housing & Meal Plans'
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

     if @fau_alert_complete == 0
         currentstep = 'FAU Alert'
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

   
    end
    
    @currentstep = currentstep
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

# BEGIN module open dates
  def summer_module_opendates
    verify_summer_dates =  Moduledate.select("opendate,closedate,termvalue").where("name = 'Verify Your Information' AND termvalue=?", @current_summer_term_in)
    
    if verify_summer_dates.count > 0 
      verify_summer_dates.each do |s|
        @verify_module_summer_open = s.opendate
        @verify_module_summer_close = s.closedate
        @verify_module_summer_term = s.termvalue
      end   
    end
    
     comm_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Communication Preference' AND termvalue=?", @current_summer_term_in)
     if verify_summer_dates.count > 0 
       comm_summer_dates.each do |s|
        @comm_module_summer_open = s.opendate
        @comm_module_summer_close = s.closedate
        @comm_module_summer_term = s.termvalue 
       end
     end

     deposit_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Pay Deposit' AND termvalue=?", @current_summer_term_in)
     if deposit_summer_dates.count > 0 
       deposit_summer_dates.each do |s|
        @deposit_module_summer_open = s.opendate
        @deposit_module_summer_close = s.closedate
        @deposit_module_summer_term = s.termvalue 
       end
     end

     immunization_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Immunization Holds' AND termvalue=?", @current_summer_term_in)
     if immunization_summer_dates.count > 0 
       immunization_summer_dates.each do |s|
        @immune_module_summer_open = s.opendate
        @immune_module_summer_close = s.closedate
        @immune_module_summer_term = s.termvalue 
       end
     end

     residency_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Residency Validation' AND termvalue=?", @current_summer_term_in)
     if residency_summer_dates.count > 0 
       residency_summer_dates.each do |s|
        @residency_module_summer_open = s.opendate
        @residency_module_summer_close = s.closedate
        @residency_module_summer_term = s.termvalue 
       end
     end

     housing_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Housing Contract & Meal Plans' AND termvalue=?", @current_summer_term_in)
     if housing_summer_dates.count > 0 
       housing_summer_dates.each do |s|
        @housing_module_summer_open = s.opendate
        @housing_module_summer_close = s.closedate
        @housing_module_summer_term = s.termvalue 
       end
     end

    aleks_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Math Placement Exam - ALEKS' AND termvalue=?", @current_summer_term_in)
     if aleks_summer_dates.count > 0 
       aleks_summer_dates.each do |s|
        @aleks_module_summer_open = s.opendate
        @aleks_module_summer_close = s.closedate
        @aleks_module_summer_term = s.termvalue 
       end
     end

     orientation_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Orientation' AND termvalue=?", @current_summer_term_in)
     if orientation_summer_dates.count > 0 
       orientation_summer_dates.each do |s|
        @orientation_module_summer_open = s.opendate
        @orientation_module_summer_close = s.closedate
        @orientation_module_summer_term = s.termvalue 
       end
     end

    oars_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Online Adivision & Resource System - OARS' AND termvalue=?", @current_summer_term_in)
     if oars_summer_dates.count > 0 
       oars_summer_dates.each do |s|
        @oars_module_summer_open = s.opendate
        @oars_module_summer_close = s.closedate
        @oars_module_summer_term = s.termvalue 
       end
     end

     faualert_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'FAU Alert Information' AND termvalue=?", @current_summer_term_in)
     if faualert_summer_dates.count > 0 
       faualert_summer_dates.each do |s|
        @faualert_module_summer_open = s.opendate
        @faualert_module_summer_close = s.closedate
        @faualert_module_summer_term = s.termvalue 
       end
     end

      registration_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Registration & Holds' AND termvalue=?", @current_summer_term_in)
     if registration_summer_dates.count > 0 
       registration_summer_dates.each do |s|
        @registration_module_summer_open = s.opendate
        @registration_module_summer_close = s.closedate
        @registration_module_summer_term = s.termvalue 
       end
     end

    tuition_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Tuition Payment' AND termvalue=?", @current_summer_term_in)
     if tuition_summer_dates.count > 0 
       tuition_summer_dates.each do |s|
        @tuition_module_summer_open = s.opendate
        @tuition_module_summer_close = s.closedate
        @tuition_module_summer_term = s.termvalue 
       end
     end

     emergency_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Emergency Contacts' AND termvalue=?", @current_summer_term_in)
     if emergency_summer_dates.count > 0 
       emergency_summer_dates.each do |s|
        @emergency_module_summer_open = s.opendate
        @emergency_module_summer_close = s.closedate
        @emergency_module_summer_term = s.termvalue 
       end
     end

    owlcard_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Owl Card' AND termvalue=?", @current_summer_term_in)
     if owlcard_summer_dates.count > 0 
       owlcard_summer_dates.each do |s|
        @owlcard_module_summer_open = s.opendate
        @owlcard_module_summer_close = s.closedate
        @owlcard_module_summer_term = s.termvalue 
       end
     end

    book_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Book Advance Program' AND termvalue=?", @current_summer_term_in)
     if book_summer_dates.count > 0 
       book_summer_dates.each do |s|
        @book_module_summer_open = s.opendate
        @book_module_summer_close = s.closedate
        @book_module_summer_term = s.termvalue 
       end
     end

     regvehicle_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Register Your Vehicle' AND termvalue=?", @current_summer_term_in)
     if regvehicle_summer_dates.count > 0 
       regvehicle_summer_dates.each do |s|
        @regvehicle_module_summer_open = s.opendate
        @regvehicle_module_summer_close = s.closedate
        @regvehicle_module_summer_term = s.termvalue 
       end
     end

     @fin_aid_summer_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Financial Aid' AND termvalue=?", @current_summer_term_in)
     if @fin_aid_summer_dates.count > 0 
       @fin_aid_summer_dates.each do |s|
        @fin_aid_module_summer_open = s.opendate
        @fin_aid_module_summer_close = s.closedate
        @fin_aid_module_summer_term = s.termvalue 
       end
     end

  end

  def fall_module_opendates
    verify_fall_dates =  Moduledate.select("opendate,closedate,termvalue").where("name = 'Verify Your Information' AND termvalue=?", @current_fall_term_in)
    
    if verify_fall_dates.count > 0
      verify_fall_dates.each do |f|
        @verify_module_fall_open = f.opendate
        @verify_module_fall_close = f.closedate
        @verify_module_fall_term = f.termvalue
      end
    end

     comm_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Communication Preference' AND termvalue=?", @current_fall_term_in)
     if comm_fall_dates.count > 0
       comm_fall_dates.each do |f|
         @comm_module_fall_open = f.opendate
         @comm_module_fall_close = f.closedate
         @comm_module_fall_term = f.termvalue 
       end
     end

     deposit_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Pay Deposit' AND termvalue=?", @current_fall_term_in)
     if deposit_fall_dates.count > 0 
       deposit_fall_dates.each do |s|
        @deposit_module_fall_open = s.opendate
        @deposit_module_fall_close = s.closedate
        @deposit_module_fall_term = s.termvalue 
       end
     end

     immunization_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Immunization Holds' AND termvalue=?", @current_fall_term_in)
     if immunization_fall_dates.count > 0 
       immunization_fall_dates.each do |s|
        @immune_module_fall_open = s.opendate
        @immune_module_fall_close = s.closedate
        @immune_module_fall_term = s.termvalue 
       end
     end

      residency_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Residency Validation' AND termvalue=?", @current_fall_term_in)
     if residency_fall_dates.count > 0 
       residency_fall_dates.each do |s|
        @residency_module_fall_open = s.opendate
        @residency_module_fall_close = s.closedate
        @residency_module_fall_term = s.termvalue 
       end
     end

      housing_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Housing Contract & Meal Plans' AND termvalue=?", @current_fall_term_in)
     if housing_fall_dates.count > 0 
       housing_fall_dates.each do |s|
        @housing_module_fall_open = s.opendate
        @housing_module_fall_close = s.closedate
        @housing_module_fall_term = s.termvalue 
       end
     end
     
     aleks_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Math Placement Exam - ALEKS' AND termvalue=?", @current_fall_term_in)
     if aleks_fall_dates.count > 0 
       aleks_fall_dates.each do |s|
        @aleks_module_fall_open = s.opendate
        @aleks_module_fall_close = s.closedate
        @aleks_module_fall_term = s.termvalue 
       end
     end

      orientation_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Orientation' AND termvalue=?", @current_fall_term_in)
     if orientation_fall_dates.count > 0 
       orientation_fall_dates.each do |s|
        @orientation_module_fall_open = s.opendate
        @orientation_module_fall_close = s.closedate
        @orientation_module_fall_term = s.termvalue 
       end
     end

     oars_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Online Adivision & Resource System - OARS' AND termvalue=?", @current_fall_term_in)
     if oars_fall_dates.count > 0 
       oars_fall_dates.each do |s|
        @oars_module_fall_open = s.opendate
        @oars_module_fall_close = s.closedate
        @oars_module_fall_term = s.termvalue 
       end
     end

     faualert_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'FAU Alert Information' AND termvalue=?", @current_fall_term_in)
     if faualert_fall_dates.count > 0 
       faualert_fall_dates.each do |s|
        @faualert_module_fall_open = s.opendate
        @faualert_module_fall_close = s.closedate
        @faualert_module_fall_term = s.termvalue 
       end
     end


     registration_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Registration & Holds' AND termvalue=?", @current_fall_term_in)
     if registration_fall_dates.count > 0 
       registration_fall_dates.each do |s|
        @registration_module_fall_open = s.opendate
        @registration_module_fall_close = s.closedate
        @registration_module_fall_term = s.termvalue 
       end
     end

     tuition_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Tuition Payment' AND termvalue=?", @current_fall_term_in)
     if tuition_fall_dates.count > 0 
       tuition_fall_dates.each do |s|
        @tuition_module_fall_open = s.opendate
        @tuition_module_fall_close = s.closedate
        @tuition_module_fall_term = s.termvalue 
       end
     end

       emergency_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Emergency Contacts' AND termvalue=?", @current_fall_term_in)
     if emergency_fall_dates.count > 0 
       emergency_fall_dates.each do |s|
        @emergency_module_fall_open = s.opendate
        @emergency_module_fall_close = s.closedate
        @emergency_module_fall_term = s.termvalue 
       end
     end

       owlcard_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Owl Card' AND termvalue=?", @current_fall_term_in)
     if owlcard_fall_dates.count > 0 
       owlcard_fall_dates.each do |s|
        @owlcard_module_fall_open = s.opendate
        @owlcard_module_fall_close = s.closedate
        @owlcard_module_fall_term = s.termvalue 
       end
     end

     book_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Book Advance Program' AND termvalue=?", @current_fall_term_in)
     if book_fall_dates.count > 0 
       book_fall_dates.each do |s|
        @book_module_fall_open = s.opendate
        @book_module_fall_close = s.closedate
        @book_module_fall_term = s.termvalue 
       end
     end

     regvehicle_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Register Your Vehicle' AND termvalue=?", @current_fall_term_in)
     if regvehicle_fall_dates.count > 0 
       regvehicle_fall_dates.each do |s|
        @regvehicle_module_fall_open = s.opendate
        @regvehicle_module_fall_close = s.closedate
        @regvehicle_module_fall_term = s.termvalue 
       end
     end

    @fin_aid_fall_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Financial Aid' AND termvalue=?", @current_fall_term_in)
     if @fin_aid_fall_dates.count > 0 
       @fin_aid_fall_dates.each do |s|
        @fin_aid_module_fall_open = s.opendate
        @fin_aid_module_fall_close = s.closedate
        @fin_aid_module_fall_term = s.termvalue 
       end
     end

  end
  

  def spring_module_opendates
    verify_spring_dates =  Moduledate.select("opendate,closedate,termvalue").where("name = 'Verify Your Information' AND termvalue=?", @current_spring_term_in)
    if verify_spring_dates.count > 0
      verify_spring_dates.each do |sp|
        @verify_module_spring_open = sp.opendate
        @verify_module_spring_close = sp.closedate
        @verify_module_spring_term = sp.termvalue
      end
     end

    comm_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Communication Preference' AND termvalue=?", @current_spring_term_in)
    if comm_spring_dates.count > 0
      comm_spring_dates.each do |sp| 
       @comm_module_spring_open = sp.opendate
       @comm_module_spring_close = sp.closedate
       @comm_module_spring_term = sp.termvalue 
      end
    end

     deposit_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Pay Deposit' AND termvalue=?", @current_spring_term_in)
     if deposit_spring_dates.count > 0 
       deposit_spring_dates.each do |s|
        @deposit_module_spring_open = s.opendate
        @deposit_module_spring_close = s.closedate
        @deposit_module_spring_term = s.termvalue 
       end
     end

     immunization_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Immunization Holds' AND termvalue=?", @current_spring_term_in)
     if immunization_spring_dates.count > 0 
       immunization_spring_dates.each do |s|
        @immune_module_spring_open = s.opendate
        @immune_module_spring_close = s.closedate
        @immune_module_spring_term = s.termvalue 
       end
     end

      residency_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Residency Validation' AND termvalue=?", @current_spring_term_in)
     if residency_spring_dates.count > 0 
       residency_spring_dates.each do |s|
        @residency_module_spring_open = s.opendate
        @residency_module_spring_close = s.closedate
        @residency_module_spring_term = s.termvalue 
       end
     end

      housing_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Housing Contract & Meal Plans' AND termvalue=?", @current_spring_term_in)
     if housing_spring_dates.count > 0 
       housing_spring_dates.each do |s|
        @housing_module_spring_open = s.opendate
        @housing_module_spring_close = s.closedate
        @housing_module_spring_term = s.termvalue 
       end
     end

    aleks_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Math Placement Exam - ALEKS' AND termvalue=?", @current_spring_term_in)
     if aleks_spring_dates.count > 0 
       aleks_spring_dates.each do |s|
        @aleks_module_spring_open = s.opendate
        @aleks_module_spring_close = s.closedate
        @aleks_module_spring_term = s.termvalue 
       end
     end

     orientation_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Orientation' AND termvalue=?", @current_spring_term_in)
     if orientation_spring_dates.count > 0 
       orientation_spring_dates.each do |s|
        @orientation_module_spring_open = s.opendate
        @orientation_module_spring_close = s.closedate
        @orientation_module_spring_term = s.termvalue 
       end
     end

    oars_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Online Adivision & Resource System - OARS' AND termvalue=?", @current_spring_term_in)
     if oars_spring_dates.count > 0 
       oars_spring_dates.each do |s|
        @oars_module_spring_open = s.opendate
        @oars_module_spring_close = s.closedate
        @oars_module_spring_term = s.termvalue 
       end
     end

    faualert_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'FAU Alert Information' AND termvalue=?", @current_spring_term_in)
     if faualert_spring_dates.count > 0 
       faualert_spring_dates.each do |s|
        @faualert_module_spring_open = s.opendate
        @faualert_module_spring_close = s.closedate
        @faualert_module_spring_term = s.termvalue 
       end
     end

     registration_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Registration & Holds' AND termvalue=?", @current_spring_term_in)
     if registration_spring_dates.count > 0 
       registration_spring_dates.each do |s|
        @registration_module_spring_open = s.opendate
        @registration_module_spring_close = s.closedate
        @registration_module_spring_term = s.termvalue 
       end
     end

     tuition_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Tuition Payment' AND termvalue=?", @current_spring_term_in)
     if tuition_spring_dates.count > 0 
       tuition_spring_dates.each do |s|
        @tuition_module_spring_open = s.opendate
        @tuition_module_spring_close = s.closedate
        @tuition_module_spring_term = s.termvalue 
       end
     end

     emergency_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Emergency Contacts' AND termvalue=?", @current_spring_term_in)
     if emergency_spring_dates.count > 0 
       emergency_spring_dates.each do |s|
        @emergency_module_spring_open = s.opendate
        @emergency_module_spring_close = s.closedate
        @emergency_module_spring_term = s.termvalue 
       end
     end

       owlcard_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Owl Card' AND termvalue=?", @current_spring_term_in)
     if owlcard_spring_dates.count > 0 
       owlcard_spring_dates.each do |s|
        @owlcard_module_spring_open = s.opendate
        @owlcard_module_spring_close = s.closedate
        @owlcard_module_spring_term = s.termvalue 
       end
     end

     book_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Book Advance Program' AND termvalue=?", @current_spring_term_in)
     if book_spring_dates.count > 0 
       book_spring_dates.each do |s|
        @book_module_spring_open = s.opendate
        @book_module_spring_close = s.closedate
        @book_module_spring_term = s.termvalue 
       end
     end

     regvehicle_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Register Your Vehicle' AND termvalue=?", @current_spring_term_in)
     if regvehicle_spring_dates.count > 0 
       regvehicle_spring_dates.each do |s|
        @regvehicle_module_spring_open = s.opendate
        @regvehicle_module_spring_close = s.closedate
        @regvehicle_module_spring_term = s.termvalue 
       end
     end

     @fin_aid_spring_dates = Moduledate.select("opendate,closedate,termvalue").where("name = 'Financial Aid' AND termvalue=?", @current_spring_term_in)
     if @fin_aid_spring_dates.count > 0 
       @fin_aid_spring_dates.each do |s|
        @fin_aid_module_spring_open = s.opendate
        @fin_aid_module_spring_close = s.closedate
        @fin_aid_module_spring_term = s.termvalue 
       end
     end

end
#END open modules


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

    def render_dberror(exception)
      ExceptionNotifier::Notifier
        .exception_notification(request.env, exception)
        .deliver
       render :file => 'public/db.html',  :status => :not_found, :layout => false

    end


end #end of class