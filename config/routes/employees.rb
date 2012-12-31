Mintoffice::Application.routes.draw do
  post '/employees/retired/:id', :controller => "employees", :action => "retired", as: :retired
  post '/employees/try_retired/:id', :controller => "employees", :action => "try_retired", as: :try_retired

  resources :employees do
    collection do
      get 'find_contact'
    end

    member do
      get 'employment_proof', action: :new_employment_proof, as: :employment_proof
      get 'retire', action: :retire, as: :retire
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
end