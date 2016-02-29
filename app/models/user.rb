class User < ActiveRecord::Base
  attr_accessible :module, :module_id, :access_level, :netid
end
