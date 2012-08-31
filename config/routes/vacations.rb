Mintoffice::Application.routes.draw do
  resources :vacations do
    resources :used_vacations, :path => "used" do
      put 'approve'
    end
  end

  resources :vacation_types
end