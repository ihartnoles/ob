class CommunitiesController < ApplicationController
  #before_action :set_message, only: [:show, :edit, :update, :destroy]

  

  def save_lc
    if params[:id] == "0"
      #create a new record
      @lc = Community.new
      @lc.netid = params[:netid]  
      @lc.znumber = params[:znumber]  
      @lc.join_lc = params[:join_lc] 
      @lc.lc_choice = params[:lc_choice]    
      # @lc.cclc_type = params[:cclc_type]
      # @lc.isSigned = params[:isSigned]
      # @lc.signature = params[:signature] 
      @lc.save
    else
      #update existing record
      @lc = Community.find(params[:id])
      @lc.netid = params[:netid]  
      @lc.znumber = params[:znumber]  
      @lc.join_lc = params[:join_lc] 
      @lc.lc_choice = params[:lc_choice]     
      # @lc.cclc_type = params[:cclc_type]
      # @lc.isSigned = params[:isSigned]
      # @lc.signature = params[:signature]
      @lc.save
    end

    
    if params[:znum]
      #redirect for admin proxy
      redirect_to "/home?znum=#{params[:znum]}#step-12"
    else
      #redirect for student
      redirect_to "/home#step-12"
    end

  end
 
end
