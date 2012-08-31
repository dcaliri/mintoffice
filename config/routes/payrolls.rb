Mintoffice::Application.routes.draw do
  resources :payroll_categories
  resources :payrolls do
    resources :payroll_items, path: "items"
  end
  resources :payroll_items
end