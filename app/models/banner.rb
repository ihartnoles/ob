class Banner < ActiveRecord::Base

	self.abstract_class = true
	self.table_name="BANINST1.AWS_ONBOARDING_MAIN"


	#establish_connection(:bannerprod)
	#establish_connection(:bannertest)

	establish_connection(ENV['banner_db_source'])


	#BEGIN: QUERIES TO BANINST1.AWS_ONBOARDING_MAIN
		def self.find_student_by_netid(id)
		 	get = connection.exec_query("select A.Z_NUMBER,  SUBSTR( A.SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									      CASE SUBSTR(A.SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term , A.L_NAME, A.M_NAME, A.F_NAME, A.MAJOR_DESC,A.GOBTPAC_EXTERNAL_USER, A.goremal_email_address, B.STREET_LINE1 , B.CITY, B.STATE, B.ZIP, B.street2_line1, B.city2, B.state2, B.zip2 
									      FROM BANINST1.AWS_ONBOARDING_MAIN A
                        				  LEFT JOIN BANINST1.AWS_ONBOARDING_ADDRESS B ON B.SGBSTDN_PIDM = A.SGBSTDN_PIDM WHERE A.GOBTPAC_EXTERNAL_USER=#{connection.quote(id)}")
		end

		def self.find_student_by_z(id)
		 	get = connection.exec_query("select A.Z_NUMBER,  SUBSTR( A.SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									      CASE SUBSTR(A.SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term , A.L_NAME, A.M_NAME, A.F_NAME, A.MAJOR_DESC,A.GOBTPAC_EXTERNAL_USER, A.goremal_email_address, B.STREET_LINE1 , B.CITY, B.STATE, B.ZIP, B.street2_line1, B.city2, B.state2, B.zip2 
									      FROM BANINST1.AWS_ONBOARDING_MAIN A
                        				  LEFT JOIN BANINST1.AWS_ONBOARDING_ADDRESS B ON B.SGBSTDN_PIDM = A.SGBSTDN_PIDM WHERE A.Z_NUMBER=#{connection.quote(id)}")
		end

		def self.find_student_zip_by_z(id)
		 	get = connection.exec_query("select SUBSTR( ZIP, 1 , 5 ) as ZIP FROM BANINST1.AWS_ONBOARDING_ADDRESS WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		# def self.age_calculation(netid)
		# 	get = connection.exec_query("select floor(months_between(SYSDATE, SPBPERS_BIRTH_DATE) /12) as AGE FROM BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER=#{connection.quote(netid)} AND rownum = 1")
		# end

		def self.additional_housing_reqs(id)
			get = connection.exec_query("select CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term , floor(months_between(SYSDATE, SPBPERS_BIRTH_DATE) /12) as AGE, SPBPERS_MRTL_CODE, WHC_STUDENT FROM BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		def self.fullname(id)
		 	get = connection.exec_query("select distinct CONCAT(CONCAT(F_NAME, ' '), L_NAME) as fullname  FROM BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER=#{connection.quote(id)} AND rownum = 1")
		end

		def self.find_newstudents
		 	# get = connection.exec_query("select distinct Z_NUMBER, L_NAME, F_NAME, GOBTPAC_EXTERNAL_USER, INT_STUDENT, CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
				# 					             WHEN '01' THEN 'Spring'
				# 					             WHEN '08' THEN 'Fall'
				# 					             WHEN '05' THEN 'Summer'
				# 					          ELSE ''
				# 					      END as term  from BANINST1.AWS_ONBOARDING_MAIN WHERE SARADAP_STYP_CODE in ('B','E')")
			get = connection.exec_query("select distinct Z_NUMBER, L_NAME, F_NAME, GOBTPAC_EXTERNAL_USER, INT_STUDENT, CASE SUBSTR(SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term  from BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER in (
									      	'Z23376289',
											'Z23224442',
											'Z23395645',
											'Z23400138',
											'Z23392222',
											'Z23401275',
											'Z23394732',
											'Z23384783',
											'Z23364567',
											'Z23285084',
											'Z23397992',
											'Z23398302',
											'Z23394686',
											'Z23380590',
											'Z23385017',
											'Z23384949',
											'Z23381712',
											'Z23397279',
											'Z23392666',
											'Z23386767',
											'Z23381123',
											'Z23398392',
											'Z23398687',
											'Z23375788',
											'Z23393087',
											'Z23395991',
											'Z23382598',
											'Z23375887',
											'Z23403362',
											'Z23377145',
											'Z23395518',
											'Z23370442',
											'Z23394415',
											'Z23387482',
											'Z23381234',
											'Z23385384',
											'Z23397066',
											'Z23374969',
											'Z23393085',
											'Z23381155',
											'Z23371572',
											'Z23396770',
											'Z23384311',
											'Z23370711',
											'Z23392943',
											'Z23380341',
											'Z23386603',
											'Z23364463',
											'Z23391699',
											'Z23380216',
											'Z23382398',
											'Z23383509',
											'Z23362995',
											'Z23407746',
											'Z23407646',
											'Z23381081',
											'Z23404877',
											'Z23387535',
											'Z23406794',
											'Z23379224',
											'Z23403035',
											'Z23387143',
											'Z23388287',
											'Z23380788',
											'Z23385936',
											'Z23397510',
											'Z23399151',
											'Z23398433',
											'Z23395914',
											'Z23328476',
											'Z23394067',
											'Z23402644',
											'Z23402999',
											'Z23400694',
											'Z23398965',
											'Z23404650',
											'Z23401287',
											'Z23382616',
											'Z23400526',
											'Z23403101',
											'Z23378735',
											'Z23385330',
											'Z23379598',
											'Z23392485',
											'Z23405185',
											'Z23395538',
											'Z23392381',
											'Z23397527',
											'Z23373986',
											'Z23372949',
											'Z23394468',
											'Z23377847',
											'Z23397041',
											'Z23381455',
											'Z23387269',
											'Z23372453',
											'Z23386968',
											'Z23376235',
											'Z23384344',
											'Z23372143')")
		end

		def self.aleks_status(id)
			get = connection.exec_query("SELECT aleks_taken, aleks_score FROM BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER=#{connection.quote(id)}")
		end

		def self.tuition_deposit_status(id)
			get = connection.exec_query("SELECT sarchkl_admr_code, sarchkl_receive_date FROM BANINST1.AWS_ONBOARDING_ADDRESS WHERE Z_NUMBER=#{connection.quote(id)}")
		end

		def self.immunization_status(id)
			get = connection.exec_query("SELECT sprhold_hldd_code, im_exists from BANINST1.AWS_ONBOARDING_HOLD WHERE Z_NUMBER=#{connection.quote(id)} AND sprhold_hldd_code = 'IM'")
		end

		def self.orientation_status(id)
			get = connection.exec_query("SELECT sprhold_hldd_code, im_exists from BANINST1.AWS_ONBOARDING_HOLD WHERE Z_NUMBER=#{connection.quote(id)} AND sprhold_hldd_code IN ('OR','OA')")
		end

		def self.transfer_status(id)
			get = connection.exec_query("select distinct SGRSATT_ATTS_CODE, ATTS_DESC from BANINST1.AWS_ONBOARDING_ATTRB WHERE Z_NUMBER=#{connection.quote(id)}")
		end

		# def self.account_claimed_status(id)
		# 	get = connection.exec_query("SELECT spremrg_first_name, spremrg_last_name FROM BANINST1.AWS_ONBOARDING_MAIN WHERE Z_NUMBER=#{connection.quote(id)}")
		# end

		#BEGIN: a test to consolidate aleks tution and account claim status
			# presence of gobtpac_external_user means they have their netid;
			# aleks_taken = self explanatory
			# sarchkl_admr_code == TUTD -> deposit has been made
			# spremrg fields = emergency contact info on file
		def self.get_multistatus(id)
			get = connection.exec_query("SELECT A.GOBTPAC_EXTERNAL_USER, A.L_NAME, A.F_NAME,
									       SUBSTR( A.SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
									          CASE SUBSTR(A.SARADAP_TERM_CODE_ENTRY, 5 , 6 )
									                 WHEN '01' THEN 'Spring'
									                 WHEN '08' THEN 'Fall'
									                 WHEN '05' THEN 'Summer'
									              ELSE ''
									          END as term,										   		
									          A.whc_student, A.int_student, A.goremal_email_address, 
									          A.aleks_taken, A.aleks_score, B.sarchkl_admr_code, B.sarchkl_receive_date, B.sarchkl_receive_date, 
									          CONCAT(CONCAT(B.spremrg_first_name,' '),B.spremrg_last_name) as spremrg_contact_name, 
									          B.spremrg_street_line1, B.spremrg_city, B.spremrg_stat_code,B. spremrg_natn_code, B.spremrg_zip, B.phone_area,B. phone_number,B.spremrg_phone_area, B.spremrg_phone_number, 
									          B.gwrr911_phone_area, B.gwrr911_phone_number, B.gwrr911_tele_code, B.gwrr911_text_capable
									          --,C.im_exists
									          --, C.sprhold_hldd_code                        
									  FROM BANINST1.AWS_ONBOARDING_MAIN A
									  LEFT JOIN BANINST1.AWS_ONBOARDING_ADDRESS B ON B.SGBSTDN_PIDM = A.SGBSTDN_PIDM
									  --LEFT JOIN BANINST1.AWS_ONBOARDING_HOLD C ON C.SGBSTDN_PIDM = A.SGBSTDN_PIDM
									  WHERE A.Z_NUMBER=#{connection.quote(id)}")

		end
		#END: a test to consolidate aleks tution and account claim status

		def self.check_orientation_hold(id)
			get = connection.exec_query("SELECT SPRHOLD_HLDD_CODE FROM BANINST1.AWS_ONBOARDING_HOLD WHERE Z_NUMBER=#{connection.quote(id)} AND SPRHOLD_HLDD_CODE = 'OR' ")
		end
	#END: QUERIES TO BANINST1.AWS_ONBOARDING_MAIN
	

	#BEGIN: QUERIES TO BANINST1.AWS_ONBOARDING_COURSE_REG

		def self.registered_hours(id)
			#get = connection.exec_query("SELECT Z_NUMBER, SFRSTCR_TERM_CODE, SUM(sfrstcr_credit_hr) as sfrstcr_credit_hr from BANINST1.AWS_ONBOARDING_COURSE_REG WHERE Z_NUMBER=#{connection.quote(id)} AND sfrstcr_credit_hr >0 GROUP BY  Z_NUMBER, SFRSTCR_TERM_CODE, sfrstcr_credit_hr")
			get = connection.exec_query("SELECT Z_NUMBER, SFRSTCR_TERM_CODE, SFRSTCR_CRN, SSBSECT_CRSE_TITLE, SCBCRSE_TITLE, sfrstcr_credit_hr from BANINST1.AWS_ONBOARDING_COURSE_REG WHERE Z_NUMBER=#{connection.quote(id)} ORDER BY SFRSTCR_TERM_CODE")
		end


		def self.total_hours(id)
			get = connection.exec_query("SELECT  CASE SUBSTR(SFRSTCR_TERM_CODE, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term, SUM(sfrstcr_credit_hr) as totalhours from BANINST1.AWS_ONBOARDING_COURSE_REG WHERE Z_NUMBER=#{connection.quote(id)} GROUP BY SFRSTCR_TERM_CODE")
		end


	#END:QUERIES TO BANINST1.AWS_ONBOARDING_COURSE_REG


	#BEGIN: QUERIES TO BANINST1.AWS_ONBOARDING_FINAID
		def self.summer_five_questions(id)
			get = connection.exec_query("SELECT count(*) from BANINST1.AWS_ONBOARDING_FINAID_SUM_APPL WHERE Z_NUMBER=#{connection.quote(id)}")
		end


		def self.fin_aid_docs(id)
				get = connection.exec_query("SELECT fafsa_flg, rtvtreq_long_desc, rrrareq_sat_ind, 
					                         SARADAP_TERM_CODE_ENTRY,
											 SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
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
										     summer_app,
										     rtvtreq_code, 
										     rorstat_all_req_comp_date,
										     mpn_type, mpn_sat_ind
										     from BANINST1.AWS_ONBOARDING_FINAID_REQDOC WHERE Z_NUMBER=#{connection.quote(id)}										    
										     ORDER BY finaidyear desc , rtvtreq_long_desc asc")

		end


		def self.fafsa_flag_by_term(id,year)			 
			  case year
               when "2016-2017"
                  aidy = "1617"
               when "2015-2016"
                  aidy = "1516"
               else
                  aidy = ""
              end

			  get = connection.exec_query("SELECT fafsa_flg from BANINST1.AWS_ONBOARDING_FINAID_REQDOC 
											 WHERE Z_NUMBER=#{connection.quote(id)} 
											 AND RORSTAT_AIDY_CODE = #{connection.quote(aidy)} AND ROWNUM = 1")
		end


		def self.finaid_reqs_by_term(id,year)			 
			  case year
               when "2016-2017"
                  aidy = "1617"
               when "2015-2016"
                  aidy = "1516"
               else
                  aidy = ""
              end

			  get = connection.exec_query("SELECT rorstat_all_req_comp_date from BANINST1.AWS_ONBOARDING_FINAID_REQDOC 
											 WHERE Z_NUMBER=#{connection.quote(id)} 
											 AND RORSTAT_AIDY_CODE = #{connection.quote(aidy)}")
		end

		
		def self.finaid_tc_by_term(id,year)			 
			  case year
               when "2016-2017"
                  aidy = "1617"
               when "2015-2016"
                  aidy = "1516"
               else
                  aidy = ""
              end

			  get = connection.exec_query("SELECT rtvtreq_code, rrrareq_sat_ind from BANINST1.AWS_ONBOARDING_FINAID_REQDOC 
											 WHERE Z_NUMBER=#{connection.quote(id)} 
											 AND RORSTAT_AIDY_CODE = #{connection.quote(aidy)} 
											 AND rtvtreq_code='TERMS'
											 AND rrrareq_sat_ind='Y'")
		end

		
		def self.fin_aid_acceptance_by_term(id,year)			 
			  case year
               when "2016-2017"
                  aidy = "1617"
               when "2015-2016"
                  aidy = "1516"
               else
                  aidy = ""
              end

			  get = connection.exec_query("SELECT rpratrm_accept_date from BANINST1.AWS_ONBOARDING_FINAID_AWARDS 
											 WHERE Z_NUMBER=#{connection.quote(id)} 
											 AND RPRATRM_AIDY_CODE= #{connection.quote(aidy)}
											 AND rpratrm_accept_date is not null")
		end

		def self.fin_aid_mpm_by_term(id,year)			 
			  case year
               when "2016-2017"
                  aidy = "1617"
               when "2015-2016"
                  aidy = "1516"
               else
                  aidy = ""
              end

			  get = connection.exec_query("SELECT mpn_sat_ind from BANINST1.AWS_ONBOARDING_FINAID_REQDOC 
											 WHERE Z_NUMBER=#{connection.quote(id)} 
											 AND RRRAREQ_AIDY_CODE= #{connection.quote(aidy)}
											 AND mpn_sat_ind ='Y'")
		end

		def self.fin_aid_docs_multiterm(id,aidyear)
				get = connection.exec_query("SELECT fafsa_flg, rtvtreq_long_desc, rrrareq_sat_ind, mpm_type, SUBSTR( SARADAP_TERM_CODE_ENTRY, 1 , 4 ) as year,
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
										     summer_app,
										     rtvtreq_code, 
										     rorstat_all_req_comp_date
										     from BANINST1.AWS_ONBOARDING_FINAID_REQDOC WHERE Z_NUMBER=#{connection.quote(id)}
										     and RORSTAT_AIDY_CODE=#{connection.quote(aidyear)}
										     ORDER BY finaidyear desc , rtvtreq_long_desc asc")

		end

		def self.fin_aid_checkboxes(id)
			get = connection.exec_query("SELECT rtvtreq_code, rrrareq_sat_ind, rorstat_pckg_comp_date, rorstat_all_req_comp_date, rorstat_aidy_code, mpn_type, mpn_sat_ind from BANINST1.AWS_ONBOARDING_FINAID_REQDOC WHERE Z_NUMBER=#{connection.quote(id)} and rtvtreq_code in ('TERMS','ISIR') AND rorstat_all_req_comp_date is not null")
		end

		def self.fin_aid_acceptance(id)
			get = connection.exec_query("SELECT rpratrm_accept_date, rpratrm_period from BANINST1.AWS_ONBOARDING_FINAID_AWARDS WHERE Z_NUMBER=#{connection.quote(id)}")
		end


		def self.fin_aid_semesters(id)
			get = connection.exec_query("select distinct saradap_term_code_entry, summer_app, rorstat_aidy_code,  
											 CASE RORSTAT_AIDY_CODE 
										     	WHEN '1617' THEN '2016-2017'
										     	WHEN '1516' THEN '2015-2016'
										     	WHEN '1415' THEN '2014-2015'
										     END as finaidyear 
										 from BANINST1.AWS_ONBOARDING_FINAID_REQDOC WHERE Z_NUMBER=#{connection.quote(id)}
										 order by rorstat_aidy_code asc")
		end


		def self.distinct_fin_aid_semesters(id)
			get = connection.exec_query("select distinct rorstat_aidy_code, CASE RORSTAT_AIDY_CODE 
										     	WHEN '1617' THEN '2016-2017'
										     	WHEN '1516' THEN '2015-2016'
										     	WHEN '1415' THEN '2014-2015'
										     END as finaidyear
										 from BANINST1.AWS_ONBOARDING_FINAID_REQDOC WHERE Z_NUMBER=#{connection.quote(id)}
										 order by rorstat_aidy_code asc")
		end
	
		def self.residency_status(id)
			get = connection.exec_query("SELECT SGBSTDN_RESD_CODE, STATE from BANINST1.AWS_ONBOARDING_ADDRESS WHERE Z_NUMBER=#{connection.quote(id)}")
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
									    RPRATRM_OFFER_AMT, RPRATRM_DECLINE_AMT, rpratrm_cancel_amt,
									    TO_CHAR(RPRATRM_OFFER_DATE,'MM/DD/YYYY') as offerdate, 
									    TO_CHAR(RPRATRM_ACCEPT_DATE,'MM/DD/YYYY') as acceptdate, 
									    rpratrm_decline_date,
									    rpratrm_cancel_date
									    FROM BANINST1.AWS_ONBOARDING_FINAID_AWARDS
									    WHERE Z_NUMBER=#{connection.quote(id)} 
									    ORDER BY term, RFRBASE_FUND_TITLE ASC")
		end

		def self.fin_aid_awards_multiterm(id,aidyear)

			get = connection.exec_query("SELECT RFRBASE_FUND_TITLE, RPRATRM_PERIOD, 
												SUBSTR( RPRATRM_PERIOD, 1 , 4 ) as year,
   											  CASE SUBSTR(RPRATRM_PERIOD, 5 , 6 )
									             WHEN '01' THEN 'Spring'
									             WHEN '08' THEN 'Fall'
									             WHEN '05' THEN 'Summer'
									          ELSE ''
									      END as term,
									    RPRATRM_AIDY_CODE as finaidyear,
									    RPRATRM_OFFER_AMT, RPRATRM_DECLINE_AMT, rpratrm_cancel_amt,
									    TO_CHAR(RPRATRM_OFFER_DATE,'MM/DD/YYYY') as offerdate, 
									    TO_CHAR(RPRATRM_ACCEPT_DATE,'MM/DD/YYYY') as acceptdate, 
									    rpratrm_decline_date,
									    rpratrm_cancel_date
									    FROM BANINST1.AWS_ONBOARDING_FINAID_AWARDS
									    WHERE Z_NUMBER=#{connection.quote(id)} 
									    AND RPRATRM_AIDY_CODE=#{connection.quote(aidyear)}
									    ORDER BY term, RFRBASE_FUND_TITLE ASC")
		end


	#END:QUERIES TO BANINST1.AWS_ONBOARDING_FINAID

		def self.get_all_holds(id)
			get = connection.exec_query("SELECT Z_NUMBER, SPRHOLD_HLDD_CODE, STVHLDD_DESC from BANINST1.AWS_ONBOARDING_HOLD WHERE Z_NUMBER=#{connection.quote(id)} AND STVHLDD_REG_HOLD_IND = 'Y'")
		end
	

end