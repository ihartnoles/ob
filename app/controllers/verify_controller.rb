class VerifyController < ApplicationController

  def save_verify_info
    if params[:id] == "0"
      #create a new record
      @verify = Verify.new
      @verify.netid = params[:netid]  
      @verify.znumber = params[:znumber]  
      @verify.verify_info = params[:verify_info] 
      @verify.save
    else
      #update existing record
      @verify = Verify.find(params[:id])
      @verify.netid = params[:netid]  
      @verify.znumber = params[:znumber]  
      @verify.verify_info = params[:verify_info]      
      @verify.save
    end

    
    if params[:znum]
      #redirect for admin proxy
      redirect_to "/home?znum=#{params[:znum]}#step-verify"
    else
      #redirect for student
      redirect_to "/home#step-verify"
    end

  end

end