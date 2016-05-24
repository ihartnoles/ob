class ReportsController < ApplicationController
  def reportone
  	
  	#@affiliates = Affiliate.where(:isfaculty => 0)
  	@students = Banner.ftic_base_report

    respond_to do |format|
          format.html 
          #format.xls  { response.headers['Content-Disposition'] = 'attachment; filename="onboardingreport_' +  Time.now.to_s + '.xls"' } 
    end

  end
end