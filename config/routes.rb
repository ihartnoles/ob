Ob::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  #root 'static_pages#login'
  root :to => 'static_pages#main'
  resources :messages
  mount Ckeditor::Engine => '/ckeditor'
  #resources :housing_zipcodes
  resources :activity_logs
  get       '/activity_log/:znum',  to: 'activity_logs#showlogs'
  resources :ftic_modules_availables , :path => "fticadmin"
  
  #static actions
   get    '/main',             to: 'static_pages#main'
   get    '/home',             to: 'static_pages#home'
   get    '/unauthorized',     to: 'static_pages#unauthorized'
   get    '/transfer',         to: 'static_pages#transfer'
   get    '/gatewayed_home',   to: 'static_pages#gatewayed_home'
   get    '/login',            to: 'login#login'
   match  '/do_manual_login',  to: 'login#do_manual_login', via: 'post'
   get    '/do_manual_login',  to: 'login#do_manual_login'
   get    '/fticsync/',        to: 'static_pages#fticsync'
   match  '/zipcode/',         to: 'static_pages#calc_distance', via: 'post'
   get    '/zipcode',          to: 'static_pages#calc_distance'
   get    '/dashboard/:type',  to: 'static_pages#dashboard'
   get    '/dashdata/',        to: 'static_pages#dashdata'
   post   '/dashdata/',        to: 'static_pages#dashdata'
   get    '/dashstats/',       to: 'static_pages#dashstats'
   get    '/messages/new/:znum',    to: 'messages#new'
   get    '/moduledetail/:id/:znum',    to: 'ftic_modules_availables#moduledetail'

   post   '/save_decline',           to: 'declines#save_decline'
   post   '/save_verify_info',       to: 'verify#save_verify_info'
   post   '/save_communication',     to: 'communications#save_communication'
   post   '/save_lc',                to: 'communities#save_lc'

   post   'update_ftic_verify_module',  to: 'ftic_modules_availables#update_ftic_verify_module'
   get    'update_ftic_verify_module',  to: 'ftic_modules_availables#update_ftic_verify_module'

   post   'update_ftic_account_module',  to: 'ftic_modules_availables#update_ftic_account_module'
   post   'update_ftic_deposit_module',  to: 'ftic_modules_availables#update_ftic_deposit_module'
   post   'update_ftic_communication_module',  to: 'ftic_modules_availables#update_ftic_communication_module'
   
   post   'update_ftic_immunization_module',  to: 'ftic_modules_availables#update_ftic_immunization_module'
   get    'update_ftic_immunization_module',  to: 'ftic_modules_availables#update_ftic_immunization_module'
   
   post   'update_ftic_residency_module',  to: 'ftic_modules_availables#update_ftic_residency_module'
   post   'update_ftic_finaid_module',  to: 'ftic_modules_availables#update_ftic_finaid_module'
   post   'update_ftic_finaidalt_module',  to: 'ftic_modules_availables#update_ftic_finaidalt_module'
   post   'update_ftic_housing_module',  to: 'ftic_modules_availables#update_ftic_housing_module'
   post   'update_ftic_aleks_module',  to: 'ftic_modules_availables#update_ftic_aleks_module'

   post   'update_ftic_orientation_module',  to: 'ftic_modules_availables#update_ftic_orientation_module'
   get    'update_ftic_orientation_module',  to: 'ftic_modules_availables#update_ftic_orientation_module'
   
   post   'update_ftic_learning_module',  to: 'ftic_modules_availables#update_ftic_learning_module'
   get    'update_ftic_learning_module',  to: 'ftic_modules_availables#update_ftic_learning_module'

   post   'update_ftic_oars_module',  to: 'ftic_modules_availables#update_ftic_oars_module'
   post   'update_ftic_reg_module',  to: 'ftic_modules_availables#update_ftic_reg_module'
   post   'update_ftic_tuition_module',  to: 'ftic_modules_availables#update_ftic_tuition_module'
   post   'update_ftic_emergency_module',  to: 'ftic_modules_availables#update_ftic_emergency_module'
   post   'update_ftic_alert_module',  to: 'ftic_modules_availables#update_ftic_alert_module'
   post   'update_ftic_owlcard_module',  to: 'ftic_modules_availables#update_ftic_owlcard_module'   
   post   'update_ftic_book_module',  to: 'ftic_modules_availables#update_ftic_book_module'   
   post   'update_ftic_vehicle_module',  to: 'ftic_modules_availables#update_ftic_vehicle_module'   

   # get    'sms', to: 'static_pages#sms'

   match '*a', :to => 'static_pages#routing_error'
end