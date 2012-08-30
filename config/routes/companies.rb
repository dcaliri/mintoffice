Mintoffice::Application.routes.draw do
  resources :companies do
    post :switch, on: :collection
  end
end