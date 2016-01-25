class FticModulesAvailable < ActiveRecord::Base

      #attr_accessible :znumber, :netid, :f_name, :l_name, :welcome, :deposit, :account, :communication, :immunization, :finaid, :housingfee, :residency,
      #            :housingmealplan, :aleks, :oars, :learning_comm, :orientation, :registration, :emergency, :faualert, :owlcard, :bookadvance, :tuition,
      #            :vehiclereg, :isactive

	def self.sync
      @Bannerstuds = Banner.find_newstudents

      @Bannerstuds.each do | bs |
        if FticModulesAvailable.find_by_znumber(bs['z_number']).nil? 
         newstudent = FticModulesAvailable.new
         newstudent.znumber = bs['z_number']
         newstudent.netid   = bs['gobtpac_external_user']
         newstudent.f_name = bs['f_name']
         newstudent.l_name = bs['l_name']
         newstudent.welcome = 1
         newstudent.deposit = 1
         newstudent.account = 0
         newstudent.communication = 0
         newstudent.immunization = 0
         newstudent.finaid = 0
         newstudent.housingfee = 0
         newstudent.residency = 0
         newstudent.housingmealplan = 0
         newstudent.aleks = 0
         newstudent.oars = 0
         newstudent.learning_comm = 0
         newstudent.orientation = 0
         newstudent.registration = 0
         newstudent.emergency = 0
         newstudent.faualert = 0
         newstudent.owlcard = 0
         newstudent.bookadvance = 0
         newstudent.tution = 0
         newstudent.vehiclereg = 0 
         newstudent.isactive = 0
         
         if bs['int_student'] == 'Y'
          newstudent.isInternational = 1
         else
          newstudent.isInternational = 0
         end

         newstudent.intl_medical = 0
         newstudent.intl_visa = 0
         newstudent.intl_orientation = 0
         newstudent.save(validate: false)   
        else
         student = FticModulesAvailable.find_by_znumber(bs['z_number'])       
         student.update_attributes(
          :netid => bs['gobtpac_external_user'],
          :znumber => bs['z_number'],
          :f_name => bs['f_name'],
          :l_name => bs['l_name'],
          :isInternational => bs['int_student']
         ) 
        end

      end

  end

end
