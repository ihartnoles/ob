class Housing < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="tblStudentApplications"

	establish_connection(:housing)

	def self.get_housing_deposit(id)
			get = connection.exec_query("SELECT  tblStudentApplications.deposit_received FROM  tblStudentApplications INNER JOIN  tblStudents ON tblStudentApplications.StudentID = tblStudents.StudentID WHERE StudentNumber = #{connection.quote(id)}")
	end

	def self.get_housing_exemption(id)
		get = connection.exec_query("SELECT studentnumber, firstname, lastname, field100, TIMEFRAMENUMERICCODE FROM [TheHousingDirector].[dbo].[VWTHDSTUDENTS] WHERE FIELD100 IS NOT NULL AND STUDENTNUMBER = #{connection.quote(id)}")
	end

end