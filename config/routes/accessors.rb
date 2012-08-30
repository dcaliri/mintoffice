Mintoffice::Application.routes.draw do
  post 'accessors', controller: :accessors, action: :create, as: :accessors
  delete 'accessors', controller: :accessors, action: :destroy, as: :accessors
end