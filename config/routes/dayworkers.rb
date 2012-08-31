Mintoffice::Application.routes.draw do
  resources :dayworkers do
    member do
      get 'find_contact'
      match 'select_contact'
    end
  end

  resources :dayworker_taxes do
    member do
      get 'payment_request'
    end
  end
end