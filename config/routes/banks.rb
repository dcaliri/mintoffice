Mintoffice::Application.routes.draw do
  resources :bank_accounts, path: 'banks' do
    get 'total', :on => :collection
  end

  resources :bankbooks

  resources :bank_transactions do
    collection do
      get 'verify'
      get 'excel'
      post 'preview'
      post 'export'
      post 'excel', :action => 'upload'
    end
  end

  resources :bank_transfers do
    collection do
      get 'excel'
      post 'preview'
      post 'export'
      post 'excel', :action => 'upload'
    end
  end

end