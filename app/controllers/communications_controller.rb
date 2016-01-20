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
      @communication.netid = params[:netid]  
      @communication.znumber = params[:znumber]  
      @communication.contactByEmail = params[:contactByEmail] 
      @communication.contactByPhone = params[:contactByPhone]
      @communication.contactMobileNumber = params[:mobilenumber]     
      @communication.save
    else
      #update existing record
      @communication = Communication.find(params[:id])
      @communication.netid = params[:netid]  
      @communication.znumber = params[:znumber]  
      @communication.contactByEmail = params[:contactByEmail] 
      @communication.contactByPhone = params[:contactByPhone]
      @communication.contactMobileNumber = params[:mobilenumber]     
      @communication.save
    end

    
    if params[:znum]
      #redirect for admin proxy
      redirect_to "/home?znum=#{params[:znum]}#step-comm"
    else
      #redirect for student
      redirect_to "/home#step-comm"
    end

  end
 
end
