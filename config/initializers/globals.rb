case ENV['RAILS_ENV']
  when "development"
    USE_THIS_SERVER = "boc22webdev1.fau.edu"
  when "staging"
    USE_THIS_SERVER = ""    
  when "production"  
    USE_THIS_SERVER = ""     
end