InPaymentSchedulex::Engine.routes.draw do
  resources :receiving_schedules do
    collection do
      get :search
      get :search_results
    end
  end

  root :to => 'receiving_schedules#index'

end
