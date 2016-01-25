module CommonStuff
  def update_ftic_verify_module(ftic_id,verify,znumber,netid)
    @modules_available = FticModulesAvailable.find(ftic_id)
    @modules_available.verify = verify
    @modules_available.deposit = 1 #unlock deposit
    @modules_available.save
    record_activity("Module Update | " + znumber + " | " + netid)

     # if params[:znum]
     #     redirect_to "/home?znum=#{params[:znum]}#step-deposit" #redirect to deposit
     # else
     #    redirect_to "/home#step-deposit"
     # end  
   
  end

end