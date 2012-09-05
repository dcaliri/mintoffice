Mintoffice::Application.routes.draw do
  resources :promissories, except: :index
end