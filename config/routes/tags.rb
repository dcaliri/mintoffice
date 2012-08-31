Mintoffice::Application.routes.draw do
  resources :tags, only: [:create, :destroy]
  resources :required_tags
end