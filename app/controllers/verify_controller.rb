#require 'common_stuff'
class VerifyController < ApplicationController

  def save_verify_info
    
    if params[:id] == "0"
      #create a new record
      @verify = Verify.new
    else
      #update existing record
      @verify = Verify.find(params[:id])
    end

      @verify.netid = params[:netid]  
      @verify.znumber = params[:znumber]  
      @verify.verify_info = params[:verify_info] 
      @verify.save
    
      @verify.netid = params[:netid]  
      @verify.znumber = params[:znumber]  
      @verify.verify_info = params[:verify_info]      
      @verify.save
  
      update_ftic_verify_module(params[:ftic_id],params[:verify],params[:znumber], params[:netid],params[:intl])
 
      # puts YAML::dump('*** DUH HERRO ***')
      # puts YAML::dump(params[:intl])
      # puts YAML::dump(params[:znum].present?)


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
            if params[:intl] == "0"
              redirect_to "/home?znum=#{params[:znum]}#step-deposit" #redirect to deposit
            else
              redirect_to "/home?znum=#{params[:znum]}#step-visa" #redirect to VISA for international studs.
            end
        else
           if params[:intl] == "0"
            redirect_to "/home#step-deposit"
           else
            redirect_to "/home#step-visa"
           end
        end  
      end

    # if params[:znum]
    #   #redirect for admin proxy
    #   redirect_to "/home?znum=#{params[:znum]}#step-verify"
    # else
    #   #redirect for student
    #   redirect_to "/home#step-verify"
    # end

  end

end