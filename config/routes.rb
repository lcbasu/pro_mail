Rails.application.routes.draw do


  root 'mail_pages#inbox'

  get  '/inbox',    to: 'mail_pages#inbox'
  get  '/sent',   to: 'mail_pages#sent'
  get  '/draft', to: 'mail_pages#draft'
  get  '/trash', to: 'mail_pages#trash'
  get  '/compose', to: 'mail_pages#compose'
  
  get  '/edit_draft', to: 'emails#edit_draft'
  get  '/save', to: 'emails#save_draft'
  get  '/reply', to: 'emails#reply'
  get  '/forward', to: 'emails#forward'
  get  '/delete', to: 'emails#delete_mail'


  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :emails
end
