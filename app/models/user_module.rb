class UserModule < ActiveRecord::Base
  attr_accessible :module, :module_id, :netid, :userid
  belongs_to :user
  belongs_to :module
end
