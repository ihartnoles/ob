# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ob::Application.initialize!

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://cas1t.fau.edu/"  
)