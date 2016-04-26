class FticModulesAvailablesController < ApplicationController

  before_filter CASClient::Frameworks::Rails::Filter
  #before_action :set_ftic_modules_available, only: [:show, :edit, :update, :destroy]
  #before_filter RubyCAS::Filter

  # GET /modules_availables
  # GET /modules_availables.json
  def index
    @modules_availables = FticModulesAvailable.where(:isactive => 1).order(:netid)
  end

  def moduledetail
    @modules_availables = FticModulesAvailable.where(:znumber => params[:znum])   
    @ma = FticModulesAvailable.where(:id =>  params[:id] )
  end

  # GET /modules_availables/1
  # GET /modules_availables/1.json
  def show
  end

  # GET /modules_availables/new
  def new
    @modules_available = FticModulesAvailable.new
  end

  # GET /modules_availables/1/edit
  def edit
     
    @current_summer_term = '2015-2016'
    @current_fall_term = '2016-2017'
     
    @modules_available = FticModulesAvailable.find(params[:id])
    #@modules_available =FticModulesAvailable.where(:znumber => params[:znum]) 
    @ma = FticModulesAvailable.where(:id =>  params[:id] )
    @znum = params[:znum]

    #immunization_status = Banner.immunization_status(@znum)
    residency_status = Banner.residency_status(@znum)
    finaid_status = Banner.fin_aid_docs(@znum)
    finaid_checks = Banner.fin_aid_checkboxes(@znum)
    comm_preferences = Communication.where(:znumber => @znum)
    housing_fee_status = 0
    oars_status = Faudw.oars_status(@znum)
    orientation_status = Faudw.orientation_status(@znum)
    registration_status = Banner.registered_hours(@znum)
    get_multistatus = Banner.get_multistatus(@znum)
    immune_check = Banner.immunization_status(@znum)
    orientation_check = Banner.check_orientation_hold(@znum)


    #BEGIN: To-Dos
      # @fau_alert_complete = 0
      # @owlcard_complete = 0
      # @bookadvance_complete = 1
      # @tuition_complete = 0
      # @vehicle_reg_complete = 0
      # housing_fee_status = 0
      # # @isInternationalStudent = 5
    #END: To-Dos

          if comm_preferences.blank?
              @contact_id = 0
              @contact_email_flag =  ''
              @contact_mobile_flag = ''
              @contact_mobile_number = ''
          else
            comm_preferences.each do |cp|
              @contact_id = cp['id']
              @contact_email_flag =  cp['contactByEmail']
              @contact_mobile_flag = cp['contactByPhone']
              @contact_mobile_number = cp['contactMobileNumber']              
            end
          end

          #pull the commmunication pref. data for the particular znumber
          comm_data = Communication.find(:all, :conditions => ["znumber = ? AND (contactByEmail = ? OR contactByPhone = ?) ", @znum, 1, 1])

          #set the flag appropriate
          if comm_data.count>= 1
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

           #BEGIN verify your information question
            #query for VERIFY INFO data for the student
            verify_info = Verify.where(:znumber => @znum)

            #has the user entered any information about VERIFYING THEIR INFO?
            if verify_info.count > 0
              @verify_info_complete = 1
            else
              @verify_info_complete = 0
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

    #BEGIN: multistatus check; just trying to limit the number of queries
   

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
                    # @emergency_contact = o['spremrg_contact_name']
                    # @emergency_street = o['spremrg_street_line1']
                    # @emergency_city = o['spremrg_city']
                    # @emergency_state = o['spremrg_stat_code']
                    # @emergency_zip = o['spremrg_zip']
                    # @emergency_phone_area = o['spremrg_phone_area']
                    # @emergency_phone_number = o['spremrg_phone_number']
                  end 

                  #BEGIN: FAU Alert info
                  if o['gwrr911_phone_area'].nil? || o['gwrr911_phone_number'].nil?
                     @fau_alert_complete = 0
                  else
                    @fau_alert_complete = 1
                    # @fau_alert_phone_area = o['gwrr911_phone_area']
                    # @fau_alert_phone_number = o['gwrr911_phone_number']
                    # @fau_alert_tele_code = o['gwrr911_tele_code']
                    # @fau_alert_text_capable = o['gwrr911_text_capable']                    
                  end 
                  #END: FAU Alert Info

                   @term_display = o['term']
                  # @year_display = o['year']
                  
                  # @email        = o['goremal_email_address']
                  # @phone_area   = o['sprtele_phone_area']
                  # @phone_number = o['sprtele_phone_number'] 
                 
                end #end of multistatus loop
            end
            #END: multistatus check

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


               if (o['rorstat_pckg_comp_date'].nil? || o['rorstat_pckg_comp_date'].blank?)  &&  o['rorstat_aidy_code'] == @current_fall_aidy
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

               fin_aid_acceptance.each do |fa|
                 if !fa['rpratrm_accept_date'].nil? && (fa['rpratrm_period'] == '201601' || fa['rpratrm_period'] == '201608')
                  @fin_aid_acceptance = 1
                 else 
                  @fin_aid_acceptance = 0
                 end

                 if !fa['rpratrm_accept_date'].nil? && fa['rpratrm_period'] == '201605'
                  @summer_fin_aid_acceptance = 1
                 else 
                  @summer_fin_aid_acceptance = 0
                 end
               end              
            end

          #end finaidacceptance


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

            @finaidyear = o['finaidyear']
            @aidy= o['rorstat_aidy_code']

            if o['summer_app'] == 'Y'
              #set up summer flags
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
                      end
                    end
                                    

                    if deposit_received.count >= 1
                      @housing_fee_required = 0
                      @housing_fee_complete = 1
                      @housing_deposit_received = 1
                    end
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

        
          if orientation_status.blank? || orientation_status.count <= 0
              @orientation_complete = 0
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

          render layout: 'admin'
  end

  # POST /modules_availables
  # POST /modules_availables.json
  def create
    @modules_available = FticModulesAvailable.new(ftic_modules_available_params)

    # PUTS YAML:DUMP('BEGIN*************************************')
    # PUTS YAML:DUMP(ftic_modules_available_params)
    # PUTS YAML:DUMP('END*************************************')


    respond_to do |format|
      if @modules_available.save
        format.html { redirect_to @modules_available, notice: 'Modules available was successfully created.' }
        format.json { render action: 'show', status: :created, location: @modules_available }
      else
        format.html { render action: 'new' }
        format.json { render json: @modules_available.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modules_availables/1
  # PATCH/PUT /modules_availables/1.json
  def update
    @modules_available = FticModulesAvailable.find(params[:id])

    model_params = params[:ftic_modules_available].permit( :znumber, :netid, :f_name, :l_name, :welcome, :deposit, :depositbypass, :account, :accountbypass, :communication, :communicationbypass, :immunization, :immunizationbypass, 
        :summer_finaid, :summer_finaidbypass,
        :finaid, :finaidbypass, :housingfee, :housingfeebypass, :residency, :residencybypass, :housingmealplan, :housingmealplanbypass, :aleks, :aleksbypass, :oars, :oarsbypass, :learning_comm,  :learning_commbypass, 
        :orientation, :orientationbypass, 
        :registrationbypass, :registration, :emergency, :emergencybypass, :faualert,  :faualertbypass, :owlcard, :owlcardbypass, :bookadvance, :bookadvancebypass ,:tution, :tuitionbypass, :vehiclereg, :vehicleregbypass,
        :verify, :verifybypass, :intl_medical, :intl_medical_bypass, :intl_visa, :intl_visa_bypass, :intl_orientation, :intl_orientation_bypass )

    record_activity("Module Update | " + params[:ftic_modules_available][:znumber] + " | " + params[:ftic_modules_available][:netid])

    respond_to do |format|
      #if @modules_available.update(ftic_modules_available_params)
      if @modules_available.update_attributes(model_params)
        format.html { redirect_to '/dashboard/ftic', notice: 'Record updated!' }
        #format.html { redirect_to '/fticadmin/params[:ftic_modules_available][:id]/edit?znum=params[:ftic_modules_available][:znum]', notice: 'Record updated!' }
        #format.html { render action: 'edit' }
        #format.html { edit_ftic_modules_available_path(id: params[:ftic_modules_available][:id], znum:params[:ftic_modules_available][:znum]  ) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @modules_available.errors, status: :unprocessable_entity }
      end
    end

  end



  # DELETE /modules_availables/1
  # DELETE /modules_availables/1.json
  def destroy
    @modules_available.destroy
    respond_to do |format|
      format.html { redirect_to modules_availables_url }
      format.json { head :no_content }
    end
  end

   def update_ftic_account_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.account = params[:account]
    @modules_available.verify = 1 #unlock verify your information
    @modules_available.save
    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-verify" #redirect to verify your information
     else
        redirect_to "/home#step-verify"
     end  
  end





   def update_ftic_deposit_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.deposit = params[:deposit]
    
    if params[:intl] == "1"
      @modules_available.immunization = 1 #unlock immunization
    end

    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
        if params[:intl] == "0"
           if params[:term] == "Summer"
              redirect_to "/home?znum=#{params[:znum]}#step-finalt" #redirect
           else
              redirect_to "/home?znum=#{params[:znum]}#step-finaid" #redirect 
           end
        else
           redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect
        end
       
     else
        if params[:intl] == "0"
            if params[:term] == "Summer"
              redirect_to "/home?#step-finalt" #redirect
            else
              redirect_to "/home?#step-finaid" #redirect 
            end
        else
           redirect_to "/home#step-immunization" #redirect
        end
     end  
  end

 
  def update_ftic_immunization_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.immunization = params[:immunization]
    
    if params[:intl] == "1"
      @modules_available.intl_medical = 1 #unlock MEDICAL for INTL. Students
      @modules_available.housingfee = 1 #unlock HOUSING for INTL. Students
    else
      @modules_available.residency = 1 #unlock RESIDENCY VALIDATION
    end
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

      # puts YAML::dump('*** update_ftic_immunization ***')
      # puts YAML::dump(params[:intl])
      # puts YAML::dump(params[:intl].to_s)
      # puts YAML::dump(params[:znum].present?)

     if params[:znum]
        if params[:intl] == "0"
          redirect_to "/home?znum=#{params[:znum]}#step-residency" #redirect to deposit
        else
          redirect_to "/home?znum=#{params[:znum]}#step-intl-medical"
        end
     else
        if params[:intl] == "0"
          redirect_to "/home#step-residency"
         else
          redirect_to "/home#step-intl-medical"
         end
     end  
  end

  def update_ftic_orientation_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.orientation = params[:orientation]
    @modules_available.learning_comm = 1 #unlock learning communities

    if params[:intl] == "1"
      @modules_available.intl_orientation = 1 #unlock INTL. ORIENTATION        
    end

    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
        if params[:intl] == "0"
          redirect_to "/home?znum=#{params[:znum]}#step-learning" #redirect to deposit
        else
          redirect_to "/home?znum=#{params[:znum]}#step-intl-orientation"
        end
     else
        if params[:intl] == "0"
          redirect_to "/home#step-learning"
         else
          redirect_to "/home#step-intl-orientation"
         end
     end  

  end


  def update_ftic_residency_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.residency = params[:residency]
    @modules_available.housingfee = 1 #unlock housing
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-housing" #redirect to deposit
     else
        redirect_to "/home#step-housing"
     end  
  end

  def update_ftic_finaid_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.finaid = params[:finaid]
    @modules_available.immunization = 1 #unlock immunization
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])


     if Finaidneed.find_by_znumber(params[:znumber]).nil? 
      finaidneeds = Finaidneed.new
      finaidneeds.znumber = params[:znumber]
      finaidneeds.netid = params[:netid]
      finaidneeds.needFinAid = params[:needFinAid]
      finaidneeds.save(validate: false)   
     else
      finaidneeds = Finaidneed.find_by_znumber(params[:znumber]) 
      finaidneeds.update_attributes(
          :znumber => params[:znumber],          
          :netid => params[:netid], 
          :needFinAid => params[:needFinAid]
      ) 
     end

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect to deposit
     else
        redirect_to "/home#step-immunization"
     end  
  end

   def update_ftic_finaidalt_module
    # @modules_available = FticModulesAvailable.find(params[:ftic_id])
    # @modules_available.finaid = params[:finaid]
    # @modules_available.immunization = 1 #unlock immunization
    # @modules_available.save

    record_activity("Module Update Fin Aid. Alt. | " + params[:znumber] + " | " + params[:netid])


     if Finaidneed.find_by_znumber(params[:znumber]).nil? 
      finaidneeds = Finaidneed.new
      finaidneeds.znumber = params[:znumber]
      finaidneeds.netid = params[:netid]
      finaidneeds.needFinAidAlt = params[:needFinAidAlt]
      finaidneeds.save(validate: false)   
     else
      finaidneeds = Finaidneed.find_by_znumber(params[:znumber]) 
      finaidneeds.update_attributes(
          :znumber => params[:znumber],          
          :netid => params[:netid], 
          :needFinAidAlt => params[:needFinAidAlt]
      ) 
     end

     # if params[:znum]
     #     redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect to deposit
     # else
     #    redirect_to "/home#step-immunization"
     # end  

     if params[:znum]
        if params[:intl] == "0"
           if params[:term] == "Summer"
              redirect_to "/home?znum=#{params[:znum]}#step-finaid" #redirect
           else
              redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect 
           end
        else
           redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect
        end       
     else
          if params[:intl] == "0"
            if params[:term] == "Summer"
              redirect_to "/home?#step-finaid" #redirect
            else
              redirect_to "/home?#step-immunization" #redirect 
            end
        else
           redirect_to "/home#step-immunization" #redirect
        end
     end  

  end

   def update_ftic_housing_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.housingfee = params[:housingfee]
    @modules_available.aleks = 1 #unlock aleks
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-aleks" #redirect to aleks
     else
        redirect_to "/home#step-aleks"
     end  
  end

  def update_ftic_aleks_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.aleks = params[:aleks]
    @modules_available.orientation = 1 #unlock orientation
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-orientation" #redirect to deposit
     else
        redirect_to "/home#step-orientation"
     end  
  end

  
  # def update_ftic_learning_module
  #   @modules_available = FticModulesAvailable.find(params[:ftic_id])
  #   @modules_available.learning_comm = params[:learning_comm]
  #   @modules_available.oars = 1 #unlock oars
  #   @modules_available.save

  #   record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

  #    if params[:znum]
  #        redirect_to "/home?znum=#{params[:znum]}#step-oars" #redirect to deposit
  #    else
  #       redirect_to "/home#step-oars"
  #    end  
  # end

  def update_ftic_oars_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.oars = params[:oars]
    @modules_available.faualert = 1 #unlock fau alert
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-faualert" #redirect to deposit
     else
        redirect_to "/home#step-faualert"
     end  
  end

  def update_ftic_reg_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.registration = params[:registration]
    @modules_available.tution = 1 #unlock tuition
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-tuition" #redirect to deposit
     else
        redirect_to "/home#step-tuition"
     end  
  end

  def update_ftic_tuition_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.tution = params[:tution]
    @modules_available.emergency = 1 #unlock emergency contacts
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-emergency" #redirect to deposit
     else
        redirect_to "/home#step-emergency"
     end  
  end

  def update_ftic_emergency_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.emergency = params[:emergency]
    @modules_available.owlcard = 1 #unlock fau alert
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-owlcard" #redirect to deposit
     else
        redirect_to "/home#step-owlcard"
     end  
  end


   def update_ftic_alert_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.faualert = params[:faualert]
    @modules_available.registration = 1 #unlock registration
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-registration" #redirect to deposit
     else
        redirect_to "/home#step-registration"
     end  
  end


   def update_ftic_owlcard_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.owlcard = params[:owlcard]
    @modules_available.bookadvance = 1 #unlock bookadvance
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-bookadvance" #redirect to deposit
     else
        redirect_to "/home#step-bookadvance"
     end  
  end


  def update_ftic_book_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.bookadvance = params[:bookadvance]
    @modules_available.vehiclereg = 1 #unlock register your vehicle
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-vehicle" #redirect to deposit
     else
        redirect_to "/home#step-vehicle"
     end  
  end

  def update_ftic_vehicle_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.vehiclereg = params[:vehiclereg]
    @modules_available.congrats = 1 #unlock congratulations
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-congrats" #redirect to deposit
     else
        redirect_to "/home#step-step-congrats"
     end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_ftic_modules_available
    #   @modules_available = FticModulesAvailable.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ftic_modules_available_params
      params.require(:ftic_modules_available).permit(:znumber, :netid, :f_name, :l_name, :welcome, :deposit, :depositbypass, :account, :accountbypass, :communication, :communicationbypass, :immunization, :immunizationbypass, :finaid, :finaidbypass, :housingfee, :housingfeebypass, :residency, :residencybypass, :housingmealplan, :housingmealplanbypass, :aleks, :aleksbypass, :oars, :oarsbypass, :learning_comm,  :learning_commbypass, 
        :orientation, :orientationbypass, 
        :registrationbypass, :registration, :emergency, :emergencybypass, :faualert,  :faualertbypass, :owlcard, :owlcardbypass, :bookadvance, :bookadvancebypass ,:tution, :tuitionbypass, :vehiclereg, :vehicleregbypass)
    end

end
