class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    filename = Rails.root.join("config/routes#{@scope[:path]}", "#{routes_name}.rb")
    file = File.read(filename)

    instance_eval(file)
  end
end

Mintoffice::Application.routes.draw do
  draw :accessors
  draw :accounts
  draw :api
  draw :attachment
  draw :banks
  draw :business_clients
  draw :cards
  draw :commutes
  draw :companies
  draw :contacts
  draw :dayworkers
  draw :documents
  draw :employees
  draw :enrollments
  draw :except_columns
  draw :expense_reports
  draw :groups
  draw :histories
  draw :holiday
  draw :investments
  draw :ledger_accounts
  draw :namecards
  draw :payments
  draw :payrolls
  draw :permissions
  draw :pettycashes
  draw :projects
  draw :promissories
  draw :report
  draw :tags
  draw :taxbills
  draw :test
  draw :vacations

  resources :card_histories do
    collection do
      get 'raw'
      post 'generate', as: :generate

      post 'export'
      get 'cardbills/generate', action: :generate_form, as: :generate_form
      post 'cardbills/generate', action: :generate, as: :generate
      get 'cardbills/empty', action: :find_empty_cardbill, as: :find_empty_cardbill
    end
  end

  resources :shinhan_card_used_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :hyundai_card_used_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :shinhan_card_approved_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :hyundai_card_approved_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :oversea_card_approved_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  root to: 'main#index'

  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end