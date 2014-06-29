Rails.application.routes.draw do

  mount InPaymentSchedulex::Engine => "/in_payment_schedulex"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount MultiItemContractx::Engine => '/contractx'
  mount Kustomerx::Engine => '/kustomerx'
  mount Searchx::Engine => '/searchx'
  #mount InPaymentx::Engine => '/payment'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
