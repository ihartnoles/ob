Ob::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  

  #root 'static_pages#login'
  root :to => 'static_pages#main'

  resources :messages

  mount Ckeditor::Engine => '/ckeditor'
  resources :housing_zipcodes

  resources :activity_logs
  get       '/activity_log/:znum',  to: 'activity_logs#znumber'

  resources :ftic_modules_availables , :path => "fticadmin"

  #static actions
   get    '/main',             to: 'static_pages#main'
   get    '/home',             to: 'static_pages#home'
   get    '/unauthorized',     to: 'static_pages#unauthorized'  
   get    '/gatewayed_home',   to: 'static_pages#gatewayed_home'
   get    '/login',            to: 'login#login'
   match  '/do_manual_login',  to: 'login#do_manual_login', via: 'post'
   get    '/do_manual_login',  to: 'login#do_manual_login'
   get    '/fticsync/',        to: 'static_pages#fticsync'
   match  '/zipcode/',         to: 'static_pages#calc_distance', via: 'post'
   get    '/zipcode',          to: 'static_pages#calc_distance'
   get    '/dashboard/:type',  to: 'static_pages#dashboard'
   get    '/messages/new/:znum',    to: 'messages#new'
   get    '/moduledetail/:id/:znum',    to: 'ftic_modules_availables#moduledetail'
end
