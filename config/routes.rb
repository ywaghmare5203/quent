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
   post 'user_update' , to: 'authentication#update'
   get 'user_profile', to:  'authentication#user_profile'
   post 'upload_media', to:  'authentication#upload_media'

   post 'password/forgot', to: 'passwords#forgot'
   post 'password/reset', to: 'passwords#reset'
   put 'password/update', to: 'passwords#update'
   get 'allinterest', to: 'interest#index'
   post 'user_interest_create', to: 'interest#create'
   get 'allquestions', to: 'question#index'
   post 'user_question_answer' , to: 'question#create'
   post 'question_create' , to: 'question#ques_create'
   post 'option_create' , to: 'question#option_create'

   #resources :interest
   
end


#http :3000/todos Accept:'application/vnd.todos.v1+json' Authorization:'eyJ0...nLw2bYQbK0g'
#user_id | interest_id