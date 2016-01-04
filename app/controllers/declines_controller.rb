class DeclinesController < ApplicationController
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

  def save_decline
    @decline = Decline.new
    @decline.netid = params[:netid]  
    @decline.znumber = params[:znumber]  
    @decline.reason = params[:reason]     
    @decline.save
  end
 
end
