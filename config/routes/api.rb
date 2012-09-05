Mintoffice::Application.routes.draw do
  namespace :api do
    match 'login', controller: :accounts, action: :login

    resources :commutes do
      collection do
        post 'checkin'
        post 'checkout'
      end
    end

    resources :contacts

    namespace :bank_transactions do
      post 'export'
    end

    namespace :bank_transfers do
      post 'export'
    end

    namespace :card_used_sources do
      post 'export'
    end

    namespace :card_approved_sources do
      post 'export'
    end
  end
end