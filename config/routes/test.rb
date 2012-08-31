Mintoffice::Application.routes.draw do
  if Rails.env == 'development' or Rails.env == 'test'
    namespace :test do
      resource :sessions, only: :show do
        match 'clear', :action => 'destroy', on: :collection
      end
    end
  end
end