class ActivityLogsController < ApplicationController

  def showlogs
  	 @table_label = "Activity Log for #{params[:netid]}"

  	 # like_keyword = "%#{@znum}%" 
     #  @logs = ActivityLog.select("netid,browser,ip_address,note,created_at").where("params LIKE ?", like_keyword)
     @logs = ActivityLog.select("netid,browser,ip_address,note,created_at").where(:netid => params[:netid])

     render layout: 'admin'
  end

end