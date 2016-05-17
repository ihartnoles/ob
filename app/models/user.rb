class User < ActiveRecord::Base
  attr_accessible :module, :module_id, :access_level, :netid, :created_at, :updated_at
  #has_many :usermodules
end
