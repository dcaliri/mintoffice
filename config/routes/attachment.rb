Mintoffice::Application.routes.draw do
  resources :attachments do
    member do
      get 'picture', action: :picture, as: :picture
      get 'download', as: :download
    end

    collection do
      post 'save', action: :save, as: :save
    end
  end
end