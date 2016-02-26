# Load the rails application
require File.expand_path('../application', __FILE__)

#global logging method
def record_activity(note)
    @activity = ActivityLog.new
    @activity.netid = session[:cas_user]
    @activity.note = note
    @activity.browser = request.env['HTTP_USER_AGENT']
    @activity.ip_address = request.env['REMOTE_ADDR']
    @activity.controller = controller_name 
    @activity.action = action_name 
    @activity.params = params.inspect
    @activity.save
end


# Initialize the rails application
Ob::Application.initialize!

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://ssot.fau.edu/"  
)