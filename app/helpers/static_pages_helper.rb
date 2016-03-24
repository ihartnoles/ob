module StaticPagesHelper
  
  
	def orientation_status(znum)
    	output = Faudw.orientation_status(znum)

    	if output.count > 0
    	   output.each do |o| 

         if !o.nil?
  	    	 if o['attended'] == 'Yes'
  	    	 	 tmp =  "You have attended an orientation session (#{o['sessiontitle']}) on #{o['sessiondate']}. You have completed this requirement!"
  	    	 
           elsif o['attended'] == 'No' && !o['sessiondate'].nil?
             tmp = "You have signed up for an orientation session (#{o['sessiontitle']}) on #{o['sessiondate']}. You must attend and complete orientation. "
           else
  	    	 	 tmp =  "You have NOT attended an orientation session yet. You must attend and complete orientation. "
  	    	 end

  	    	 return tmp
         else

          return "Our records indicate you have not yet attended an Orienation session. <br><br><a href='http://www.fau.edu/orientation/' class='btn btn-danger' onclick='window.open(this.href, \"orientation\",\"left=20,top=20,width=500,height=500,toolbar=1,resizable=1, scrollbars=1\"); return false;' >Sign-up for Orientation Now</a> <br> Also, please note orientation statuses are updated once daily. It is possible that your status is in the process of being updated.".html_safe

         end
      end
      	 else
      	 	return "Our records indicate you have not yet attended an Orienation session. <br><br><a href='http://www.fau.edu/orientation/' class='btn btn-danger' onclick='window.open(this.href, \"orientation\",\"left=20,top=20,width=500,height=500,toolbar=1,resizable=1, scrollbars=1\"); return false;'>Sign-up for Orientation Now</a> <br> Also, please note orientation statuses are updated once daily. It is possible that your status is in the process of being updated.".html_safe
      	 end        
  	end


     def aleks_status(znum,netid)
      output = Banner.aleks_status(znum)

      if output.count > 0
        output.each do |o| 

         if o['aleks_taken'] == 'Y' 
           @score = number_to_human(o['aleks_score'].to_i.round(2))
           tmp =  "You have taken ALEKS! Your ALEKS score is #{@score}%"
         else
           tmp =  "You have NOT taken ALEKS yet. <br> You must complete this requirement. <br><br><a id='aleks' class='btn btn-danger' title='ALEKS Sign-up' href='https://secure.aleks.com/fau/?znumber=#{znum}&myfau_username=#{netid}' onclick='window.open(this.href, \"aleks\",\"left=20,top=20,width=500,height=500,toolbar=1,resizable=1, scrollbars=1\">Sign-Up for ALEKS Now</a> <br> <a title='FAU Aleks' href='https://www.fau.edu/uas/pdf/ALEKS.pdf' target='_blank'>[More Information]</a>"
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
                
               if !o['acceptdate'].nil?
                 status = "accepted"
               end

               if !o['rpratrm_decline_date'].nil?
                 status = "declined"
               end

               if !o['rpratrm_offer_amt'].nil?
                  amount =  o['rpratrm_offer_amt']
               end

               if !o['rpratrm_decline_amt'].nil?
                  amount =  o['rpratrm_decline_amt']
               end

               tmp <<  "<tr><td>#{o['rfrbase_fund_title']}</td><td>#{o['term']} #{o['year']}</td><td>#{number_to_currency(amount)}</td><td>#{o['offerdate']}</td><td>#{status}</td></tr>"
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


      def fin_aid_docs(znum,term)
      output = Banner.fin_aid_docs(znum)

      tmp = ''
      doc_status = ''

      if output.count > 0
        output.each do |o| 
             if !o.nil?

               case o['rrrareq_sat_ind']
                 when 'Y'
                    doc_status = "<img src='/assets/Check_8x8.png' alt=''>".html_safe
                 when 'N'
                    doc_status = "<img src='/assets/Delete_8x8.png' alt='' >".html_safe
                 else
                    doc_status = "undetermined"
                end

              if term == 'Summer'
                # need to update the last status to reflect summer data
                 tmp <<  "<tr><td>#{o['rtvtreq_long_desc']} - #{o['finaidyear']}</td><td align='center'>#{doc_status}</td><td>#{doc_status}</td></tr>"
              else
                 tmp <<  "<tr><td>#{o['rtvtreq_long_desc']} - #{o['finaidyear']}</td><td align='center'>#{doc_status}</td></tr>"
              end 
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

         
         if !o['SSBSECT_CRSE_TITLE'].nil?
           course = o['SSBSECT_CRSE_TITLE']
         else
           course = o['SCBCRSE_TITLE']
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
           tmp =  "You have NOT completed OARS. <br><br> <a id='oars' class='btn btn-danger' title='OARS information' href='https://oars.fau.edu/login/login' >Sign Up for OARS Now</a>"
         end
	    	 

	    	 return tmp.html_safe

      	   end
  	 	else
  	 		return "You have NOT completed OARS. <br><br> <a id='oars' class='btn btn-danger' title='OARS information' href='https://oars.fau.edu/login/login' >Sign Up for OARS Now</a>".html_safe
  	 	end 
  	 end


     def get_immunization_status(znum)
      output = Banner.immunization_status(znum)

      tmp = ''

      if output.count > 0
        output.each do |o| 


         if o['im_exists'] == 'Y' && o['sprhold_hldd_code'] == 'IM' 
          tmp <<  "You need to make sure your immunization records have been submitted and approved. <br><br> <a id='immune' class='btn btn-danger' title='FAU Immunization Guidelines' href='http://www.fau.edu/shs/info_forms/immunizations.php' target='_blank'> Review immunization requirements here </a>"                               
         else           
          tmp <<  "Your immunization records have been submitted and approved.  Thank you!"  
         end
         
         return tmp.html_safe

        end
      else
        tmp =  "You need to make sure your immunization records have been submitted and approved. <br><br> <a id='immune' class='btn btn-danger' title='FAU Immunization Guidelines' href='http://www.fau.edu/shs/info_forms/immunizations.php' target='_blank'> Review immunization requirements  here </a>"
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
          return "Residency status pending <br> For additional information please see <a href='http://www.fau.edu/registrar/residency/index.php' target='_blank'>Florida Residency Guidelines</a>".html_safe
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
           tmp =  "Your tuition deposit has NOT been paid yet!  <br> You cannot continue until you've paid. <br> <br>           
               <a id='tuitionlink' class='btn btn-danger' href='https://sctformsalt.fau.edu:8484/ssomanager/c/SSB?pkg=wsak_touchnet.p_touchnet_link' target='_blank'>Pay Your Tuition Deposit Now</a>
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
          return "<span class='badge badge-warning'>bypassed <i class='fa fa-asterisk'></i></span>".html_safe
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
           tmp =  "Our records indicate you have made a housing deposit. <br> Your housing deposit was received on #{o['deposit_received'].strftime('%x')}."
         else
           tmp =  "Your housing deposit has NOT been paid yet!  <br><br>            
               <a id='housing' class='btn btn-danger' title='FAU Housing' href='https://talon.fau.edu/sso/housing' target='_blank'>Pay Your Housing Deposit Now</a>"
         end
         
         return tmp.html_safe

         end
      else
        return "Your housing deposit has NOT been paid yet!  <br><br>            
               <a id='housing' class='btn btn-danger' title='FAU Housing' href='https://talon.fau.edu/sso/housing' target='_blank'>Pay Your Housing Deposit Now</a>".html_safe
      end 
     end
end