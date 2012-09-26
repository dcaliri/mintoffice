Mintoffice::Application.routes.draw do
  resources :payments, :only => [:index, :show]

  resources :payment_records do
    member do
      get 'payment_request'
    end
  end

  resources :payment_requests do
    member do
      put 'complete'
    end

    collection do
      post 'export'
      put 'complete', action: :complete_all
    end
  end
end