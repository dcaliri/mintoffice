Mintoffice::Application.routes.draw do
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

  get '/accounts/changepw/:account_id', :controller => 'accounts', :action => 'changepw_form'
  post '/accounts/changepw/:account_id', :controller => 'accounts', :action => 'changepw'
end