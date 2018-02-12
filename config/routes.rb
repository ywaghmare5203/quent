Rails.application.routes.draw do
  
  get 'home/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  post 'auth/login', to: 'authentication#authenticate'
   post 'signup', to: 'users#create'
   get 'confirm_email' , to: 'authentication#confirm_email'
   post 'confirm' , to: 'authentication#confirm'
   post 'email_update' , to: 'authentication#email_update'
end
