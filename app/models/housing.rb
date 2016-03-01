class Housing < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="tblStudentApplications"

	establish_connection(:housing)

	def self.get_housing_deposit(id)
			get = connection.exec_query("SELECT  tblStudentApplications.deposit_received FROM  tblStudentApplications INNER JOIN  tblStudents ON tblStudentApplications.StudentID = tblStudents.StudentID WHERE StudentNumber = #{connection.quote(id)} AND tblStudentApplications.deposit_received is not null")
	end

	def self.get_housing_exemption(id)
		get = connection.exec_query("SELECT studentnumber, firstname, lastname, field100, TIMEFRAMENUMERICCODE FROM [TheHousingDirector].[dbo].[VWTHDSTUDENTS] WHERE FIELD100 IS NOT NULL AND STUDENTNUMBER = #{connection.quote(id)}")
	end

	def self.get_meal_plan(id)
		get = connection.exec_query("SELECT DISTINCT TBLSTUDENTDININGPLANS.STUDENTDININGPLANID, StudentNumber, TBLDININGPLANSALL.DINING_PLAN
										FROM ((((TBLSTUDENTS LEFT JOIN tblStudentTimeFrames ON tblStudents.StudentID = tblStudentTimeFrames.StudentID) LEFT JOIN tblTimeFrame ON tblStudentTimeFrames.TimeFrameID = tblTimeFrame.TimeFrameID) LEFT JOIN (SELECT tblStudentDiningPlans.* from tblStudentDiningPlans where StartDate <={d '2016-12-15'} AND (EndDate >={d '2016-08-18'})) TBLSTUDENTDININGPLANS ON (tblStudentTimeFrames.StudentID = tblStudentDiningPlans.StudentID AND tblStudentTimeFrames.TimeFrameID = tblStudentDiningPlans.TimeFrameID)) LEFT JOIN TBLDININGPLANSALL ON tblStudentDiningPlans.DiningPlanID = TBLDININGPLANSALL.DINING_PLAN_ID) LEFT JOIN qryApplication ON tblStudentTimeFrames.StudentID = qryApplication.StudentID AND qryApplication.TimeFrameID = tblStudentTimeFrames.TimeFrameID  
										WHERE (  TBLDININGPLANSALL.DINING_PLAN IS NOT NULL   AND  qryApplication.APP_CANCELED IS NULL   AND  qryApplication.APP_RECEIVED IS NOT NULL  ) AND  tblTimeFrame.TIMEFRAME = 'FALL 16'
										AND StudentNumber = #{connection.quote(id)}")
	end

end