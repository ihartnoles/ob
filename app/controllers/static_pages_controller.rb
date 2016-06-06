#require 'mapquest_api'
# require 'common_stuff'

class StaticPagesController < ApplicationController
      
      #before_filter :get_session_info
      before_filter CASClient::Frameworks::Rails::GatewayFilter, :only => [:login, :do_manual_login, :gatewayed_home, :main]
      before_filter CASClient::Frameworks::Rails::Filter, :except => [:login, :do_manual_login, :gatewayed_home, :main]
      # before_filter RubyCAS::Filter, :only => [:login, :do_manual_login, :gatewayed_home, :main]
      # before_filter RubyCAS::Filter, :except => [:login, :do_manual_login, :gatewayed_home, :main]
      #puts YAML::dump(@cas_user)

  
  def routing_error
    render_not_found(nil)
  end


  def main
     @login = Login.new
  end

  def gatewayed_home
       #if !session[:cas_user].nil?
          @displayname = session[:cas_user]
        #else
         # redirect_to unauthorized_path
        #end
  end

	def home		
			    	
          session_config

          modules_available         

          #TO DO: Query for WHC_STUDENT
          #@isHonorsCollege = 1

          #BEGIN:modules_open/close
           summer_module_opendates   
           fall_module_opendates      
           spring_module_opendates
          #END:modules_open/close

          @account_complete = 1  
        
           #BEGIN: verify complete check
            #To DO: how do we determine if VERIFY has been completed?????  Maybe radio buttons?  Is this information correct  (Y/N)?
          @verify_complete = 1
           #END: verify complete

          @immunization_complete ||= 0

          #immunization_status = Banner.immunization_status(@znum)
          residency_status = Banner.residency_status(@znum)
          finaid_status = Banner.fin_aid_docs(@znum)
          finaid_checks = Banner.fin_aid_checkboxes(@znum)
          comm_preferences = Communication.where(:znumber => @znum)
         
          
          if comm_preferences.blank?
              @contact_id = 0
              @contact_email_flag =  ''
              @contact_mobile_flag = ''
              @contact_mobile_number = ''
              @countrycode = ''
          else
            comm_preferences.each do |cp|
              @contact_id = cp['id']
              @contact_email_flag =  cp['contactByEmail']
              @contact_mobile_flag = cp['contactByPhone']
              @contact_mobile_number = cp['contactMobileNumber']
              @countrycode = cp['countrycode']
              #puts YAML::dump(@contact_mobile_number)
            end

            if !@contact_mobile_number.blank?
                @displaynumber = @contact_mobile_number
            else
                @displaynumber = [@phone_area, @phone_number].join('.')
            end           

          end

          #pull the commmunication pref. data for the particular znumber
          communication_data = Communication.find(:all, :conditions => ["znumber = ? AND (contactByEmail = ? OR contactByPhone = ?) ", @znum, 1, 1])

          #set the flag appropriate
          if communication_data.count >= 1
            @communication_complete = 1
          else
            @communication_complete = 0
          end

          #query for learning community data for the student
          lc_preferences = Community.where(:znumber => @znum)

          #has the user entered any information about learning communities?
          if lc_preferences.count > 0
            @learning_comm_complete = 1
          else
            @learning_comm_complete = 0
          end

          #set the learning community variables used in the front-end form
          if lc_preferences.blank?
              @lc_id = 0
              @join_lc =  ''
              @lc_choice = ''
              @cclc_type = ''
              @isSigned = ''
              @signature = ''              
          else
            lc_preferences.each do |lc|
              @lc_id = lc['id']
              @join_lc =  lc['join_lc']
              @lc_choice = lc['lc_choice']
              @cclc_type = lc['cclc_type']
              @isSigned = lc['isSigned']
              @signature = lc['signature']                           
            end
          end


          #BEGIN verify your information question

          #query for VERIFY INFO data for the student
          verify_info = Verify.where(:znumber => @znum)

          #has the user entered any information about VERIFYING THEIR INFO?
          if verify_info.count > 0
            @verify_info_complete = 1
          else
            @verify_info_complete = 0
          end

          #set the verify variables used in the front-end form
          if verify_info.blank?
              @verify_id = 0
              @verify_info =  ''               
          else
            verify_info.each do |v|
              @verify_id = v['id']
              @verify_info =  v['verify_info']
            end
          end

          #END verify your information question

          #pull the student's zip
          student_zip = Banner.find_student_zip_by_z(@znum)

           # puts YAML::dump('**********AYYEEEEE**********')
           # puts YAML::dump(student_zip)

          #set the zip
          if student_zip.count >= 1
            student_zip.each do |o| 
               zipcode = o['zip']  
               @zipcode = o['zip']      
               # puts YAML::dump('**********ZIIIIIIIP**********')
               # puts YAML::dump(zipcode)
               # puts YAML::dump('**********CODE**********')
            end

            if @zipcode.nil?
              @zipcode = '00000'
            end
          else
            @zipcode = '00000'
          end              

          housing_fee_status = 0
          oars_status = Faudw.oars_status(@znum)
          orientation_status = Faudw.orientation_status(@znum)
          registration_status = Banner.registered_hours(@znum)
          get_multistatus = Banner.get_multistatus(@znum)
          immune_check = Banner.immunization_status(@znum)
          orientation_check = Banner.check_orientation_hold(@znum)

          @welcome_complete = 1

            if get_multistatus.blank?
               @aleks_complete = 0
               @deposit_complete ||= 0
               @dep_complete_flag = 0
               #@account_complete = 0
               @emergency_complete = 0
               @fau_alert_complete = 0
               @isInternationalStudent ||= 0
               #@immunization_complete = 0
            else
                get_multistatus.each do |o|

                  @fname =  o['f_name']
                  @lname =  o['l_name']
                  @netid =  o['gobtpac_external_user']       
                  @term_code_entry = o['saradap_term_code_entry']          

                  #@OwlImage = RestClient.get('https://devserviceawards.fau.edu/test2.cfm?fname=Peter&lname=Griffon')
                  
                  if o['whc_student'] == 'N' || o['whc_student'].nil?
                    @isHonorsCollege = 0
                  else
                    @isHonorsCollege = 1
                  end 

                  if o['int_student'] == 'N' || o['int_student'].nil?
                    @isInternationalStudent = 0
                  else
                    @isInternationalStudent = 1
                  end 

                  if o['aleks_taken'] == 'N' || o['aleks_taken'].nil?
                    @aleks_complete = 0
                  else
                    @aleks_complete = 1
                  end 

                  if o['aleks_score'].nil?
                    @aleks_score = ''
                  else
                    @aleks_score = o['aleks_score']
                  end  

                  if o['sarchkl_admr_code'] == 'TUTD' && !o['sarchkl_receive_date'].nil?
                    @deposit_complete ||= 1   #change this back to 1
                    @dep_complete_flag = 1                    
                  else
                    @deposit_complete ||= 0
                    @dep_complete_flag = 0
                  end 

                  #this needs to be changed to hit up OIM
                  # if o['gobtpac_external_user'].nil?
                  #   @account_complete = 0
                  # else
                  #   @account_complete = 1
                  # end 

                  if o['spremrg_contact_name'].nil?
                    @emergency_complete = 0
                  else
                    @emergency_complete = 1
                    @emergency_contact = o['spremrg_contact_name']
                    @emergency_street = o['spremrg_street_line1']
                    @emergency_city = o['spremrg_city']
                    @emergency_state = o['spremrg_stat_code']
                    @emergency_zip = o['spremrg_zip']
                    @emergency_phone_area = o['spremrg_phone_area']
                    @emergency_phone_number = o['spremrg_phone_number']
                  end 

                  #BEGIN: FAU Alert info
                  if o['gwrr911_phone_area'].nil? || o['gwrr911_phone_number'].nil?
                     @fau_alert_complete = 0
                  else
                    @fau_alert_complete = 1
                    @fau_alert_phone_area = o['gwrr911_phone_area']
                    @fau_alert_phone_number = o['gwrr911_phone_number']
                    @fau_alert_tele_code = o['gwrr911_tele_code']
                    @fau_alert_text_capable = o['gwrr911_text_capable']                    
                  end 
                  #END: FAU Alert Info

                  @term_display = o['term']
                  @year_display = o['year']
                  
                  @email        = o['goremal_email_address']
                  @phone_area   = o['sprtele_phone_area']
                  @phone_number = o['sprtele_phone_number']                  
                end
            end

           # if !orientation_check.nil?
           #    orientation_check.each do |o|
           #      if (o['sprhold_hldd_code'] == 'OR' || o['sprhold_hldd_code'] == 'OA')
           #        @orientation_complete = 0                
           #      else
           #        @orientation_complete = 1
           #      end             
           #    end #end of each loop
           # else
           #  @orientation_complete = 1
           # end


             if !orientation_check.nil?
                if orientation_check.count > 0 #begin
                  orientation_check.each do |o|
                    if (o['sprhold_hldd_code'] == 'OR' || o['sprhold_hldd_code'] == 'OA')
                      @orientation_complete = 0
                      #break
                    else
                      @orientation_complete = 1
                    end 
                  end #end of each loop
                else
                   @orientation_complete = 1
                end #end ouf count
            else
               @orientation_complete = 1
            end #end of nil check




          if !immune_check.nil?
            if immune_check.count > 0 #begin
              immune_check.each do |o|
                if o['im_exists'] == 'Y' &&  o['sprhold_hldd_code'] == 'IM'
                  @immunization_complete = 0
                  #break
                else
                  @immunization_complete = 1
                end 
              end #end of each loop
            else
               @immunization_complete = 1
            end #end ouf count
        else
           @immunization_complete = 1
        end #end of nil check


          #begin finaidcheckboxes
            finaidchecks = []

            finaid_checks.each do |o|

               if o['rtvtreq_code'] == 'TERMS' && o['rrrareq_sat_ind'] == 'Y'
                   #tc_complete = 1
                   finaidchecks.push('TC1')
               end
       
             
               if o['rtvtreq_code'] == 'ISIR' && o['rrrareq_sat_ind'] == 'Y'
                   #application_complete = 1
                    finaidchecks.push('APP1')
               end

               if (o['mpn_type'] == 'S' || o['mpn_type'] == 'N') && o['mpn_sat_ind'] == 'N'
                  #application_complete = 1
                  finaidchecks.push('MPN')
               end



               if (o['rorstat_pckg_comp_date'].nil? || o['rorstat_pckg_comp_date'].blank?)  &&  o['rorstat_aidy_code'] == @current_summer_aidy
                  @finaid_package_complete = 0
               else
                  @finaid_package_complete = 1
               end


                if (o['rorstat_pckg_comp_date'].nil? || o['rorstat_pckg_comp_date'].blank?) &&  o['rorstat_aidy_code'] == @current_summer_aidy
                  @summer_finaid_package_complete = 0
               else
                  @summer_finaid_package_complete = 1
               end

              
               if o['rorstat_all_req_comp_date'].nil? || o['rorstat_all_req_comp_date'].blank?
                  @eligibility_reqs_complete = 0
               else
                  @eligibility_reqs_complete = 1
               end


               if  finaidchecks.include? 'TC1'
                  @tc_complete = 1
                elsif finaidchecks.empty?
                   @tc_complete = 0
                else
                  @tc_complete = 0
                end 


                if  finaidchecks.include? 'APP1'
                  @application_complete = 1
                elsif finaidchecks.empty?
                   @application_complete = 0
                else
                  @application_complete = 0
                end 


            end

            # puts YAML::dump('**********BEGIN**********')
            # puts YAML::dump(finaidchecks)
            # puts YAML::dump('**********END**********')

          #end

          #query to see if they indicated if they need financial aid or not
          
          finaidneedflag = Finaidneed.find_by_znumber(@znum)
          if !finaidneedflag.nil?
              @finaidneedflag = finaidneedflag.needFinAid
              @finaidneedflag_summer = finaidneedflag.needFinAidAlt
          else            
              @finaidneedflag = nil
              @finaidneedflag_summer = nil
          end

          
          #begin finaidflags
          finaidflags = []

          finaid_status.each do |o|
            if o['rrrareq_sat_ind'] == 'N' || o['rrrareq_sat_ind'].nil? ||  @finaid_package_complete = 0 || @eligibility_reqs_complete = 0 ||  @fin_aid_acceptance = 0 || @tc_complete = 0
              #@finaid_complete = 0
              finaidflags.push('0')
            else
              #@finaid_complete = 1
              finaidflags.push('1')
            end

            if (o['rrrareq_sat_ind'] == 'N' || o['rrrareq_sat_ind'].nil?) && o['RORSTAT_AIDY_CODE'] ==  @current_summer_aidy && (@summer_finaid_package_complete = 0 || @summer_eligibility_reqs_complete = 0 ||  @summer_fin_aid_acceptance = 0 || @summer_tc_complete = 0)
              #@summer_finaid_complete = 0
              finaidflags.push('S0')
            else
              #@summer_finaid_complete = 1
              finaidflags.push('S1')
            end

            if  o['fafsa_flg'] == 'Y'  
              @fafsa_complete = 1
            else
              @fafsa_complete = 0
            end

            if  !o['mpn_type'].nil? || !o['mpn_type'].blank?
              @mpn_type = o['mpn_type']
            else
              @mpn_type = 'n/a'
            end


            @finaidyear = o['finaidyear']
            @aidy= o['rorstat_aidy_code']

            if o['summer_app'] == 'Y'
              #set up summer flags

              #BEGIN: check if summer five questions answered
              five_questions = Banner.summer_five_questions(@znum)

              if five_questions.count >= 5
                 @summer_fivequestions_complete = 1
              else
                 @summer_fivequestions_complete = 0
                 finaidflags.push('SQ')
              end 

              #END: check if summer five questions answered

              if  o['fafsa_flg'] == 'Y' && o['rorstat_aidy_code'] ==  @current_summer_aidy
                @summer_fafsa_complete = 1
              else
                @summer_fafsa_complete = 0
              end

               if o['rorstat_all_req_comp_date'].nil? && o['rorstat_aidy_code'] ==  @current_summer_aidy
                  @summer_eligibility_reqs_complete = 0
               else
                  @summer_eligibility_reqs_complete = 1
               end

               if o['rtvtreq_code'] == 'TERMS' && o['rrrareq_sat_ind'] == 'Y' && o['rorstat_aidy_code'] ==  @current_summer_aidy
                   @summer_tc_complete = 1
               else
                   @summer_tc_complete = 0
               end
            end

          end

                
          if  finaidflags.include? '0'
            @finaid_complete = 0
          elsif finaidflags.include? 'S0'
            @summer_finaid_complete = 0
          elsif finaidflags.include? 'MPN'
             @summer_finaid_complete = 0
             @finaid_complete = 0
          elsif finaidflags.include? 'SQ' #summer SSB questions not answered
            @summer_finaid_complete = 0
          elsif finaidflags.include? 'S1'
            @summer_finaid_complete = 1
          elsif finaidflags.empty?
             @finaid_complete = 0
             @summer_finaid_complete = 0
          else
            @finaid_complete = 1
            @summer_finaid_complete = 1
          end 
          #end finaidflags

          if @finaidneedflag == "NO"
             @finaid_complete = 1
          end

          if @finaidneedflag_summer == "NO"
             @summer_finaid_complete = 1
          end

          #begin finaidacceptance
            fin_aid_acceptance = Banner.fin_aid_acceptance(@znum)
            
            #@fin_aid_semesters = Banner.fin_aid_semesters(@znum)
            @fin_aid_semesters = Banner.distinct_fin_aid_semesters(@znum)
            

            if fin_aid_acceptance.nil? || fin_aid_acceptance.blank? || fin_aid_acceptance.count == 0
              @fin_aid_acceptance = 0
              @summer_fin_aid_acceptance = 0
              @fin_aid_term_one = 'Summer'
              @fin_aid_term_two = 'Fall'
            else 
                # 01 = Spring
                # 05 = Summer
                # 08 = Fall
               @fin_aid_acceptance = 0

               fin_aid_acceptance.each do |fa|
                 if !fa['rpratrm_accept_date'].nil? && (fa['rpratrm_period'] == @current_spring_term_in || fa['rpratrm_period'] == @current_summer_term_in)
                  @fin_aid_acceptance = 1
                 #else 
                 # @fin_aid_acceptance = 0
                 end

                 if !fa['rpratrm_accept_date'].nil? && fa['rpratrm_period'] == @current_summer_term_in
                  @summer_fin_aid_acceptance = 1
                 else 
                  @summer_fin_aid_acceptance = 0
                 end
               end              
            end
          #end finaidacceptance



          #BEGIN housing
            housing_exemption = Housing.get_housing_exemption(@znum)
            housing_reqs = Banner.additional_housing_reqs(@znum)
            deposit_received = Housing.get_housing_deposit(@znum)
            meal_plan_info = Housing.get_meal_plan(@znum)


            #BEGIN: meal plan info
            if meal_plan_info.count >= 1
                @meal_plan_selected = 1
                meal_plan_info.each do |mp| 
                    @dining_plan = mp['dining_plan']                               
                end      
            else
              @meal_plan_selected = 0
            end            
            #END: meal plan info

            #set a default deposit received to 0
            @housing_deposit_received = 0
           

            if housing_exemption.count >= 1
              #they have a housing exemption
              @housing_exemption = 1
              @housing_fee_required = 0
              @housing_fee_complete = 1
            else
              #BEGIN housing_reqs bcuz they don't have an exemption
                 if housing_reqs.blank?
                    @housing_fee_required = 0 #default to not-required; we can't find any info on them! YIKES!
                    @housing_fee_complete = 0 

                  else

                    housing_reqs.each do |o| 
                       @married = o['spbpers_mrtl_code']
                       @whc_student = o['whc_student']    
                       @age = o['age']   
                       @term = o['term']            
                    end      

                    if @married = 'M' ||  @age >= 21 || @term = 'Summer' #check if they are married ,over the age of 21, or enrolling in summer; Summer == NO FEE FOR HOUSING
                       @housing_fee_required = 0
                       @housing_fee_complete = 1 
                    end

                    if @whc_student == 'Y'  #check if they are a wilkes honors college student
                      #check zipcode radius for Jupiter Campus; WHC students have to live on Jupiter Campus
                        @housing_fee_required = 1  
                    else
                      #check zipcode radius for Boca Campus
                      if @housing_fee_required = 1 
                          housing_fee_query = HousingZipcode.where(:zip => @zipcode.gsub(/\D/, ''))

                          #determine if housing fee is required
                          if housing_fee_query.count == 0 #no match found; must be outside of zipcode whitelist            
                            @housing_fee_required = 1
                            @housing_fee_complete = 0           
                          else
                            @housing_fee_required = 0
                            @housing_fee_complete = 1        
                          end

                      # else
                      #   @housing_fee_required = 1 
                      end
                    end
                   
                   

                    if deposit_received.count >= 1
                      @housing_fee_required = 0
                      @housing_fee_complete = 1
                      @housing_deposit_received = 1
                    end
                    
                        # puts YAML::dump('***** START ******')
                        # #puts YAML::dump(deposit_received.empty?)
                        # puts YAML::dump(deposit_received.count)
                        # puts YAML::dump(@housing_fee_required)
                        # puts YAML::dump(@zipcode)
                        # puts YAML::dump('****** END ********')

                  end
              #END housing reqs
            end 
          #END housing


          #@residency_complete = 0
          if residency_status.count <= 0
               @residency_complete = 0
               @FLA_resident = 0
          else
            residency_status.each do |o|
               @residency_complete = 1

              if o['sgbstdn_resd_code'].include?('T') || o['sgbstdn_resd_code'].include?('F') || o['sgbstdn_resd_code'].include?('R') || o['sgbstdn_resd_code'].include?('O')
                @FLA_resident = 1
              else
                @FLA_resident = 0
              end 
            end
          end

          #TO DO: make this dynamic
          @housing_meal_plans_complete = 1
         


          #@oars_complete = 1
          if oars_status.blank?
             @oars_complete = 0
             @oars_complete_flag = 0
          else
            oars_status.each do |o|
              if o.nil?
                @oars_complete = 0
                @oars_complete_flag = 0
              else
                @oars_complete = 1
                @oars_complete_flag = 1
              end
            end
          end

        
          if  orientation_status.count == 0
              @orientation_complete = 1              
          else
            orientation_status.each do |o|
              if o['attended'] == 'Yes' && !o['attended'].nil?
                @orientation_complete = 1
              #   break
              else
                @orientation_complete = 0
              end
            end
          end

          #@reg_complete = 0
          if registration_status.blank?
                @reg_complete = 0
          else 
               #@reg_complete = 1
                total_hours = Banner.total_hours(@znum)
                
                if total_hours.count == 0
                     @reg_complete = 0
                else
                 total_hours.each do |o|
                   if o['totalhours'].nil?
                     @reg_complete = 0
                   elsif o['totalhours'] >= 12 &&  o['term'] == 'Fall' || o['term'] == 'Spring'
                     @reg_complete = 1
                   elsif o['totalhours'] >= 6 && o['term'] == 'Summer'
                     @reg_complete = 1
                   else
                     @reg_complete = 0
                   end
                 end  #end of each loop
               end

          end


          get_all_holds = Banner.get_all_holds(@znum)

          if get_all_holds.count >= 1
            @holds_exist = 1
          else 
            @holds_exist = 0
          end

          #@emergency_complete = 0
          #@fau_alert_complete = 0
          @owlcard_complete = 0
          @bookadvance_complete = 1
          @tuition_complete = 0
          @vehicle_reg_complete = 0   

          updateDaMeter
        
          updateCompletedStep(@znum)
          
          #updateNextStep

    end

	# def admin	

	# 	if session[:usertype] != 4
	# 		redirect_to unauthorized_path
	# 	else
	# 		@title      = 'Administration'
 #    		@description = 'Administrative Panel'		
 #    	end

	# end

	# def reports
	# 	@title = 'Reports'
	# 	@description = 'Reporting Options'
	# end 

  def dashboard

    authenticate_for_admin(session[:cas_user])


    if @access == 1
      studentype = params[:type].presence || 'ftic'

      case studentype
       when "ftic"
         @table_label = "First Time in College Queue"
         #@modules_availables = FticModulesAvailable.select("id,netid,znumber,f_name,l_name,current_step").where(:isactive => 1).order(:netid)
       when "intl"
         @table_label = "International Queue"
         #@modules_availables = FticModulesAvailable.select("id,netid,znumber,f_name,l_name,current_step").where(:isactive => 1).order(:netid)
       when "transfer"
         @table_label = "Transfer Queue"
         #@modules_availables = FticModulesAvailable.select("id,netid,znumber,f_name,l_name,current_step").where(:isactive => 1).order(:netid)
       else
         @table_label = "Student Queue"
         #@modules_availabless = FticModulesAvailable.select("id,netid,znumber,f_name,l_name,current_step").where(:isactive => 1).order(:netid)
       end

        render layout: 'admin'
     else
        redirect_to unauthorized_path
     end
  end

  def dashdata
    #@message = Message.new(message_params)
    @modules_availables = FticModulesAvailable.select("id,netid,znumber,f_name,l_name,current_step").where(:isactive => 1).order(:netid)

    respond_to do |format|
      #format.json { render json: { "language" => @languages.as_json(:root => false) }.to_json }
      format.json { render json: { "iTotalRecords" =>  @modules_availables.count , "iTotalDisplayRecords" => @modules_availables.count , "aaData" => @modules_availables.as_json(:root => false) }.to_json  }
    end
  end

  def dashstats
     get_daily_logins
     get_login_times
    
     total = FticModulesAvailable.all().count
    
     @ftic_count = FticModulesAvailable.where(:isInternational => 0).count
    
     # @mourn_count = (Float(tmp_morn_count)/Float(login_times.count) * 100)
     # @afternoon_count = (Float(tmp_afternoon_count)/Float(login_times.count)  * 100)
     
     @int_count = FticModulesAvailable.where(:isInternational => 1).count

     @ftic_percent = (Float(@ftic_count)/Float(total)  * 100)
     @int_percent = (Float(@int_count)/Float(total)  * 100)

     @status_counts = FticModulesAvailable.find_by_sql(["select current_step, count(*) AS num from ftic_modules_availables group by current_step order by num desc"])

     # puts YAML::dump('*** BUC LAO ***')
     # puts YAML::dump(@status_counts)

     render layout: 'admin'

  end

  
 
	def unauthorized
		@title = 'Unauthorized'
		@description = ''

		render layout: false
	end 


  def transfer
    @title = 'Contact FAU Admissions'
    @description = ''

    #render layout: false
  end 

  

  def fticsync
      @Bannerstuds = Banner.find_newstudents

      @Bannerstuds.each do | bs |
        
        if FticModulesAvailable.find_by_znumber(bs['z_number']).nil? 
         newstudent = FticModulesAvailable.new
         newstudent.znumber = bs['z_number']
         newstudent.netid   = bs['gobtpac_external_user']
         newstudent.f_name = bs['f_name']
         newstudent.l_name = bs['l_name']
         newstudent.welcome = 1
         newstudent.verify = 1
         newstudent.verifybypass = 0
         newstudent.deposit = 1
         newstudent.depositbypass = 0
         newstudent.account = 1
         newstudent.accountbypass = 0
         newstudent.communication = 1
         newstudent.communicationbypass = 0
         newstudent.depositbypass = 0
         newstudent.immunization = 1
         newstudent.immunizationbypass = 0
         newstudent.finaid = 1
         newstudent.finaidbypass = 0
         if bs['term'] == "Summer"
          newstudent.summer_finaid = 1
         else
          newstudent.summer_finaid = 0
         end
         newstudent.summer_finaidbypass = 0
         newstudent.housingfee = 0
         newstudent.housingfeebypass = 0
         newstudent.residency = 0
         newstudent.residencybypass = 0
         newstudent.housingmealplan = 0
         newstudent.housingmealplanbypass = 0
         newstudent.aleks = 0
         newstudent.aleksbypass = 0
         newstudent.oars = 0
         newstudent.oarsbypass = 0
         newstudent.learning_comm = 0
         newstudent.learning_commbypass = 0
         newstudent.orientation = 0
         newstudent.orientationbypass = 0
         newstudent.registration = 0
         newstudent.registrationbypass = 0
         newstudent.emergency = 0
         newstudent.emergencybypass = 0
         newstudent.faualert = 0
         newstudent.faualertbypass = 0
         newstudent.owlcard = 0
         newstudent.owlcardbypass = 0
         newstudent.bookadvance = 0
         newstudent.bookadvancebypass = 0
         newstudent.tution = 0
         newstudent.tuitionbypass = 0
         newstudent.vehiclereg = 0 
         newstudent.vehicleregbypass = 0
         newstudent.congrats = 0
         newstudent.isactive = 1
         if bs['int_student'] == "Y"
          newstudent.isInternational = 1
         else
          newstudent.isInternational = 0
         end
         newstudent.intl_medical = 0
         newstudent.intl_medical_bypass = 0
         newstudent.intl_visa = 0
         newstudent.intl_visa_bypass = 0
         newstudent.intl_orientation = 0
         newstudent.intl_orientation_bypass = 0
         newstudent.save(validate: false)   
        else
         student = FticModulesAvailable.find_by_znumber(bs['z_number'])     

         if bs['int_student'] == "Y"
          isInternational = 1
         else
          isInternational = 0
         end

         if bs['term'] == "Summer"
          summer_finaid = 1
         else
          summer_finaid = 0
         end
        
         student.update_attributes(
          :netid => bs['gobtpac_external_user'],
          :znumber => bs['z_number'],
          :f_name => bs['f_name'],
          :l_name => bs['l_name'],
          :isInternational => isInternational,
          :communication => 1,
          :finaid => 1,
          :summer_finaid => summer_finaid,
          :immunization => 1
         ) 
        end

      end

      render :nothing => true

  end

  #mapquest integration - 
  def calc_distance
      @from  = 'Boca Raton, FL'
      @to = 'Aventura, FL'
      mapquest = MapquestApi.new
      distance = mapquest.post_url(@from, @to)
      puts YAML::dump('*** DUH HELLO ***')
      puts YAML::dump(distance)
      render :nothing => true
  end

  
   

   protected

   def authenticate_for_admin(netid)
      user = User.where(:netid => netid)
      if user.count == 0 #no info found
        @access = 0
      else
        @access = 1
      end       
   end 


   def get_daily_logins
      logins = ActivityLog.where(:note => 'User Login').pluck(:created_at)
     
     @sun_count = 0
     @mon_count = 0
     @tue_count = 0
     @wed_count = 0
     @thur_count = 0
     @fri_count = 0
     @sat_count = 0

     logins.each do |l|
         case l.wday
           when 0            
             @sun_count += 1             
           when 1
             @mon_count += 1     
           when 2
             @tue_count += 1
           when 3
             @wed_count += 1
           when 4
             @thur_count += 1
           when 5
             @fri_count += 1
           else
             @sat_count += 1
           end
     end
     
   end #end of daily logins

   def get_login_times
      login_times = ActivityLog.where(:note => 'User Login').pluck(:created_at)
     
     tmp_morn_count = 0
     tmp_afternoon_count = 0
     tmp_evening_count = 0
    
     login_times.each do |lt|
        if lt.strftime("%H") >= "00" && lt.strftime("%H") < "12"
           tmp_morn_count += 1  
        elsif  lt.strftime("%H") > "12" && lt.strftime("%H") <= "18"
           tmp_afternoon_count += 1
        else
           tmp_evening_count += 1
        end          
     end
    
     @mourn_count = (Float(tmp_morn_count)/Float(login_times.count) * 100)
     @afternoon_count = (Float(tmp_afternoon_count)/Float(login_times.count)  * 100)
     @evening_count = (Float(tmp_evening_count)/Float(login_times.count)  * 100)
   end

end