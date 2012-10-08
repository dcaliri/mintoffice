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

    namespace :api do
      post 'shinhan_card_used_histories/export', controller: 'card_histories', action: 'shinhan_card_used_histories'
      post 'shinhan_card_approved_histories/export', controller: 'card_histories', action: 'shinhan_card_approved_histories'
      post 'hyundai_card_used_histories/export', controller: 'card_histories', action: 'hyundai_card_used_histories'
      post 'hyundai_card_approved_histories/export', controller: 'card_histories', action: 'hyundai_card_approved_histories'
      post 'oversea_card_approved_histories/export', controller: 'card_histories', action: 'oversea_card_approved_histories'
    end
  end
end