Mintoffice::Application.routes.draw do
  resources :creditcards do
    resources :card_used_sources, path: 'used' do
      collection do
        get 'excel'
        post 'excel', :action => 'upload'
      end
    end

    resources :card_approved_sources, path: 'approved' do
      collection do
        get 'excel'
        post 'excel', :action => 'upload'
      end
    end
  end

  resources :documents
  resources :projects
  resources :pettycashes
  resources :permissions
  resources :cardbills

  match '/hrinfos/retire/:id', :controller => "hrinfos", :action => "retire", :conditions => {:method => :get}
  match '/hrinfos/retire/:id', :controller => "hrinfos", :action => "retire_save", :conditions => {:method => :post}

  resources :hrinfos
  resources :attachments

  match '/users/changepw/:user_id', :controller => 'users', :action => 'changepw'
  match '/users/login', :controller => 'users', :action => 'login', :conditions => { :method => :get}
  match '/users/logout', :controller => 'users', :action => 'logout', :conditions => { :method => :get}
  match '/users/my', :controller => "users", :action => "my", :conditions => {:method => :get}

  resources :users do
    resources :payments do
      collection do
        get 'yearly'
        post 'yearly', :action => 'create_yearly'
      end
    end

    resources :commutes do
      collection do
        get 'go'
        post 'go', :action => 'go!'
      end

      member do
        get 'detail'
        get 'leave'
        put 'leave', :action => 'leave!'
      end
    end

    resources :vacations
  end

  match "/auth/:provider/callback" => "providers#create"

  resources :address_books

  resources :payments, :only => [:index, :show]
  resources :commutes
  resources :vacations do
    resources :used_vacations, :path => "used" do
      put 'approve'
    end
  end

  resources :bank_accounts, path: 'banks' do
    resources :bank_transactions, path: "transactions" do
      collection do
        get 'excel'
        post 'excel', :action => 'upload'
      end
    end

    resources :bank_transfers, path: "tranfers" do
      collection do
        get 'excel'
        post 'excel', :action => 'upload'
      end
    end
  end

  resources :required_tags
  resources :namecards
  resources :business_clients do
    resources :taxmen, :except => :index
  end

  resources :taxbills do
    get 'total', :on => :collection

    resources :taxbill_items, :path => "items"
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchas3e 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  root to: 'main#index'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end

# ActionController::Routing::Routes.draw do |map|
#   map.resources :creditcards
#
#   map.resources :documents
#
#   map.resources :projects
#
#   map.resources :pettycashes
#
#   map.resources :permissions
#
#   map.resources :cardbills
#
#   map.connect '/hrinfos/retire/:id', :controller => "hrinfos", :action => "retire", :conditions => {:method => :get}
#   map.connect '/hrinfos/retire/:id', :controller => "hrinfos", :action => "retire_save", :conditions => {:method => :post}
#   map.resources :hrinfos
#
#   map.resources :attachments
#
#   map.connect '/users/changepw/:user_id', :controller => 'users', :action => 'changepw'
#   map.connect '/users/login', :controller => 'users', :action => 'login', :conditions => { :method => :get}
#   map.connect '/users/logout', :controller => 'users', :action => 'logout', :conditions => { :method => :get}
#   map.connect '/users/my', :controller => "users", :action => "my", :conditions => {:method => :get}
#   map.resources :users
#
#   map.resources :required_tags
#
#   map.resources :namecards
#
#   # The priority is based upon order of creation: first created -> highest priority.
#
#   # Sample of regular route:
#   #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
#   # Keep in mind you can assign values other than :controller and :action
#
#   # Sample of named route:
#   #   map.purchas3e 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
#   # This route can be invoked with purchase_url(:id => product.id)
#
#   # Sample resource route (maps HTTP verbs to controller actions automatically):
#   #   map.resources :products
#
#   # Sample resource route with options:
#   #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
#
#   # Sample resource route with sub-resources:
#   #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
#
#   # Sample resource route with more complex sub-resources
#   #   map.resources :products do |products|
#   #     products.resources :comments
#   #     products.resources :sales, :collection => { :recent => :get }
#   #   end
#
#   # Sample resource route within a namespace:
#   #   map.namespace :admin do |admin|
#   #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
#   #     admin.resources :products
#   #   end
#
#   # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
#   # map.root :controller => "welcome"
#   map.root :controller => "main"
#
#   # See how all your routes lay out with "rake routes"
#
#   # Install the default routes as the lowest priority.
#   # Note: These default routes make all actions in every controller accessible via GET requests. You should
#   # consider removing or commenting them out if you're using named routes and resources.
#   map.connect ':controller/:action/:id'
#   map.connect ':controller/:action/:id.:format'
# end
