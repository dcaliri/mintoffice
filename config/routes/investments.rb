Mintoffice::Application.routes.draw do
  resources :investments, except: :index do
    resources :investment_estimations, path: 'estimations'
  end
end