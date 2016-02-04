class CommunitiesController < ApplicationController
  #before_action :set_message, only: [:show, :edit, :update, :destroy]

  

  def save_lc
    if params[:id] == "0"
      #create a new record
      @lc = Community.new
    else
      #update existing record
      @lc = Community.find(params[:id])
    end
      @lc.netid = params[:netid]  
      @lc.znumber = params[:znumber]  
      @lc.join_lc = params[:join_lc] 
      @lc.lc_choice = params[:lc_choice]    
      @lc.cclc_type = params[:cclc_type]
      # @lc.isSigned = params[:isSigned]
      @lc.signature = params[:signature] 
      @lc.save
   
      update_ftic_learning_module(params[:ftic_id],params[:learning_comm],params[:znumber], params[:netid])
        
      if params[:znum]
        #redirect for admin proxy
        redirect_to "/home?znum=#{params[:znum]}#step-oars"
      else
        #redirect for student
        redirect_to "/home#step-oars"
      end

  end
 
end
