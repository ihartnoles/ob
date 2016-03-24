class Banner < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="BANINST1.AWS_ONBOARDING_MAIN_NEW"

	establish_connection(:bannertest)


	#BEGIN: QUERIES TO BANINST1.AWS_ONBOARDING_MAIN_NEW
		def self.find_student_by_netid(id)
		 	get = connection.exec_query("select distinct Z_NUMBER,  SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									      CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term , L_NAME, M_NAME, F_NAME, MAJOR_DESC, STREET_LINE1 , CITY, STATE, ZIP, street2_line1, city2, state2, zip2, GOBTPAC_EXTERNAL_USER, goremal_email_address  FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE GOBTPAC_EXTERNAL_USER=#{connection.quote(id)} AND rownum = 1")
		end

		def self.find_student_by_z(id)
		 	# get = connection.exec_query("select distinct Z_NUMBER,  SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
				# 					      CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
				# 					             WHEN '01' THEN 'Spring'
				# 					             WHEN '08' THEN 'Fall'
				# 					             WHEN '05' THEN 'Summer'
				# 					          ELSE ''
				# 					      END as term , L_NAME, M_NAME, F_NAME, MAJOR_DESC, SPRADDR_STREET_LINE1 ,SPRADDR_CITY ,SPRADDR_STAT_CODE, SPRADDR_ZIP, GOBTPAC_EXTERNAL_USER, goremal_email_address  FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")

				get = connection.exec_query("select distinct Z_NUMBER,  SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									      CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term , L_NAME, M_NAME, F_NAME, MAJOR_DESC, STREET_LINE1 , CITY, STATE, ZIP, street2_line1, city2, state2, zip2, GOBTPAC_EXTERNAL_USER, goremal_email_address  FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		def self.find_student_zip_by_z(id)
		 	get = connection.exec_query("select distinct SUBSTR( ZIP, 1 , 5 ) as ZIP FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		# def self.age_calculation(netid)
		# 	get = connection.exec_query("select floor(months_between(SYSDATE, SPBPERS_BIRTH_DATE) /12) as AGE FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(netid)} AND rownum = 1")
		# end

		def self.additional_housing_reqs(id)
			get = connection.exec_query("select CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term , floor(months_between(SYSDATE, SPBPERS_BIRTH_DATE) /12) as AGE, SPBPERS_MRTL_CODE, WHC_STUDENT FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		def self.fullname(id)
		 	get = connection.exec_query("select distinct CONCAT(CONCAT(F_NAME, ' '), L_NAME) as fullname  FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		def self.find_newstudents
		 	get = connection.exec_query("select distinct Z_NUMBER, L_NAME, F_NAME, GOBTPAC_EXTERNAL_USER, INT_STUDENT from BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE SARADAP_STYP_CODE in ('B','E')")
		end


		def self.aleks_status(id)
			get = connection.exec_query("SELECT aleks_taken, aleks_score FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)}")
		end

		def self.tuition_deposit_status(id)
			get = connection.exec_query("SELECT sarchkl_admr_code, sarchkl_receive_date FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)}")
		end

		def self.immunization_status(id)
			get = connection.exec_query("SELECT sprhold_hldd_code, im_exists from BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)}")
		end


		# def self.account_claimed_status(id)
		# 	get = connection.exec_query("SELECT spremrg_first_name, spremrg_last_name FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)}")
		# end

		#BEGIN: a test to consolidate aleks tution and account claim status
			# presence of gobtpac_external_user means they have their netid;
			# aleks_taken = self explanatory
			# sarchkl_admr_code == TUTD -> deposit has been made
			# spremrg fields = emergency contact info on file
		def self.get_multistatus(id)
			# get = connection.exec_query("SELECT GOBTPAC_EXTERNAL_USER, L_NAME, F_NAME,
			# 							 SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
			# 						      CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
			# 						             WHEN '01' THEN 'Spring'
			# 						             WHEN '08' THEN 'Fall'
			# 						             WHEN '05' THEN 'Summer'
			# 						          ELSE ''
			# 						      END as term ,
			# 							  im_exists, sprhold_hldd_code,										  									      
			# 						      aleks_taken, sarchkl_admr_code, sarchkl_receive_date, sarchkl_receive_date, sarchkl_admr_code, CONCAT(CONCAT(spremrg_first_name,' '),spremrg_last_name) as spremrg_contact_name, 
			# 						      spremrg_street_line1, spremrg_city, spremrg_stat_code, spremrg_natn_code, spremrg_zip, sprtele_phone_area, sprtele_phone_number,spremrg_phone_area, spremrg_phone_number, 
			# 						      gwrr911_phone_area, gwrr911_phone_number, gwrr911_tele_code, gwrr911_text_capable,
			# 						      whc_student, int_student, goremal_email_address 

			# 						      FROM BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER=#{connection.quote(id)}")

			get = connection.exec_query("SELECT GOBTPAC_EXTERNAL_USER, L_NAME, F_NAME,
										 SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									      CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term ,
										  im_exists, sprhold_hldd_code,										  									      
									      aleks_taken, aleks_score, sarchkl_admr_code, sarchkl_receive_date, sarchkl_receive_date, CONCAT(CONCAT(spremrg_first_name,' '),spremrg_last_name) as spremrg_contact_name, 
									      spremrg_street_line1, spremrg_city, spremrg_stat_code, spremrg_natn_code, spremrg_zip, phone_area, phone_number,spremrg_phone_area, spremrg_phone_number, 
									      gwrr911_phone_area, gwrr911_phone_number, gwrr911_tele_code, gwrr911_text_capable,
									      whc_student, int_student, goremal_email_address 

									      FROM BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)}")

		end
		#END: a test to consolidate aleks tution and account claim status


	#END: QUERIES TO BANINST1.AWS_ONBOARDING_MAIN_NEW
	

	#BEGIN: QUERIES TO BANINST1.AWS_ONBOARDING_COURSE_REG

		def self.registered_hours(id)
			#get = connection.exec_query("SELECT Z_NUMBER, SFRSTCR_TERM_CODE, SUM(sfrstcr_credit_hr) as sfrstcr_credit_hr from BANINST1.AWS_ONBOARDING_COURSE_REG WHERE Z_NUMBER=#{connection.quote(id)} AND sfrstcr_credit_hr >0 GROUP BY  Z_NUMBER, SFRSTCR_TERM_CODE, sfrstcr_credit_hr")
			get = connection.exec_query("SELECT Z_NUMBER, SFRSTCR_TERM_CODE, SFRSTCR_CRN, SSBSECT_CRSE_TITLE, SCBCRSE_TITLE, sfrstcr_credit_hr from BANINST1.AWS_ONBOARDING_COURSE_REG_NEW WHERE Z_NUMBER=#{connection.quote(id)} ORDER BY SFRSTCR_TERM_CODE")
		end


		def self.total_hours(id)
			get = connection.exec_query("SELECT  CASE SUBSTR(SFRSTCR_TERM_CODE, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term, SUM(sfrstcr_credit_hr) as totalhours from BANINST1.AWS_ONBOARDING_COURSE_REG_NEW WHERE Z_NUMBER=#{connection.quote(id)} GROUP BY SFRSTCR_TERM_CODE")
		end


	#END:QUERIES TO BANINST1.AWS_ONBOARDING_COURSE_REG


	#BEGIN: QUERIES TO BANINST1.AWS_ONBOARDING_FINAID

		def self.fin_aid_docs(id)
			#get = connection.exec_query("SELECT fafsa_flg, rtvtreq_long_desc, rrrareq_sat_ind  from BANINST1.AWS_ONBOARDING_FINAID WHERE Z_NUMBER=#{connection.quote(id)}")
			get = connection.exec_query("SELECT fafsa_flg, rtvtreq_long_desc, rrrareq_sat_ind, SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									      CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term ,

									      RORSTAT_AIDY_CODE,

									     CASE RORSTAT_AIDY_CODE 
									     	WHEN '1617' THEN '2016-2017'
									     	WHEN '1516' THEN '2015-2016'
									     	WHEN '1415' THEN '2014-2015'

									     END as finaidyear, 
									     rtvtreq_code, 
									     rorstat_all_req_comp_date
									     from BANINST1.AWS_ONBOARDING_FINAID_REQDOC_N WHERE Z_NUMBER=#{connection.quote(id)}
									     ORDER BY finaidyear desc , rtvtreq_long_desc asc")
		end

		def self.fin_aid_checkboxes(id)
			get = connection.exec_query("SELECT rtvtreq_code, rrrareq_sat_ind, rorstat_pckg_comp_date, rorstat_all_req_comp_date from BANINST1.AWS_ONBOARDING_FINAID_REQDOC_N WHERE Z_NUMBER=#{connection.quote(id)} and rtvtreq_code in ('TERMS','ISIR')")
		end

		def self.fin_aid_acceptance(id)
			get = connection.exec_query("SELECT rpratrm_accept_date, rpratrm_period from BANINST1.AWS_ONBOARDING_FINAID_AWARDS_N WHERE Z_NUMBER=#{connection.quote(id)}")
		end
	
		def self.residency_status(id)
			get = connection.exec_query("SELECT SGBSTDN_RESD_CODE, STATE from BANINST1.AWS_ONBOARDING_MAIN_NEW WHERE Z_NUMBER=#{connection.quote(id)}")
		end

		def self.fin_aid_awards(id)
			get = connection.exec_query("SELECT RFRBASE_FUND_TITLE, RPRATRM_PERIOD, 
												SUBSTR( RPRATRM_PERIOD, 1 , 4 ) as year,
   											  CASE SUBSTR(RPRATRM_PERIOD, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term,
									    RPRATRM_AIDY_CODE as finaidyear,
									    RPRATRM_OFFER_AMT, RPRATRM_DECLINE_AMT,
									    TO_CHAR(RPRATRM_OFFER_DATE,'MM/DD/YYYY') as offerdate, TO_CHAR(RPRATRM_ACCEPT_DATE,'MM/DD/YYYY') as acceptdate, 
  								        rpratrm_decline_date
									    FROM BANINST1.AWS_ONBOARDING_FINAID_AWARDS_N
									    WHERE Z_NUMBER=#{connection.quote(id)} 
									    ORDER BY RFRBASE_FUND_TITLE ASC")
		end

	#END:QUERIES TO BANINST1.AWS_ONBOARDING_FINAID


	# def self.oars_status(id)
	# 	get = connection.exec_query("SELECT fname, lname, semester_desc, oars_version, status_desc FROM DWPROD.OARS_STUDENTS WHERE ID=#{connection.quote(id)}")
	# end

	# def self.orientation_status(id)
	# 	get = connection.exec_query("SELECT id, firstname, lastname studenttype, term_entry, sessiondate, attended FROM DWPROD.ORIENTATION_TRACKING WHERE ID=#{connection.quote(id)}")
	# end

end