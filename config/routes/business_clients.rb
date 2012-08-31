Mintoffice::Application.routes.draw do
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
end