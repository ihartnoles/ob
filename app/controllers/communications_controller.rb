class CommunicationsController < ApplicationController
  #before_action :set_message, only: [:show, :edit, :update, :destroy]

  
 # POST /messages
  # POST /messages.json
  # def savedeclines
  #   @decline = Decline.new(message_params)

  #   respond_to do |format|
  #     if @message.save
  #       format.html { redirect_to @message, notice: 'Message was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @message }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @message.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def save_communication
      
     if params[:id] == "0"
      #create a new record
      @communication = Communication.new
      previous = 0
     else
      @communication = Communication.find(params[:id])
      previous = @communication.contactByPhone
     end
     @communication.netid = params[:netid]  
     @communication.znumber = params[:znumber]  
     @communication.contactByEmail = params[:contactByEmail] 
     @communication.contactByPhone = params[:contactByPhone]
     @communication.contactMobileNumber = params[:mobilenumber]     
     @communication.save   
    

     update_ftic_communication_module(params[:ftic_id],params[:znumber], params[:netid])

     
      # if you are new and you've selected to be contacted and you've provided a number; then send them a confirmation message.
      if (params[:contactByPhone].present? && (previous == 0 || previous.nil?))
       sms_send(1,params[:mobilenumber])
      end
     
      # if your id is greater than zero then you are an existing record
      if (!params[:contactByPhone].present? && previous == 1)
       sms_send(0,params[:mobilenumber])
      end

      
      # Proof of concept email notifications
      # UserMailer.email_signup("Hentomi","wlinares@fau.edu").deliver
      

     if params[:znum]
         redirect_to "/home?znum=#{params[:znum]}#step-immunization" #redirect to immunization
     else
        redirect_to "/home#step-immunization"
     end  

  end
 
end
