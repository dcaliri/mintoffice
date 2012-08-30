Mintoffice::Application.routes.draw do
  resources :documents do
    member do
      get 'find_employee'
      get 'link_employee'
    end
  end
end