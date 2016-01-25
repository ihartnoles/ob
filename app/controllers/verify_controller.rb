#require 'common_stuff'
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

    
    update_ftic_verify_module(params[:ftic_id],params[:verify],params[:znumber], params[:netid])
   
 
    if  params[:verify_info] == "No"
      #their information is NOT correct we have to send them back to verify
      if params[:znum]
        #redirect for admin proxy
        redirect_to "/home?znum=#{params[:znum]}#step-verify"
      else
        #redirect for student
        redirect_to "/home#step-verify"
      end
    else
       #their information is CORRECT we have to move them forward to DEPOSIT
      if params[:znum]
          redirect_to "/home?znum=#{params[:znum]}#step-deposit" #redirect to deposit
      else
         redirect_to "/home#step-deposit"
      end  
    end

   
  end

end