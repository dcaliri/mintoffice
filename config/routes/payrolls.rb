Mintoffice::Application.routes.draw do
  resources :payroll_categories
  resources :payrolls do
    collection do
      get 'generate_form'
      post 'generate'

      post 'generate_payment_request'
    end

    resources :payroll_items, path: "items"
  end
  resources :payroll_items
end