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
    @modules_available = FticModulesAvailable.find(params[:id])
    #@modules_available =FticModulesAvailable.where(:znumber => params[:znum]) 
    @ma = FticModulesAvailable.where(:id =>  params[:id] )

    #BEGIN: To-Dos
      @fau_alert_complete = 0
      @owlcard_complete = 0
      @bookadvance_complete = 1
      @tuition_complete = 0
      @vehicle_reg_complete = 0
      housing_fee_status = 0
    #END: To-Dos

    

    #BEGIN: multistatus check; just trying to limit the number of queries
    get_multistatus = Banner.get_multistatus(@znum)

    if get_multistatus.blank?
               @aleks_complete = 0
               @deposit_complete ||= 0
               @dep_complete_flag = 0
               @account_complete = 0
               @emergency_complete = 0
            else
                get_multistatus.each do |o|
                  if o['aleks_taken'] == 'N' || o['aleks_taken'].nil?
                    @aleks_complete = 0
                  else
                    @aleks_complete = 1
                  end 

                  if o['sarchkl_admr_code'] == 'TUTD' && !o['sarchkl_receive_date'].nil?
                    @deposit_complete ||= 1
                    @dep_complete_flag = 1
                  else
                    @deposit_complete ||= 0
                    @dep_complete_flag = 0
                  end 

                  #this needs to be changed to hit up OIM
                  if o['gobtpac_external_user'].nil?
                    @account_complete = 0
                  else
                    @account_complete = 1
                  end 


                  if o['spremrg_contact_name'].nil?
                    @emergency_complete = 0
                  else
                    @emergency_complete = 1
                    @emergency_contact = o['spremrg_contact_name']
                    @emergency_street = o['spremrg_street_line1']
                    @emergency_city = o['spremrg_city']
                    @emergency_state = o['spremrg_stat_code']
                    @emergency_zip = o['spremrg_zip']       
                  end 

                  @term_display = o['term']
                  @year_display = o['year']
                  @finaidyear = o['finaidyear']
                  
                 
                end
            end

    #END: multistatus check


    #BEGIN : FinAid Check
     finaid_status = Banner.fin_aid_docs(params[:znum])
     finaidflags = []

          finaid_status.each do |o|
            
            if o['rrrareq_sat_ind'] == 'N' || o['rrrareq_sat_ind'].nil?
              #@finaid_complete = 0
              finaidflags.push('0')
            else
              #@finaid_complete = 1
              finaidflags.push('1')
            end
          end

         
          if  finaidflags.include? '0'
            @finaid_complete = 0
          elsif finaidflags.empty?
             @finaid_complete = 0
          else
            @finaid_complete = 1
          end 
     #CHECK : FinAid Check
    

     #BEGIN: Residency Check
     residency_status = Banner.residency_status(params[:znum])

     if residency_status.blank?
               @residency_complete = 0
          else
            residency_status.each do |o|
               if o['sgbstdn_resd_code'].include?('T') || o['sgbstdn_resd_code'].include?('F') || o['sgbstdn_resd_code'].include?('R') || o['sgbstdn_resd_code'].include?('O')
                @residency_complete = 1
              else
                @residency_complete = 0
              end 
            end
     end     
     #END: Residency Check

     
     #BEGIN: Immunization Check
     immunization_status = Banner.immunization_status(params[:znum])
     
     if immunization_status.blank?
              @immunization_complete = 0
              #for testing i'm setting this to 1
              #@immunization_complete = 1
         else
         immunization_status.each do |o|
             if o['imm_hold_flg'] == 'Y' || o['imm_hold_flg'].nil?
              @immunization_complete = 0
            else
              @immunization_complete = 1
            end 
          end
     end

     #END: Immunication Check


     # BEGIN OARS CHECK
     oars_status = Faudw.oars_status(params[:znum])

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

     # END OARS CHECK

     # BEGIN: Orientation Check
     orientation_status = Faudw.orientation_status(params[:znum])

     if orientation_status.blank?
              @orientation_complete = 0
          else
            orientation_status.each do |o|
              if o['attended'] == 'Yes' && !o['attended'].nil?
                @orientation_complete = 1
              else
                @orientation_complete = 0
              end
            end
      end
      # END: Orienation Check

      # BEGIN: Registration Check
      registration_status = Banner.registered_hours(params[:znum])

      if registration_status.blank?
                @reg_complete = 0
      else 
           
           total_hours = Banner.total_hours(@znum)
              
                total_hours.each do |o|
                  if o['totalhours'].nil?
                    @reg_complete = 0
                  elsif o['totalhours'] >= 12
                    @reg_complete = 1
                  else
                    @reg_complete = 0
                  end
                end           
          end

      # END: Registration Check
     

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

    model_params = params[:ftic_modules_available].permit( :znumber, :netid, :f_name, :l_name, :welcome, :deposit, :depositbypass, :account, :accountbypass, :communication, :communicationbypass, :immunization, :immunizationbypass, :finaid, :finaidbypass, :housingfee, :housingfeebypass, :residency, :residencybypass, :housingmealplan, :housingmealplanbypass, :aleks, :aleksbypass, :oars, :oarsbypass, :learning_comm,  :learning_commbypass, 
        :orientation, :orientationbypass, 
        :registrationbypass, :registration, :emergency, :emergencybypass, :faualert,  :faualertbypass, :owlcard, :owlcardbypass, :bookadvance, :bookadvancebypass ,:tution, :tuitionbypass, :vehiclereg, :vehicleregbypass,
        :verify, :verifybypass )

    record_activity("Module Update | " + params[:ftic_modules_available][:znumber] + " | " + params[:ftic_modules_available][:netid])

    respond_to do |format|
      #if @modules_available.update(ftic_modules_available_params)
      if @modules_available.update_attributes(model_params)
        format.html { redirect_to '/dashboard/ftic', notice: 'Record updated!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @modules_available.errors, status: :unprocessable_entity }
      end
    end
  end



   def update_account_module
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


  def update_verify_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.verify = params[:verify]
    @modules_available.deposit = 1 #unlock deposit
    @modules_available.save
    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-deposit" #redirect to deposit
     else
        redirect_to "/home#step-deposit"
     end  
  end


   def update_deposit_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.deposit = params[:deposit]
    @modules_available.communication = 1 #unlock communication preference
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-comm" #redirect to deposit
     else
        redirect_to "/home#step-comm"
     end  
  end

  def update_communication_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.communication = params[:communication]
    @modules_available.immunization = 1 #unlock immunization
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect to deposit
     else
        redirect_to "/home#step-immunization"
     end  
  end

  def update_immunization_module
    @modules_available = FticModulesAvailable.find(params[:ftic_id])
    @modules_available.immunization = params[:immunization]
    @modules_available.residency = 1 #unlock residency
    @modules_available.save

    record_activity("Module Update | " + params[:znumber] + " | " + params[:netid])

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect to deposit
     else
        redirect_to "/home#step-immunization"
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
