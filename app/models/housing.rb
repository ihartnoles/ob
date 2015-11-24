class Housing < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="tblStudentApplications"

	establish_connection(:housing)

	def self.get_housing_deposit(id)
			get = connection.exec_query("SELECT  tblStudentApplications.deposit_received FROM  tblStudentApplications INNER JOIN  tblStudents ON tblStudentApplications.StudentID = tblStudents.StudentID WHERE StudentNumber = #{connection.quote(id)}")
	end
end