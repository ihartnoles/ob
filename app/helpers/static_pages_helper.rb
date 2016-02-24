module StaticPagesHelper
  
  
	def orientation_status(znum)
    	output = Faudw.orientation_status(znum)

    	if output.count > 0
    	   output.each do |o| 

         if !o.nil?
  	    	 if o['attended'] == 'Yes'
  	    	 	 tmp =  "You have attended an orientation session on #{o['sessiondate']}. You have completed this requirement!"
  	    	 else
  	    	 	 tmp =  "You have NOT attended an orientation session yet. You must attend orientation and complete orientation. "
  	    	 end

  	    	 return tmp
         else

          return "Orienation status pending"

         end
      end
      	 else
      	 	return "Orienation status pending"
      	 end        
  	end


     def aleks_status(znum)
      output = Banner.aleks_status(znum)

      if output.count > 0
        output.each do |o| 

         if o['aleks_taken'] == 'Y' 
           tmp =  "You have taken ALEKS! Congrats!"
         else
           tmp =  "You have NOT taken ALEKS yet. <br> You must complete this requirement. <a id='aleks' title='ALEKS Sign-up' href='https://secure.aleks.com/fau/?znumber=#{znum}&myfau_username=sisma2015' target='_blank'>[Aleks Sign-up]</a> <br> <a title='FAU Aleks' href='https://www.fau.edu/uas/pdf/ALEKS.pdf' target='_blank'>[More Information]</a>"
         end

         return tmp.html_safe

           end
      else
        return "ALEKS status pending"
      end 
     end


     def fin_aid_awards(znum)
      output = Banner.fin_aid_awards(znum)

      tmp = ''
      doc_status = ''

      if output.count > 0
        output.each do |o| 
             if !o.nil?              

               tmp <<  "<tr><td>#{o['rfrbase_fund_title']}</td><td>#{o['term']} #{o['year']}</td><td>#{number_to_currency(o['rpratrm_offer_amt'])}</td><td>#{o['offerdate']}</td><td>#{o['acceptdate']}</td></tr>"
             else
               tmp =  "<tr><td colspan='4'>You DO NOT have award information on file.</td></tr>"
             end        
        end

           return tmp.html_safe

      else
         tmp =  "<tr><td colspan='4'>You DO NOT have award information on file.</td></tr>"
       return tmp.html_safe
      end 
     end


      def fin_aid_docs(znum)
      output = Banner.fin_aid_docs(znum)

      tmp = ''
      doc_status = ''

      if output.count > 0
        output.each do |o| 
             if !o.nil?

               case o['rrrareq_sat_ind']
                 when 'Y'
                    doc_status = "received"
                 when 'N'
                    doc_status = "not received"
                 else
                    doc_status = "undetermined"
                end

               tmp <<  "<tr><td>#{o['rtvtreq_long_desc']}</td><td>#{o['finaidyear']}</td><td>#{doc_status}</td></tr>"
             else
               tmp =  "<tr><td>You DO NOT have FAFSA information on file.</td></tr>"
             end        
        end

           return tmp.html_safe

      else
         tmp =  "<tr><td>You DO NOT have FAFSA information on file.</td></tr>"
       return tmp.html_safe
      end 
     end


     def registered_hours(znum)
      output = Banner.registered_hours(znum)

      tmp = ''

      if output.count > 0
        output.each do |o| 

        this_term  = o['sfrstcr_term_code']

         case this_term[4..5]
           when '01'
              term_value = "Spring"
           when '08'
              term_value = "Fall"
           else
              term_value = "Summer"
          end


         if !o.nil? 
           tmp <<  "<tr><td>#{o['sfrstcr_crn']}</td><td>#{o['scbcrse_title']}</td><td>#{o['sfrstcr_credit_hr']}</td><td>#{term_value} #{this_term[0..3]}</td></tr>"
         else
           tmp =  "<tr><td colspan='4' align='center'>You are not registered for enough credit hours!</td></tr>"
         end       

        end

          

      else
         tmp =  "<tr><td colspan='4' align='center' >No class registration information on file.</td></tr>"
      end 

      return tmp.html_safe

     end


     def total_hours(znum)

        output = Banner.total_hours(znum)

        if output.count > 0
          
          output.each do |o| 
             if o['sfrstcr_credit_hr'] >= 12
              
              return true
             
             else
             
              return false

             end
          end

        else
          return false
        end

     end


  	 def oars_status(znum)
  	 	output = Faudw.oars_status(znum)

  	 	if output.count > 0
  	 		output.each do |o| 

         if !o.nil?
           tmp =  "You have taken OARS for #{o['semester_desc']}! Great work!"
         else
           tmp =  "You have NOT completed OARS. <a id='oars' title='OARS information' href='https://oars.fau.edu/login/login' target='_blank'>[More Information]</a>"
         end
	    	 

	    	 return tmp.html_safe

      	   end
  	 	else
  	 		return "OARS status pending"
  	 	end 
  	 end


     def get_immunization_status(znum)
      output = Banner.immunization_status(znum)

      tmp = ''

      if output.count > 0
        output.each do |o| 

          # puts YAML::dump('begin immunization status')
          # puts YAML::dump(o)

         if o['imm_hold_flg'] == 'Y' 
           tmp <<  "You have an immunization hold! <br> You need to make sure your immunization records are up to date. <a id='immune' title='FAU Immunization Guidelines' href='http://www.fau.edu/shs/info_forms/immunizations.php' target='_blank'>[More Information]</a>"           
         else
           tmp =  "Your immunization records are up to date!  Good job!"
         end
         
         return tmp.html_safe

        end
      else
        tmp = " You need to make sure your immunization records are up to date. <br> <a id='immune' title='FAU Immunization Guidelines' href='http://www.fau.edu/shs/info_forms/immunizations.php' target='_blank'>[More Information]</a>"
        return tmp.html_safe
      end 
     end


     def get_residency_status(znum)
       output = Banner.residency_status(znum)

      
        if output.count > 0
          output.each do |o| 
             if o['sgbstdn_resd_code'].include?('T') || o['sgbstdn_resd_code'].include?('F') || o['sgbstdn_resd_code'].include?('R') || o['sgbstdn_resd_code'].include?('O')
               #let them know they are classified as a resident
               tmp =  "Great! You are classified as a FLORIDA RESIDENT! <br> Because of this classification you will pay $518.55 <i>LESS</i> per credit hour than non-residents!"
             else

               if o['spraddr_stat_code'] == 'FL'
                #alert the FL resident that they might be incorrectly classified
                tmp =  "You have a Florida residential address but you are currently classified as a NON-RESIDENT. <br>  Because of this classification You will pay $518.55 more per credit hour than residents! <br> Please see <a href='http://www.fau.edu/registrar/residency/index.php' target='_blank'>Florida Residency Guidelines</a>"
               else
                #don't taunt the NON-RESIDENTS with the cost of tution!
                tmp =  "You are classified as a NON-RESIDENT."
               end
             end
             return tmp.html_safe
           end
        else
          return "Residency status pending"
        end 
     end



  	 def get_fullname(znum)
  	 	 output = Banner.fullname(znum)

  	 	 # if !output.nil?
  	 	 # 	return output
  	 	 # else
  	 	 # 	return 'unknown'
  	 	 # end

       # puts YAML::dump(' *** BEGIN FULLNAME static_pages_helper  ***')      
       # puts YAML::dump(session[:cas_user])
       # puts YAML::dump(output)
       # puts YAML::dump(' *** MIDDLE FULLNAME static_pages_helper  ***') 

       if output.count >= 0
        output.each do |o| 

         # puts YAML::dump(o['fullname'])

         if !o.nil?
           tmp =  "#{o['fullname']}"
         else
           tmp =  ""
         end
         return tmp

          # puts YAML::dump(' *** END FULLNAME static_pages_helper  ***')
        end

      else
        return "UNKNOWN"
      end 
    end

     def get_tuition_deposit_status(znum)
      output = Banner.tuition_deposit_status(znum)

      if output.count > 0
        output.each do |o| 

         if o['sarchkl_admr_code'] == 'TUTD' && !o['sarchkl_receive_date'].nil?
           tmp =  "Your tuition deposit was paid on #{o['sarchkl_receive_date'].strftime('%x')}."
         else
           tmp =  "Your tuition deposit has NOT been paid yet!  <br>            
               <a id='tuitionlink' href='https://sctformsalt.fau.edu:8484/ssomanager/c/SSB?pkg=wsak_touchnet.p_touchnet_link' target='_blank'>[Pay Your Tuition Deposit Now]</a>
              "
         end
         

         return tmp.html_safe

         end
      else
        return "Tuition deposit status is pending."
      end 
     end

  	 def get_statusicon(available,completed,bypass)

       if bypass == 1
          return "bypassed <i class='fa fa-asterisk'></i>".html_safe
       else
         	case 
      	 		when available == 0 && ( completed == 0 || completed.nil?)
      	 			return "<span class='badge badge-important'>locked <i class='fa fa-ban'></i></span>".html_safe
      	 		when available == 1 && ( completed == 0 || completed.nil?)
      	 			return " <span class='badge badge-important label label-danger'>incomplete <i class='fa fa-times'></i></span>".html_safe
      	 		when  completed == 1  	 			
      	 			return "<span class='badge badge-important label label-success'>completed <i class='fa fa-check'></i></span>".html_safe
           
      	 	else
      	 		return "N/A <i class='fa fa-ban'></i>".html_safe
      	 	end
       end

  	 end

    

     def get_housing_deposit(znum)
      output = Housing.get_housing_deposit(znum)

      if output.count > 0
        output.each do |o| 

         if !o['deposit_received'].nil?
           tmp =  "Our records indicated you have made a housing deposit. <br> Your housing deposit was received on #{o['deposit_received'].strftime('%x')}."
         else
           tmp =  "Your housing deposit has NOT been paid yet!  <br>            
               <a id='housing' title='FAU Housing' href='https://talon.fau.edu/sso/housing' target='_blank'>[Sign up here]</a>"
         end
         
         return tmp.html_safe

         end
      else
        return "Your housing deposit has NOT been paid yet!  <br>            
               <a id='housing' title='FAU Housing' href='https://talon.fau.edu/sso/housing' target='_blank'>[Sign up here]</a>".html_safe
      end 
     end
end