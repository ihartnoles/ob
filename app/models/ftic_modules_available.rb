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
         newstudent.verify = 1
         newstudent.verifybypass = 0
         newstudent.deposit = 1
         newstudent.depositbypass = 0
         newstudent.account = 1
         newstudent.accountbypass = 0
         newstudent.communication = 1
         newstudent.communicationbypass = 0
         newstudent.depositbypass = 0
         newstudent.immunization = 1
         newstudent.immunizationbypass = 0
         newstudent.finaid = 1
         newstudent.finaidbypass = 0
         if bs['term'] == "Summer"
          newstudent.summer_finaid = 1
         else
          newstudent.summer_finaid = 0
         end
         newstudent.summer_finaidbypass = 0
         newstudent.housingfee = 0
         newstudent.housingfeebypass = 0
         newstudent.residency = 0
         newstudent.residencybypass = 0
         newstudent.housingmealplan = 0
         newstudent.housingmealplanbypass = 0
         newstudent.aleks = 0
         newstudent.aleksbypass = 0
         newstudent.oars = 0
         newstudent.oarsbypass = 0
         newstudent.learning_comm = 0
         newstudent.learning_commbypass = 0
         newstudent.orientation = 0
         newstudent.orientationbypass = 0
         newstudent.registration = 0
         newstudent.registrationbypass = 0
         newstudent.emergency = 0
         newstudent.emergencybypass = 0
         newstudent.faualert = 0
         newstudent.faualertbypass = 0
         newstudent.owlcard = 0
         newstudent.owlcardbypass = 0
         newstudent.bookadvance = 0
         newstudent.bookadvancebypass = 0
         newstudent.tution = 0
         newstudent.tuitionbypass = 0
         newstudent.vehiclereg = 0 
         newstudent.vehicleregbypass = 0
         newstudent.congrats = 0
         newstudent.isactive = 1
         
         if bs['int_student'] == "Y"
          newstudent.isInternational = 1
         else
          newstudent.isInternational = 0
         end


         newstudent.intl_medical = 0
         newstudent.intl_medical_bypass = 0
         newstudent.intl_visa = 0
         newstudent.intl_visa_bypass = 0
         newstudent.intl_orientation = 0
         newstudent.intl_orientation_bypass = 0
         newstudent.save(validate: false)   
        else
         student = FticModulesAvailable.find_by_znumber(bs['z_number'])     

         if bs['int_student'] == "Y"
          isInternational = 1
         else
          isInternational = 0
         end

         if bs['term'] == "Summer"
          summer_finaid = 1
         else
          summer_finaid = 0
         end

         if bs['sarchkl_admr_code'] == "TUTD" && !bs['sarchkl_receive_date'].nil?
            residency  = 1
            housingfee = 1
            aleks = 1
            orientation = 1
            learning_comm = 1
            tution = 1
            emergency = 1
            owlcard = 1
            bookadvance = 1
            immunization = 1
         else
            residency  = 0
            housingfee = 0
            aleks = 0
            orientation = 0
            learning_comm = 0
            tution = 0
            emergency = 0
            owlcard = 0
            bookadvance = 0
            immunization = 0
         end

        
         student.update_attributes(
          :netid => bs['gobtpac_external_user'],
          :znumber => bs['z_number'],
          :f_name => bs['f_name'],
          :l_name => bs['l_name'],
          :isInternational => isInternational,
          :communication => 1,
          :finaid => 1,
          :summer_finaid => summer_finaid,
          :residency  => residency,
          :housingfee => housingfee,
          :aleks => aleks,
          :orientation => orientation,
          :learning_comm => learning_comm,
          :tution => tution,
          :emergency => emergency,
          :owlcard => owlcard,
          :bookadvance => bookadvance,
          :immunization => immunization
         ) 
        end

      end

  end

end
