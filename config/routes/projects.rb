Mintoffice::Application.routes.draw do
  resources :projects, except: [:destroy] do
    member do
      post :participant, action: 'add_participant'
      delete :participant, action: 'remove_participant'
      put :change_owner
    end
  end
end