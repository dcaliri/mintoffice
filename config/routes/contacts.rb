Mintoffice::Application.routes.draw do
  resources :contacts do
    collection do
      get 'save', action: :save_form
      get 'load', action: :load_form
      post 'save'
      post 'load'

      get 'find_duplicate'
      delete 'merge'
    end

    resources :contact_emails, :path => 'emails', :only => :destroy
    resources :contact_phone_numbers, :path => 'phones', :only => :destroy
    resources :contact_addresses, :path => 'addresses', :only => :destroy
    resources :contact_others, :path => 'others', :only => :destroy
  end

  resources :contact_address_tags, :only => [:new, :create]
  resources :contact_email_tags, :only => [:new, :create]
  resources :contact_phone_number_tags, :only => [:new, :create]
  resources :contact_other_tags, :only => [:new, :create]
end