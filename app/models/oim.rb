class Oim < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="usr"

	establish_connection(:oimdev)


	#BEGIN: QUERIES TO dev_oim.usr
	def self.accountstatus_by_netid(id)
		 	get = connection.exec_query("select usr_udf_accountclaimstatus as status from dev_oim.usr where usr_login = #{connection.quote(id)}")
	end

end