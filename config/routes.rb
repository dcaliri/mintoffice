Mintoffice::Application.routes.draw do
  if Rails.env == 'development' or Rails.env == 'test'
    namespace :test do
      resource :sessions, only: :show do
        match 'clear', :action => 'destroy', on: :collection
      end
    end
  end

  namespace :api do
    match 'login', controller: :accounts, action: :login

    resources :commutes do
      collection do
        post 'checkin'
        post 'checkout'
      end
    end

    resources :contacts

    namespace :bank_transactions do
      post 'export'
    end

    namespace :bank_transfers do
      post 'export'
    end

    namespace :card_used_sources do
      post 'export'
    end

    namespace :card_approved_sources do
      post 'export'
    end
  end

  scope nil, :module => 'section_enrollment' do
    resources :enrollments do
      collection do
        get :dashboard
      end

      member do
        get :attach_item
        post :attach
        delete :delete_attachment
      end
    end

    resources :enroll_reports

    match ':company_name/recruit' => 'enrollments#index'
  end

  resources :bankbooks

  resources :creditcards do
    collection do
      get 'total'
      get 'excel'
      post 'preview'
      post 'excel', :action => 'upload'
    end
  end
  resources :dayworkers do
    member do
      get 'find_contact'
      match 'select_contact'
    end
  end

  resources :payment_records

  resources :dayworker_taxes
  resources :card_used_sources do
    post 'export', on: :collection
  end
  resources :card_approved_sources do
    collection do
      post 'export'
      get 'cardbills/generate', action: :generate, as: :generate_cardbills
      post 'cardbills/generate', action: :generate_cardbills, as: :generate_cardbills
      get 'cardbills/empty', controller: :card_approved_sources, action: :find_empty_cardbills, as: :find_empty_cardbills
    end
  end

  resources :documents
  resources :projects, except: [:destroy] do
    collection do
      get 'me'
    end

    member do
      post :employee, action: 'add_employee'
      delete :employee, action: 'remove_employee'
      put :change_owner
    end
  end

  resources :pettycashes
  resources :permissions
  resources :cardbills

  resources :payroll_categories
  resources :payrolls do
    resources :payroll_items, path: "items"
  end
  resources :payroll_items
  resources :holidays

  post '/employees/retired/:id', :controller => "employees", :action => "retired", as: :retired
  post '/employees/try_retired/:id', :controller => "employees", :action => "try_retired", as: :try_retired

  resources :employees do
    collection do
      get 'find_contact'
    end

    member do
      get 'employment_proof', action: :new_employment_proof, as: :employment_proof
      post 'employment_proof', as: :employment_proof
    end

    resources :commutes do
      member do
        get 'detail'
      end
    end

    resources :vacations

    resources :projects do
      collection do
        get 'assign'
        post 'assign', action: 'assign_projects'
      end
    end

    resources :payments do
      collection do
        get 'yearly'
        post 'yearly', :action => 'create_yearly'

        get 'new_yearly'
        post 'calculate'
        post 'new_yearly', :action => 'create_new_yearly'
        get 'bonus'
      end
    end
  end

  resources :attachments do
    member do
      get 'picture', action: :picture, as: :picture
    end

    collection do
      post 'save', action: :save, as: :save
    end
  end

  get '/accounts/changepw/:account_id', :controller => 'accounts', :action => 'changepw_form'
  post '/accounts/changepw/:account_id', :controller => 'accounts', :action => 'changepw'

  resources :groups
  resources :accounts do
    collection do
      get 'login', as: :login
      get 'logout', as: :logout
      get 'my', as: :my

      get 'google_apps', as: :google_apps
      post 'authenticate', as: :authenticate
    end

    member do
      get 'changepw', action: :changepw_form
      post 'changepw'

      post 'create_google_apps', as: :google_apps, path: 'google_apps'
      post 'create_redmine', as: :redmine, path: 'redmine'

      delete 'remove_google_apps', as: :google_apps, path: 'google_apps'
      delete 'remove_redmine', as: :redmine, path: 'redmine'
    end

    resources :payments do
      collection do
        get 'yearly'
        post 'yearly', :action => 'create_yearly'

        get 'new_yearly'
        post 'calculate'
        post 'new_yearly', :action => 'create_new_yearly'
        get 'bonus'
      end
    end
  end

  match "/auth/:provider/callback" => "providers#create"

  resources :contacts do
    collection do
      get 'save', action: :save_form
      get 'load', action: :load_form
      post 'save'
      post 'load'
    end

    resources :contact_emails, :path => 'emails', :only => :destroy
    resources :contact_phone_numbers, :path => 'phones', :only => :destroy
    resources :contact_addresses, :path => 'addresses', :only => :destroy
    resources :contact_others, :path => 'others', :only => :destroy
  end

  resources :contact_address_tags, :only => [:new, :create]
  resources :contact_email_tags, :only => [:new, :create]
  resources :contact_phone_number_tags, :only => [:new, :create]
  resources :contact_other_tags, :only => [:new, :create]

  resources :payments, :only => [:index, :show]
  resources :commutes
  resources :vacations do
    resources :used_vacations, :path => "used" do
      put 'approve'
    end
  end

  resources :vacation_types

  resources :bank_accounts, path: 'banks' do
    get 'total', :on => :collection
  end

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

  resources :required_tags
  resources :namecards
  resources :business_clients, except: [:destroy] do
    resources :taxmen, :except => :index do
      collection do
        get 'find_contact'
        match 'select_contact'
      end

      member do
        get 'edit_contact'
        match 'update_contact'
      end
    end
  end

  resources :taxbills do
    get 'total', :on => :collection

    resources :taxbill_items, :path => "items"
  end

  resources :change_histories, path: 'histories'

  resources :tags, only: [:create, :destroy]

  resources :companies do
    post :switch, on: :collection
  end

  resources :expense_reports, path: 'expenses'

  match 'report' => 'reports#report', as: :report

  resources :ledger_accounts, path: 'ledgers'
  resources :postings

  post 'accessors', controller: :accessors, action: :create, as: :accessors
  delete 'accessors', controller: :accessors, action: :destroy, as: :accessors

  get 'except_columns' => "except_columns#new", as: :except_columns
  post 'except_columns' => "except_columns#create", as: :except_columns

  post 'load_except_columns' => "except_columns#load", as: :load_except_columns
  post 'save_except_columns' => "except_columns#save", as: :save_except_columns

  root to: 'main#index'

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end