Rails.application.routes.draw do

  mount InPaymentSchedulex::Engine => "/in_payment_schedulex"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount MultiItemContractx::Engine => '/contractx'
  mount Kustomerx::Engine => '/kustomerx'
  mount Searchx::Engine => '/searchx'
  mount AdResourceOrderx::Engine => '/res_order'
  mount BizWorkflowx::Engine => '/workflow'
  mount StateMachineLogx::Engine => '/wf_log'
  mount AdResourcex::Engine => '/resource'
  mount Supplierx::Engine => '/supplier'
  
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
