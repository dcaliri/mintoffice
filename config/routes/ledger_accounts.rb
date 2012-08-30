Mintoffice::Application.routes.draw do
  resources :ledger_accounts, path: 'ledgers'
  resources :postings
end