class Faudw < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="DWPROD.OARS_STUDENTS"

	 establish_connection(:faudw)

	def self.fullname(id)
		get = connection.exec_query("SELECT fname, lname, status_desc FROM DWPROD.OARS_STUDENTS WHERE ID=#{connection.quote(id)}")
	end


	def self.oars_status(id)
		get = connection.exec_query("SELECT fname, lname, semester_desc, oars_version, status_desc FROM DWPROD.OARS_STUDENTS WHERE ID=#{connection.quote(id)}")
	end

	def self.orientation_status(id)
		get = connection.exec_query("SELECT id, firstname, lastname studenttype, term_entry, sessiondate, attended FROM DWPROD.ORIENTATION_TRACKING WHERE ID=#{connection.quote(id)}")
	end

end