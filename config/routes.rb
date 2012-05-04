Mintoffice::Application.routes.draw do
  namespace :api do
    match 'login', controller: :users, action: :login
#    post 'commutes', controller: :commutes, action: :create

    resources :commutes do
      collection do
        post 'checkin'
        post 'checkout'
      end
    end
  end

  resources :creditcards do
    collection do
      get 'total'
      get 'excel'
      post 'preview'
      post 'excel', :action => 'upload'
    end

    resources :card_used_sources, path: 'used' do
      collection do
        get 'excel'
        post 'preview'
        post 'excel', :action => 'upload'
      end
    end

    resources :card_approved_sources, path: 'approved' do
      collection do
        get 'excel'
        post 'preview'
        post 'excel', :action => 'upload'
      end
    end
  end

  resources :documents
  resources :projects
  resources :pettycashes
  resources :permissions
  resources :cardbills
  resources :payroll_categories
  resources :payrolls do
    resources :payroll_items, path: "items"
  end 
  resources :payroll_items

  match '/hrinfos/retire/:id', :controller => "hrinfos", :action => "retire", :conditions => {:method => :get}
  match '/hrinfos/retire/:id', :controller => "hrinfos", :action => "retire_save", :conditions => {:method => :post}

  resources :hrinfos
  resources :attachments

  match '/users/changepw/:user_id', :controller => 'users', :action => 'changepw'
  match '/users/login', :controller => 'users', :action => 'login', :conditions => { :method => :get}
  match '/users/logout', :controller => 'users', :action => 'logout', :conditions => { :method => :get}
  match '/users/my', :controller => "users", :action => "my", :conditions => {:method => :get}

  resources :users do
    resources :payments do
      collection do
        get 'yearly'
        post 'yearly', :action => 'create_yearly'
      end
    end

    resources :commutes do
      collection do
        get 'go'
        post 'go', :action => 'go!'
      end

      member do
        get 'detail'
        get 'leave'
        put 'leave', :action => 'leave!'
      end
    end

    resources :vacations
  end

  match "/auth/:provider/callback" => "providers#create"

  resources :contacts do
    get 'find', :action => :find, :on => :collection
#    put 'select', :action => :select, :on => :member
    get 'select', :action => :select, :on => :member

    resources :contact_emails, :path => 'emails', :only => :destroy
    resources :contact_phone_numbers, :path => 'phones', :only => :destroy
    resources :contact_addresses, :path => 'addresses', :only => :destroy
  end

  resources :contact_address_tags, :only => [:new, :create]
  resources :contact_email_tags, :only => [:new, :create]
  resources :contact_phone_number_tags, :only => [:new, :create]

  resources :payments, :only => [:index, :show]
  resources :commutes
  resources :vacations do
    resources :used_vacations, :path => "used" do
      put 'approve'
    end
  end

  resources :bank_accounts, path: 'banks' do
    get 'total', :on => :collection
    resources :bank_transactions, path: "transactions" do
      collection do
        get 'excel'
        post 'preview'
        post 'excel', :action => 'upload'
      end
    end

    resources :bank_transfers, path: "transfers" do
      collection do
        get 'excel'
        post 'preview'
        post 'excel', :action => 'upload'
      end
    end
  end

  resources :required_tags
  resources :namecards
  resources :business_clients do
    resources :taxmen, :except => :index
  end

  resources :taxbills do
    get 'total', :on => :collection

    resources :taxbill_items, :path => "items"
  end

  root to: 'main#index'

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end