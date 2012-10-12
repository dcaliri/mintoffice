Mintoffice::Application.routes.draw do
  resources :assets do
    put 'return', on: :member
  end
end