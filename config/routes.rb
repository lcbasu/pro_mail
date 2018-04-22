Rails.application.routes.draw do


  root 'mail_pages#inbox'

  get  '/inbox',    to: 'mail_pages#inbox'
  get  '/sent',   to: 'mail_pages#sent'
  get  '/draft', to: 'mail_pages#draft'
  get  '/trash', to: 'mail_pages#trash'
  get  '/compose', to: 'mail_pages#compose'


  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
