class ReportsController < ApplicationController
  def reportone
  	
  	authenticate_for_admin(session[:cas_user])

  	if @access == 1
	  	#@affiliates = Affiliate.where(:isfaculty => 0)
	  	@students = Banner.ftic_base_report

	    respond_to do |format|
	          format.html 
	          #format.xls  { response.headers['Content-Disposition'] = 'attachment; filename="onboardingreport_' +  Time.now.to_s + '.xls"' } 
	    end
	 else
        redirect_to unauthorized_path
     end

  end

  protected

   def authenticate_for_admin(netid)
      user = User.where(:netid => netid)
      if user.count == 0 #no info found
        @access = 0
      else
        @access = 1
      end       
   end 

end