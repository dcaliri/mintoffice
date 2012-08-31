Mintoffice::Application.routes.draw do
  get 'except_columns' => "except_columns#new", as: :except_columns
  post 'except_columns' => "except_columns#create", as: :except_columns

  post 'load_except_columns' => "except_columns#load", as: :load_except_columns
  post 'save_except_columns' => "except_columns#save", as: :save_except_columns
end