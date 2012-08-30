Mintoffice::Application.routes.draw do
  resources :taxbills do
    collection do
      get 'excel'
      post 'preview'
      post 'import'

      get 'total'
    end

    member do
      get 'payment_request'
    end

    resources :taxbill_items, :path => "items"
  end
end